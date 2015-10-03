//
//  ListingPagerViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "ListingPagerViewController.h"
#import "ListingViewController.h"
#import "ContactVendorTableViewController.h"
#import "LoginViewController.h"

#import "IDCPhoto.h"

@implementation ListingPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = YES;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

#pragma mark - XLPagerTabStripViewControllerDataSource
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    ListingViewController *listingView = [[ListingViewController alloc] init];
    [listingView setListing:_listing];
    
    UIStoryboard *storyboard = self.storyboard;
    ContactVendorTableViewController *contactView = [storyboard instantiateViewControllerWithIdentifier:@"contactVendor"];
    [contactView setListing:_listing];
    
    return @[listingView, contactView];
}

@end
