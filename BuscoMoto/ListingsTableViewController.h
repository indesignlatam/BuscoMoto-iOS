//
//  ListingTableViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/13/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

#import "SearchViewController.h"

@interface ListingsTableViewController : UITableViewController <UITableViewDelegate, SearchViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, retain) NSMutableArray *listings;
@property BOOL loading;
@property (nonatomic, retain) NSNumber *currentPage;
@property (nonatomic, retain) NSNumber *lastPage;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, retain) NSMutableDictionary *params;

@end
