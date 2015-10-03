//
//  ListingCell.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/13/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Listing.h"

@interface ListingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UILabel *cellSubTitle;
@property (strong, nonatomic) IBOutlet UIImageView *cellUserImage;
@property (strong, nonatomic) IBOutlet UIButton *cellLikeButton;

@property (nonatomic, retain) Listing *listing;

- (IBAction)likeListing:(id)sender;
@end
