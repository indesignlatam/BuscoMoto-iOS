//
//  ProfileTableViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/15/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "EAIntroView.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Perfil de Usuario"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(saveProfile:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [_cellName.textLabel setText:@"Nombre"];
    [_cellName.detailTextLabel setText:@""];
    
    [_cellEmail.textLabel setText:@"Correo"];
    [_cellEmail.detailTextLabel setText:@""];
    
    [_cellPhone1.textLabel setText:@"Telefono"];
    [_cellPhone1.detailTextLabel setText:@""];
    
    [_cellPhone2.textLabel setText:@"Telefono 2"];
    [_cellPhone2.detailTextLabel setText:@""];
    
    [_cellAddress.textLabel setText:@"Dirección"];
    [_cellAddress.detailTextLabel setText:@""];
    
    [_descriptionTextView setPlaceholder:@"Descripción"];
    [_descriptionTextView setText:@""];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!_user){
        [self showIntro];
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
    [view setBackgroundColor:[UIColor successColor]];
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:view.frame];
    [bg setImage:[UIImage imageNamed:@"bg_image"]];
    [bg setContentMode:UIViewContentModeScaleAspectFill];
    [view addSubview:bg];
    
    
    frame.size.height = (frame.size.height/10)*3.5;
    frame.size.width = (frame.size.width/10)*8;
    frame.origin.y = self.tableView.frame.size.height-frame.size.height-30;
    frame.origin.x = (self.tableView.frame.size.width-frame.size.width)/2;
    UIView *textContainer = [[UIView alloc]initWithFrame:frame];
    [textContainer setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, frame.size.width-40, 30)];
    [title setText:@"Publica tu moto"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:20]];
    [title setTextColor:[UIColor darkGrayColor]];
    [textContainer addSubview:title];
    
    
    UITextView *description = [[UITextView alloc]initWithFrame:CGRectMake(15, title.frame.size.height+10, frame.size.width-35, textContainer.frame.size.height-title.frame.size.height-65)];
    [description setText:@"Miaw miaw miaw miaw miaw miaw miaw miaw miaw"];
    [description setTextAlignment:NSTextAlignmentCenter];
    [description setTextColor:[UIColor lighterGrayColor]];
    [textContainer addSubview:description];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, textContainer.frame.size.height-50, frame.size.width-40, 35)];
    [button setBackgroundColor:[UIColor primaryColor]];
    [button setTitle:@"Crea una cuenta" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTintColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:2.0];
    [button.layer setMasksToBounds:YES];
    [textContainer addSubview:button];
    
    
    [view addSubview:textContainer];
    [self.tableView addSubview:view];
}

@end
