//
//  CreaListingPagerContainerViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/4/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "XLButtonBarPagerTabStripViewController.h"

#import "Listing.h"

@interface CreaListingPagerContainerViewController : XLButtonBarPagerTabStripViewController

@property (nonatomic, retain) Listing *listing;

- (IBAction)close:(id)sender;
@end
