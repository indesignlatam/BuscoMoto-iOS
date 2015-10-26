//
//  ProfileTableViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/15/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "EAIntroView.h"
#import "LoginRegisterPagerViewController.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

static NSString * const K_KEYCHAIN_STORE = @"com.IDC.BMCO";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Perfil de Usuario"];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:K_KEYCHAIN_STORE];
    NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
    _user = [User MR_findFirstByAttribute:@"userID" withValue:[f numberFromString:[store stringForKey:@"userID"]]];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(saveProfile:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    
    [_cellName.textLabel setText:@"Nombre"];
    [_cellEmail.textLabel setText:@"Correo"];
    [_cellPhone1.textLabel setText:@"Telefono"];
    [_cellPhone2.textLabel setText:@"Telefono 2"];
    [_cellAddress.textLabel setText:@"Dirección"];
    [_descriptionTextView setPlaceholder:@"Descripción"];
    
    if(_user){
        [_cellName.detailTextLabel setText:_user.name];
        [_cellEmail.detailTextLabel setText:_user.email];
        [_cellPhone1.detailTextLabel setText:_user.phone1];
        [_cellPhone2.detailTextLabel setText:_user.phone2];
        [_cellAddress.detailTextLabel setText:@""];
        [_descriptionTextView setText:_user.descriptionText];
    }else{
        [_cellName.detailTextLabel setText:@""];
        [_cellEmail.detailTextLabel setText:@""];
        [_cellPhone1.detailTextLabel setText:@""];
        [_cellPhone2.detailTextLabel setText:@""];
        [_cellAddress.detailTextLabel setText:@""];
        [_descriptionTextView setText:@""];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        NSLog(@"NOT AUTHORIZED");
        [self showIntro];
    }else{
        NSLog(@"AUTHORIZED");
        // GET USER DATA
        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:K_KEYCHAIN_STORE];
        NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
        _user = [User MR_findFirstByAttribute:@"userID" withValue:[f numberFromString:[store stringForKey:@"userID"]]];
        
        // SHOW USER DATA
        [_cellName.detailTextLabel setText:_user.name];
        [_cellEmail.detailTextLabel setText:_user.email];
        [_cellPhone1.detailTextLabel setText:_user.phone1];
        [_cellPhone2.detailTextLabel setText:_user.phone2];
        [_cellAddress.detailTextLabel setText:@""];
        [_descriptionTextView setText:_user.descriptionText];
        
        
        // REMOVE INTRO VIEW
        UIView *view = [self.tableView viewWithTag:1991];
        if(view){
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.width/1.777777)];
        CGFloat width   = self.tableView.frame.size.width;
        CGFloat height  = self.tableView.frame.size.width/1.777777777;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [img setContentMode:UIViewContentModeScaleAspectFit];
        [img setImage:[UIImage imageNamed:@"listing_image"]];
        [img setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActions)];
        [img addGestureRecognizer:singleFingerTap];
        
        // Add image to view
        [view addSubview:img];
        
        return view;
    }
    
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return tableView.frame.size.width/1.777777;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Nombre" message:@"Escribe tus nombres y apellidos" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
//                [textField setText:_cellPrice.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 11;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 4 || [alert.textFields firstObject].text.length > 50){
                    // Invalid price input
                    [_cellName.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellName setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellName.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellName.textLabel setTextColor:[UIColor blackColor]];
                    [_cellName.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellName setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Correo Electronico" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                //                [textField setText:_cellPrice.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 11;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 4 || [alert.textFields firstObject].text.length > 50){
                    // Invalid price input
                    [_cellEmail.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellEmail setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellEmail.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellEmail.textLabel setTextColor:[UIColor blackColor]];
                    [_cellEmail.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellEmail setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 2){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Telefono Principal" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                //                [textField setText:_cellPrice.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 11;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 4 || [alert.textFields firstObject].text.length > 50){
                    // Invalid price input
                    [_cellPhone1.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellPhone1 setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellPhone1.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellPhone1.textLabel setTextColor:[UIColor blackColor]];
                    [_cellPhone1.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellPhone1 setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 3){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Telefono Secundario" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                //                [textField setText:_cellPrice.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 11;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 4 || [alert.textFields firstObject].text.length > 50){
                    // Invalid price input
                    [_cellPhone2.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellPhone2 setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellPhone2.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellPhone2.textLabel setTextColor:[UIColor blackColor]];
                    [_cellPhone2.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellPhone2 setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 4){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Dirección" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                //                [textField setText:_cellPrice.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 11;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 4 || [alert.textFields firstObject].text.length > 50){
                    // Invalid price input
                    [_cellPhone2.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellPhone2 setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellPhone2.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                }else{
                    [_cellPhone2.textLabel setTextColor:[UIColor blackColor]];
                    [_cellPhone2.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellPhone2 setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}


- (void)saveProfile:(id)sender{
    [KVNProgress showProgress:0.1f status:@"Guardando Perfíl"];
    
    if(_descriptionTextView.text.length == 0){
        [_descriptionTextView setText:@""];
    }
    
    NSDictionary *params = @{@"name" : _cellName.detailTextLabel.text,
                             @"email" : _cellEmail.detailTextLabel.text,
                             @"phone_1" : _cellPhone1.detailTextLabel.text,
                             @"phone_2" : _cellPhone2.detailTextLabel.text,
                             @"address" : _cellAddress.detailTextLabel.text,
                             @"description" : _descriptionTextView.text,
                             };
    
    [KVNProgress showProgress:0.3f status:@"Guardando Perfíl"];
    
    [[BMCOAPIManager sharedInstance]PUTUser:_user.userID withParams:params onCompletion:^(id user, NSError *error){
        if(!error && user){
            [JDStatusBarNotification showWithStatus:@"Información Guardada Exitosamente" dismissAfter:3];
        }else{
            [KVNProgress showErrorWithStatus:@"Error al guardar la información"];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImageActions{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setTitle:@"Foto de Perfil"];
    [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    [actionSheet setDelegate:self];
    [actionSheet addButtonWithTitle:@"Subir foto"];
    [actionSheet addButtonWithTitle:@"Editar"];
    [actionSheet addButtonWithTitle:@"Eliminar"];
    
    [actionSheet setCancelButtonIndex: [actionSheet addButtonWithTitle:@"Cancelar"]];
    [actionSheet showInView:self.tabBarController.view];
}


#pragma NOT LOGGED IN VIEW
- (void)showIntro{
    CGRect frame = self.tableView.frame;
    frame.origin.y = 0;
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setTag:1991];
    [view setBackgroundColor:[UIColor successColor]];
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:view.frame];
    [bg setImage:[UIImage imageNamed:@"bg_image_profile"]];
    [bg setContentMode:UIViewContentModeScaleAspectFill];
    [view addSubview:bg];
    
    frame.size.height = (frame.size.height/10)*3.5;
    frame.size.width = (frame.size.width/10)*8;
    frame.origin.y = self.tableView.frame.size.height-frame.size.height-30;
    frame.origin.x = (self.tableView.frame.size.width-frame.size.width)/2;
    UIView *textContainer = [[UIView alloc]initWithFrame:frame];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, frame.size.width-40, 30)];
    [title setText:@"Perfíl de usuario"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:20]];
    [title setTextColor:[UIColor darkGrayColor]];
    [textContainer addSubview:title];
    
    
    UITextView *description = [[UITextView alloc]initWithFrame:CGRectMake(15, title.frame.size.height+10, frame.size.width-35, textContainer.frame.size.height-title.frame.size.height-65)];
    [description setText:@"Inicia sesión para crear tu perfíl y facilitar la busqueda, envio de mensajes y notificaciones en la aplicación."];
    [description setTextAlignment:NSTextAlignmentCenter];
    [description setTextColor:[UIColor lighterGrayColor]];
    [description setFont:[UIFont systemFontOfSize:14]];
    [textContainer addSubview:description];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, textContainer.frame.size.height-50, frame.size.width-40, 35)];
    [button setBackgroundColor:[UIColor primaryColor]];
    [button setTitle:@"Registrate" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTintColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:2.0];
    [button.layer setMasksToBounds:YES];
    [button addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    [textContainer addSubview:button];
    
    [view addSubview:textContainer];
    [self.tableView addSubview:view];
}

- (void)showLoginView:(id)sender{
    LoginRegisterPagerViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginRegisterPager"];
    [self.navigationController presentViewController:loginView animated:YES completion:nil];
}

@end
