//
//  MyListingsTableViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/30/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "MyListingsTableViewController.h"
#import "AppDelegate.h"
#import "LoginRegisterPagerViewController.h"

#import "Listing.h"
#import "MyListingCell.h"

@interface MyListingsTableViewController ()

@end


@implementation MyListingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newListing:)];
    [self.navigationItem setRightBarButtonItem:button animated:YES];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    
    if(_listings.count == 0 && [[IDCAuthManager sharedInstance] isAuthorized]){
        [self refresh:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Connection
- (void)refresh:(id)sender{
    if(!_loading){
        [self loadData:false];
    }else{
        [self.refreshControl endRefreshing];
    }
}

- (void)loadData:(BOOL)loadMore{    
    // If loading is true dont load again
    if(!_loading){
        // Set the loading bool to true
        _loading = true;

        [[BMCOAPIManager sharedInstance] GETListings:^(NSArray *data, NSError *error) {
            if (!error){
                _listings = [data mutableCopy];
                _loading = false;
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }else{
                NSLog(@"ERROR: %@", error);
            }
        }];
    }
}


- (void)newListing:(id)sender{
    NSLog(@"CREATE NEW LISTING");
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    MyListingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyListingsCell"];
    if (cell == nil) {
        cell = [[MyListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyListingsCell"];
    }
    
    Listing *listing = [_listings objectAtIndex:indexPath.row];
    cell.listing = listing;
    
    UIImage *placeholder = [UIImage imageNamed:@"listing_image"];
    [cell.listingImage sd_setImageWithURL:[NSURL URLWithString:listing.imageURL] placeholderImage:placeholder];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    [cell.listingTitle setText:listing.title];
    [cell.listingsViews setText:[NSString stringWithFormat:@"%@ visitas", [numberFormatter stringFromNumber:listing.views]]];
    
    
    return cell;
}

#pragma mark DNZ Delegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        NSLog(@"Not authorized");
        return YES;
    }else if(_listings.count == 0){
        return YES;
    }
    
    return NO;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        return [UIImage imageNamed:@"icon_turism"];
    }else if(_listings.count == 0){
        return [UIImage imageNamed:@"icon_turism"];
    }
    return [UIImage imageNamed:@"icon_turism"];
}

- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView{
    return YES;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"Debes estar registrado";
    
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        text = @"Debes estar registrado";
    }else if(_listings.count == 0){
        text = @"No tienes ";
    }
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"Para publicar tu moto o ver tus publicaciones.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    
    return [[NSAttributedString alloc] initWithString:@"Inicia sesión o crea una cuenta" attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    // Do something
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginRegisterPagerViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginRegisterPager"];
    [self.navigationController presentViewController:loginView animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
