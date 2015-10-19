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
#import "ListingInformationTableViewController.h"
#import "EditListingTableViewController.h"

#import "Listing.h"


@interface MyListingsTableViewController ()

@end


@implementation MyListingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
    //Pulldown to refresh table view data
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor primaryColor]];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [self refresh:nil];
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
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt" ascending:NO];
                data = [data sortedArrayUsingDescriptors:@[sortDescriptor]];
                
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
    [cell.listingExpiresAt setText:[IDCDate getExpiresIn:listing.expiresAt]];
    
    // Set swipe actions
    UIImageView *checkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark"]];
    UIImageView *crossView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cross"]];
    
    [cell setDelegate:self];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:[UIColor lightGrayColor]];
    
    // Icon should move with swipe ?
    cell.shouldAnimateIcons = YES;
    
    __weak MyListingsTableViewController *weakSelf = self;
    MCSwipeTableViewCellState state = MCSwipeTableViewCellState1;
    
    if([listing.expiresAt timeIntervalSinceNow] < (86400*5)){
        [cell.listingExpiresAt setTextColor:[UIColor redColor]];
        
        state = MCSwipeTableViewCellState2;
        [cell setSwipeGestureWithView:checkView color:[UIColor primaryColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            __strong MyListingsTableViewController *strongSelf = weakSelf;
            [strongSelf setSelectedCell:(MyListingCell*)cell];
            
            // RENOVATE LISTING
            [[BMCOAPIManager sharedInstance]POSTRenovateListingWithID:_selectedCell.listing.listingID onCompletion:^(Listing *listing, NSError *error){
                if(!error){
                    [_listings setObject:listing atIndexedSubscript:[strongSelf.tableView indexPathForCell:_selectedCell].row];
                    [self.tableView reloadRowsAtIndexPaths:@[[strongSelf.tableView indexPathForCell:_selectedCell]] withRowAnimation:UITableViewRowAnimationFade];
                    [JDStatusBarNotification showWithStatus:@"Publicación renovada por 30 días más" styleName:JDStatusBarStyleDefault];
                    [JDStatusBarNotification dismissAfter:4];
                }else{
                    [JDStatusBarNotification showWithStatus:@"Error al renovar la publicación" styleName:JDStatusBarStyleError];
                    [JDStatusBarNotification dismissAfter:3];
                }
            }];
        }];
    }else{
        [cell.listingExpiresAt setTextColor:[UIColor blackColor]];
    }
    
    [cell setSwipeGestureWithView:crossView color:[UIColor yellowColor] mode:MCSwipeTableViewCellModeExit state:state completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        __strong MyListingsTableViewController *strongSelf = weakSelf;
        [strongSelf setSelectedCell:(MyListingCell*)cell];
        // DO ACTION
        NSLog(@"SWIPE SOLD");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"¿Ya vendiste esta moto?"
                                                            message:@"Si confirmas esta acción, la publicación sera marcada como vendida y no se mostrara más al publico."
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Si", nil];
        [alertView setTag:2];
        [alertView show];
    }];
    
    [cell setSwipeGestureWithView:crossView color:[UIColor redColor] mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        __strong MyListingsTableViewController *strongSelf = weakSelf;
        [strongSelf setSelectedCell:(MyListingCell*)cell];
        // DO ACTION
        NSLog(@"SWIPE DELETE");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"¿Deseas eliminar esta publicación?"
                                                            message:@"Esta acción sera permanente y no podras recuperar la publicación."
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Si", nil];
        [alertView setTag:1];
        [alertView show];
    }];
    
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
    NSString *text = @"";
    
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        text = @"Debes estar registrado";
    }else if(_listings.count == 0){
        text = @"¿Estas vendiendo tu moto?";
    }
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        text = @"Para publicar tu moto o ver tus publicaciones.";
    }else if(_listings.count == 0){
        text = @"Puedes publicarla totalmente gratis";
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *text = @"";
    
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        text = @"Inicia sesión o crea una cuenta";
    }else if(_listings.count == 0){
        text = @"¡Publica tu moto!";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    // Do something
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginRegisterPagerViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginRegisterPager"];
        [self.navigationController presentViewController:loginView animated:YES completion:nil];
    }else if(_listings.count == 0){
        ListingInformationTableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"listingInfoView"];
        [self.navigationController presentViewController:view animated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_selectedCell swipeToOriginWithCompletion:^{
            NSLog(@"Swiped back");
        }];
        _selectedCell = nil;
    }else{
        if(alertView.tag == 1){
            // RENOVATE LISTING
            [[BMCOAPIManager sharedInstance]DELETEListingWithID:_selectedCell.listing.listingID onCompletion:^(BOOL success, NSError *error){
                if(!error && success){
                    [_listings removeObjectAtIndex:[self.tableView indexPathForCell:_selectedCell].row];
                    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:_selectedCell]] withRowAnimation:UITableViewRowAnimationTop];
                    [JDStatusBarNotification showWithStatus:@"Publicación eliminada" styleName:JDStatusBarStyleDefault];
                    [JDStatusBarNotification dismissAfter:4];
                    
                    _selectedCell = nil;
                }else{
                    [_selectedCell swipeToOriginWithCompletion:^{
                        NSLog(@"Swiped back");
                    }];
                    _selectedCell = nil;
                    
                    [JDStatusBarNotification showWithStatus:@"Error al eliminar la publicación" styleName:JDStatusBarStyleError];
                    [JDStatusBarNotification dismissAfter:3];
                }
            }];
        }else if(alertView.tag == 2){
            // Code to renew listing on cell
            NSLog(@"RENEW LISTING: %@", _selectedCell.listing.title);
            
            _selectedCell = nil;
        }
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editViewSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EditListingTableViewController *destViewController = segue.destinationViewController;
        destViewController.listing = [_listings objectAtIndex:indexPath.row];
    }
}


@end
