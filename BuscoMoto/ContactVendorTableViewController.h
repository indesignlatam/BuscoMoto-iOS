//
//  ContactVendorTableViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"

#import "Listing.h"

@interface ContactVendorTableViewController : UITableViewController <XLPagerTabStripChildItem, UITextFieldDelegate>

@property (nonatomic, retain) Listing *listing;

@property (strong, nonatomic) IBOutlet UILabel *vendorName;
@property (strong, nonatomic) IBOutlet UILabel *vendorPhones;
@property (strong, nonatomic) IBOutlet UILabel *vendorEmail;


@property (strong, nonatomic) IBOutlet UITextField *messageName;
@property (strong, nonatomic) IBOutlet UITextField *messageEmail;
@property (strong, nonatomic) IBOutlet UITextField *messagePhone;
@property (strong, nonatomic) IBOutlet UITextView *messageText;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendMessage:(id)sender;

@end
