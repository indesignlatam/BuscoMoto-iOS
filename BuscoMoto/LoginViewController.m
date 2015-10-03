//
//  LoginViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/23/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "IDCAuthManager.h"
#import "LoginViewController.h"
#import "BMCOAPIManager.h"

#import "User.h"

@implementation LoginViewController

static NSString * const K_KEYCHAIN_STORE = @"com.IDC.BMCO";

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_5_OR_LESS (SCREEN_MAX_LENGTH <= 568.0)


- (void)viewDidLoad{
    [super viewDidLoad];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:K_KEYCHAIN_STORE];

    // Textfield views
    [_loginUsername setText:[store stringForKey:@"username"]];
    [_loginUsername setTag:1];
    [_loginUsername enablesReturnKeyAutomatically];
    [_loginUsername setDelegate:self];
    [_loginPassword setText:[store stringForKey:@"password"]];
    [_loginPassword setTag:2];
    [_loginPassword enablesReturnKeyAutomatically];
    [_loginPassword setDelegate:self];
    
    [SKKeyboardResigner attachObserverToView:self.view textFieldsToObserve:_loginUsername, _loginPassword, nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (IBAction)login:(id)sender {
    // Adds a status below the circle
    [KVNProgress showProgress:0.0f status:@"Cargando"];
    
    //Validate the data from the fields
    NSString *username = _loginUsername.text;
    NSString *password = _loginPassword.text;
    if([username length]>4 && [password length]>6){
        [self.view endEditing:YES];
        [self validateUser:sender];
    }else{
        [self.view endEditing:YES];
        [KVNProgress showErrorWithStatus:@"Debes llenar los campos de usuario y contraseña"];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createAccount:(id)sender {
    [(XLPagerTabStripViewController *)self.parentViewController moveToViewControllerAtIndex:1 animated:YES];
}

- (void)validateUser:(UIButton *)sender{
    [KVNProgress showProgress:0.1f status:@"Cargando"];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:K_KEYCHAIN_STORE];
    
    
    [[IDCAuthManager sharedInstance] authorizeUser:_loginUsername.text password:_loginPassword.text onSuccess:^(AFOAuthCredential *credential) {
        [KVNProgress showProgress:0.3f status:@"Sesión Iniciada"];
        NSLog(@"User logged in and tokens saved");
        
        [[BMCOAPIManager sharedInstance] GETUserWithEmail:_loginUsername.text onCompletion:^(User *user, NSError *error){
            [KVNProgress showProgress:0.5f status:@"Cargando datos de usuario"];
            //
            if([user isKindOfClass:[User class]]){
                NSLog(@"User retrived");
                [KVNProgress showProgress:0.8f status:@"Cargando datos de usuario"];
                // Save the app username and password to keychain
                [store setString:_loginUsername.text forKey:@"username"];
                [store setString:_loginPassword.text forKey:@"password"];
                // Show success and dismiss modal
                [KVNProgress showSuccessWithStatus:@"Success" completion:^(){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                NSLog(@"User is not a user model");
                [KVNProgress showErrorWithStatus:@"Error al cargar datos de usuario"];
            }
        }];
        
        
    }onFailure:^(NSString *error) {
        NSLog(@"Error: %@", error);
        [KVNProgress showErrorWithStatus:@"Alguno de los datos es incorrecto"];
    }];
}

#pragma Textfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == 2){
        [textField resignFirstResponder];
        [self login:nil];
    }else if (textField.tag == 1){
        [_loginPassword becomeFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField*)textfield up:(BOOL)up{
    if(true){
        const int moveDist = 60;
        const float moveDuration = 0.3f;
        
        int movement = (up ? -moveDist : moveDist);
        
        [UIView beginAnimations:@"anim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:moveDuration];
        [self.view setFrame:CGRectOffset(self.view.frame, 0, movement)];
        [UIView commitAnimations];
    }
}


#pragma mark - XLPagerTabStripViewControllerDelegate
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return @"Login";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return [UIColor whiteColor];
}

@end
