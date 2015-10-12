//
//  CreaListingPagerContainerViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/4/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "CreaListingPagerContainerViewController.h"
#import "DKImageBrowser.h"
#import "ListingInformationTableViewController.h"

@interface CreaListingPagerContainerViewController ()

@end

@implementation CreaListingPagerContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isProgressiveIndicator = NO;
    self.buttonBarView.selectedBarHeight = 3;
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor orangeColor]];
    
    self.listing = [[Listing alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    UIStoryboard *storyboard = self.storyboard;
    //InformationViewController *infoView = [storyboard instantiateViewControllerWithIdentifier:@"informationView"];
    ListingInformationTableViewController *infoView = [storyboard instantiateViewControllerWithIdentifier:@"listingInfoView"];

    return @[infoView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)close:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
