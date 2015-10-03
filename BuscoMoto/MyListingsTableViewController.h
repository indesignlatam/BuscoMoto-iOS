//
//  MyListingsTableViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/30/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface MyListingsTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, retain) NSMutableArray *listings;
@property BOOL loading;
@property (nonatomic, retain) NSNumber *currentPage;
@property (nonatomic, retain) NSNumber *lastPage;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;

@end
