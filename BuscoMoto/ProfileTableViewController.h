//
//  ProfileTableViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/15/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIPlaceHolderTextView.h"
#import "TOCropViewController.h"

#import "User.h"

@interface ProfileTableViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPhone1;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPhone2;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellAddress;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *descriptionTextView;
@end
