//
//  ListingTableViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/13/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "AppDelegate.h"
#import "ListingsTableViewController.h"
#import "ListingViewController.h"
#import "ListingCell.h"

#import "Listing.h"

@implementation ListingsTableViewController

@synthesize listings;
@synthesize loading;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_horizontal_contrast"]];
    [iv setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationItem setTitleView:iv];
    [self.navigationItem setTitle:@"Listings"];
    
    _currentPage = [NSNumber numberWithInt:0];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                  target:self
                                                                                  action:@selector(showSearch)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;
    
    //Pulldown to refresh table view data
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor primaryColor]];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    //Activity View
    self.loadMoreActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.loadMoreActivityView setColor:[UIColor blackColor]];
    [self.view addSubview:self.loadMoreActivityView];
    
    [self loadData:false];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height){
        NSLog(@"No more listings to load: %@ - %@", _lastPage, _currentPage);
        if(_lastPage && _lastPage > _currentPage){
            [self loadData:true];
        }
    }
}

- (void)refresh:(id)sender{
    if(!loading){
        [self loadData:false];
    }else{
        [self.refreshControl endRefreshing];
    }
}

- (void)loadData:(BOOL)loadMore{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    // If loading is true dont load again
    if(!loading){
        // Set the loading bool to true
        loading = true;
        NSNumber *page = [NSNumber numberWithInt:1];
        if(loadMore){
            page = [NSNumber numberWithInt:self.currentPage.intValue+1];
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"page" : page,
                                                                                      @"take" : [NSNumber numberWithInt:5],
                                                                                      }];
        // Clean params
        [params addEntriesFromDictionary:_params];
        [params removeObjectForKey:@"selectedManufacturersRows"];
        [params removeObjectForKey:@"selectedModelsRows"];
        
        NSLog(@"PARAMS: %@", params);
        [[BMCONoAUTHAPIManager sharedInstance] GETListingsWithParams:params onCompletion:^(NSArray *data, NSDictionary *paginator, NSError *error) {
            if (!error){
                if(loadMore){
                    [self.listings addObjectsFromArray:data.mutableCopy];
                }else{
                    self.listings = [data mutableCopy];
                }
                //NSLog(@"PAGINATOR: %@", paginator);
                _currentPage    = [paginator objectForKey:@"current_page"];
                _lastPage       = [paginator objectForKey:@"last_page"];
                loading = false;
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }else{
                NSLog(@"ERROR: %@", error);
            }
            [[appDelegate splashView] startAnimation];
        }];
    }
}


#pragma TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return 42.0f;
    }
    return 220.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1){
        if(self.listings.count > 0){
            return 1;
        }
        return 0;
    }
    return self.listings.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"listings_cell";
    
    if(indexPath.section == 0){
        ListingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ListingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        // Configure the cell.
        Listing *listing = [self.listings objectAtIndex:indexPath.row];
        cell.listing = listing;

        UIImage *placeholder = [UIImage imageNamed:@"listing_image"];
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:listing.imageURL] placeholderImage:placeholder];    

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];

        [cell.cellTitle setText:listing.title];
        [cell.cellSubTitle setText:[NSString stringWithFormat:@"$%@ | %@ kms", [numberFormatter stringFromNumber:listing.price], [numberFormatter stringFromNumber:listing.odometer]]];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"load_more_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.accessoryView = activityIndicator;
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        NSString *text = @"Cargando más publicaciones";
        if(_lastPage <= _currentPage){
            text = @"No encontramos más publicaciones";
        }
        cell.detailTextLabel.text = text;
        
        
        if(_lastPage > _currentPage){
            // get the tapped cell's accessory view and cast it as the activity indicator view
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)cell.accessoryView;
            
            // tell it to start animating
            [activityIndicator startAnimating];
        }else{
            // get the tapped cell's accessory view and cast it as the activity indicator view
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)cell.accessoryView;
            
            // tell it to start animating
            [activityIndicator stopAnimating];
        }
        
        
        return cell;
    }
}

- (void)showSearch{
    UIStoryboard *storyboard = self.storyboard;
    SearchViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"searchView"];
    [view setDelegate:self];
    [view setParams:_params];
    [self.navigationController presentViewController:view animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showListingDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListingViewController *destViewController = segue.destinationViewController;
        destViewController.listing = [listings objectAtIndex:indexPath.row];
    }
}

#pragma SearchViewController Delegate
- (void)searchViewController:(SearchViewController *)viewController didFinish:(NSDictionary *)params{
    _params = [params mutableCopy];
    [self loadData:NO];
}

@end
