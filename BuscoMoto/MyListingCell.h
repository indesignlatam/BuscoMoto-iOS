//
//  MyListingCell.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/2/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface MyListingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *listingImage;
@property (strong, nonatomic) IBOutlet UILabel *listingTitle;
@property (strong, nonatomic) IBOutlet UILabel *listingsViews;
@property (strong, nonatomic) IBOutlet UILabel *listingExpiresAt;

@property (nonatomic, retain) Listing *listing;


@end
