//
//  LoginViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/23/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, XLPagerTabStripChildItem>

@property (strong, nonatomic) IBOutlet UITextField *loginUsername;
@property (strong, nonatomic) IBOutlet UITextField *loginPassword;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)login:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)createAccount:(id)sender;

@end