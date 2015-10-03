//
//  ListingViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/13/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"

#import "NYTPhotosViewController.h"
#import "Listing.h"

@interface ListingViewController : UITableViewController <XLPagerTabStripChildItem>

@property (nonatomic, retain) Listing *listing;

@end
