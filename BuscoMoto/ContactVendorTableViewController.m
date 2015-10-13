//
//  ContactVendorTableViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "ContactVendorTableViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "SKKeyboardResigner.h"
#import "ParallaxHeaderView.h"

@implementation ContactVendorTableViewController

-(void)viewDidLoad{
    CGFloat width   = self.tableView.frame.size.width;
    CGFloat height  = self.tableView.frame.size.width/2.81690141;
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"listing_image"] forSize:CGSizeMake(width, height)];
    
    // Set user data
    NSString *name   = _listing.user.name;
    NSString *phones = _listing.user.phone1;
    
    if(_listing.user.phone2.length > 0){
        phones = [NSString stringWithFormat:@"%@ - %@", _listing.user.phone1, _listing.user.phone2];
    }
    
    NSString *text = [NSString stringWithFormat:@"%@ \n %@",
                      name,
                      phones];
    
    // Define general attributes for the entire text
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor whiteColor],
                              NSFontAttributeName: [UIFont systemFontOfSize:24 weight:500]
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    
    // Name attributes
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:17]}
                            range:[text rangeOfString:phones]];
    
    [headerView.headerTitleLabel setAttributedText:attributedText];
    [headerView.headerTitleLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:_listing.user.imageURL]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                // do something with image
                                [headerView setHeaderImage:image];
                            }
                        }];
    
    [self.tableView setTableHeaderView:headerView];
    
    _sendButton.layer.cornerRadius = 2;
    
    // Set TF delegates
    [_messageName setDelegate:self];
    [_messageName setTag:1];
    [_messageEmail setDelegate:self];
    [_messageEmail setTag:2];
    [_messagePhone setDelegate:self];
    [_messagePhone setTag:3];
    
    // User data from nsuserdefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"user_name"]){
        [_messageName setText:[defaults objectForKey:@"user_name"]];
        [_messagePhone setText:[defaults objectForKey:@"user_phone"]];
        [_messageEmail setText:[defaults objectForKey:@"user_email"]];
    }
    
    [SKKeyboardResigner attachObserverToView:self.view textFieldsToObserve:_messageName, _messageEmail, _messagePhone, _messageText, nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}



- (IBAction)sendMessage:(id)sender {
    [KVNProgress showProgress:0.1 status:@"Enviando"];
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *params = @{@"name"        : _messageName.text,
                             @"email"       : _messageEmail.text,
                             @"phone"       : _messagePhone.text,
                             @"comments"    : _messageText.text,
                             @"listing_id"  : _listing.objectID,
                             @"uuid"        : uuid,
                             };
    NSString *errors = [self verifyParams:params];
    if(errors.length > 1){
        [KVNProgress showErrorWithStatus:errors];
        return;
    }
    
    [KVNProgress showProgress:0.4];
    [[BMCONoAUTHAPIManager sharedInstance] POSTMessageWithParams:params onCompletion:^(id message, NSError *error){
        if(!error){
            NSLog(@"Mensaje enviado: %@", message);
            [KVNProgress showSuccessWithStatus:@"Mensaje enviado"];
            
            // Show you have already contacted vendor
            [_messageName setEnabled:NO];
            [_messageEmail setEnabled:NO];
            [_messagePhone setEnabled:NO];
            [sender setTitle:@"Ya contactaste al vendedor hoy" forState:UIControlStateDisabled];
            [sender setEnabled:NO];
            // Save data to keychain if user not logged in
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if(![defaults objectForKey:@"user_name"]){
                NSLog(@"Entered");
                [defaults setObject:_messageName.text forKey:@"user_name"];
                [defaults setObject:_messageEmail.text forKey:@"user_email"];
                [defaults setObject:_messagePhone.text forKey:@"user_phone"];
                [defaults synchronize];
            }
        }else{
            int code = (int)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            if(code == 420){
                [KVNProgress showErrorWithStatus:@"Ya contactaste al vendedor hoy"];
                NSLog(@"Already contacted vendor");
                
                [_messageName setEnabled:NO];
                [_messageEmail setEnabled:NO];
                [_messagePhone setEnabled:NO];
                [_messageText setEditable:NO];
                [sender setTitle:@"Ya contactaste al vendedor hoy" forState:UIControlStateDisabled];
                [sender setEnabled:NO];
            }else{
                [KVNProgress showErrorWithStatus:@"Error al enviar mensaje"];
                NSLog(@"Error sending message: %d", code);
            }
        }
    }];
}

- (NSString*)verifyParams:(NSDictionary*) params{
    
    NSString *error = @"";
    NSString *name = [params objectForKey:@"name"];
    NSString *email = [params objectForKey:@"email"];
    NSString *phone = [params objectForKey:@"phone"];
    NSString *comments = [params objectForKey:@"comments"];
    
    if(name.length < 4){
        error = [NSString stringWithFormat:@"%@ \n%@", error, @"* Verifica tu nombre."];
    }
    
    if(![email isValidEmail]){
        error = [NSString stringWithFormat:@"%@ \n%@", error, @"* Verifica tu correo electronico."];
    }
    
    if(phone.length < 7 || phone.length > 15){
        error = [NSString stringWithFormat:@"%@ \n%@", error, @"* Verifica tu numero de telefono."];
    }
    
    if(comments.length < 15){
        error = [NSString stringWithFormat:@"%@ \n%@", error, @"* Debes escribir un mensaje de más de 15 caracteres."];
    }
    
    return error;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [(ParallaxHeaderView*)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

#pragma Textview Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == 1 && textField.text.length < 5){
        NSLog(@"Entered");
        [textField setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1]];
    }else if(textField.tag == 1){
        [textField setBackgroundColor:[UIColor whiteColor]];
    }
    
    if(textField.tag == 2 && ![textField.text isValidEmail]){
        [textField setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1]];
    }else if(textField.tag == 2){
        [textField setBackgroundColor:[UIColor whiteColor]];
    }
    
    if(textField.tag == 3 && (textField.text.length < 7 || textField.text.length > 15)){
        [textField setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1]];
    }else if(textField.tag == 3){
        [textField setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return @"Contactar Vendedor";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return [UIColor whiteColor];
}

@end
