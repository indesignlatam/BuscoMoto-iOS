//
//  MyListingsTableViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/30/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "MyListingCell.h"

@interface MyListingsTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MCSwipeTableViewCellDelegate>

@property (nonatomic, retain) NSMutableArray *listings;
@property BOOL loading;
@property (nonatomic, retain) NSNumber *currentPage;
@property (nonatomic, retain) NSNumber *lastPage;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, strong) MyListingCell *selectedCell;
@end
