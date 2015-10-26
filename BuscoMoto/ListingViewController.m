//
//  ListingViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/13/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+BuscoMoto.h"

#import "ListingViewController.h"
#import "ContactVendorTableViewController.h"
#import "LoginRegisterPagerViewController.h"

#import "IDCPhoto.h"
#import "Feature.h"
#import "Image.h"

@implementation ListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return self.tableView.frame.size.width/1.777777777;
    }else if(indexPath.row == 1){
        CGFloat width = self.tableView.frame.size.width - 20;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, width, 70)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setText:self.listing.title];
        [title setNumberOfLines:0];
        [title setFont:[UIFont systemFontOfSize:28]];
        [title sizeToFit];
        
        return title.frame.size.height + 20 + 25 + 40;
    }else if(indexPath.row == 2){
        return 140;
    }else if(indexPath.row == 3){
        CGFloat width = self.tableView.frame.size.width - 20;
        UITextView *title = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, width, 500)];
        [title setText:self.listing.descriptionText];
        [title setFont:[UIFont systemFontOfSize:15]];
        [title sizeToFit];
        
        return title.frame.size.height;
    }else if(indexPath.row == 4){
        CGFloat height = (_listing.features.count/2)*22+40;
        if(height < 100){
            return 100;
        }
        return height;
    }
    
    return 100;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"listing_cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (true) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];

        if(indexPath.row == 0){
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ordering" ascending:YES];
            NSArray *images = [self.listing.images sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            
            CGFloat width   = self.tableView.frame.size.width;
            CGFloat height  = self.tableView.frame.size.width/1.777777777;
            
            UIScrollView *slideShow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
            [slideShow setDelegate:self];
            [slideShow setPagingEnabled: YES];
            [slideShow setShowsHorizontalScrollIndicator:NO];
            [slideShow setTag:999];
            
            CGFloat xP = (width/2) - ((width/2)/2) - ((width/2)/2)/4;//??? But it works
            _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(xP, height-30, width/2, 15)];
            [_pageControl setNumberOfPages:images.count];
            [_pageControl setCurrentPage:0];
            
            int x = 0;
            
            if(images.count > 0){
                for (int i = 0; i < images.count; i++) {
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, slideShow.frame.size.height)];
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    [img sd_setImageWithURL:[[images objectAtIndex:i] imageURL] placeholderImage:[UIImage imageNamed:@"listing_image"]];
                    [img setUserInteractionEnabled:YES];
                    //The setup code (in viewDidLoad in your view controller)
                    UITapGestureRecognizer *singleFingerTap =
                    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoViewer:)];
                    [img addGestureRecognizer:singleFingerTap];
                    
                    x = x + width;
                    [slideShow addSubview:img];
                }
            }else{
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, slideShow.frame.size.height)];
                [img setContentMode:UIViewContentModeScaleAspectFit];
                [img setImage:[UIImage imageNamed:@"listing_image"]];
                [img setUserInteractionEnabled:YES];
                
                x = x + width;
                [slideShow addSubview:img];
            }
            
            [slideShow setContentSize:CGSizeMake(x, slideShow.frame.size.height)];
            [slideShow setContentOffset:CGPointMake(0, 0)];
            
            [cell sizeToFit];
            [cell.contentView addSubview:slideShow];
            [cell.contentView addSubview:_pageControl];
            
            UIButton *likeButton = [[UIButton alloc]initWithFrame:CGRectMake(width-50, 10, 30, 30)];
            UIImage *image = [UIImage imageNamed:@"like"];
            [likeButton setImage:image forState:UIControlStateNormal];
            [likeButton.imageView setTintColor:[UIColor whiteColor]];
            [likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:likeButton];
            
        }else if(indexPath.row == 1){
            CGFloat width = self.tableView.frame.size.width - 20;
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, width, 70)];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setContentScaleFactor:0.7];
            [title setText:self.listing.title];
            [title setNumberOfLines:0];
            [title setFont:[UIFont systemFontOfSize:28]];
            [title sizeToFit];
            [title setFrame:CGRectMake(10, 5, width, title.frame.size.height)];
            [cell.contentView addSubview:title];
            
            UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(10, title.frame.size.height+15, width, 30)];
            [price setTextAlignment:NSTextAlignmentCenter];
            [price setFont:[UIFont systemFontOfSize:20]];
            [price setTextColor:[UIColor colorWithRed:0.2 green:0.3 blue:0.8 alpha:1.0]];
            [price setText:[NSString stringWithFormat:@"$%@", [numberFormatter stringFromNumber:self.listing.price]]];
            [cell.contentView addSubview:price];
            
            UIButton *contactButton = [[UIButton alloc]initWithFrame:CGRectMake(((width/3)/2) + 10, title.frame.size.height+50, (width/3)*2, 30)];
            [contactButton setTitle:@"Contacta al Vendedor" forState:UIControlStateNormal];
            [contactButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [contactButton setBackgroundColor:[UIColor primaryColor]];
            [contactButton addTarget:self action:@selector(goToContactView:) forControlEvents:UIControlEventTouchUpInside];
            contactButton.layer.cornerRadius = 2;
            [cell.contentView addSubview:contactButton];
        }else if(indexPath.row == 2){
            // Labels
            CGFloat width = (self.tableView.frame.size.width-50)/3;
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, width, 15)];
            [title setFont:[UIFont systemFontOfSize:13]];
            [title setTextColor:[UIColor lightGrayColor]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:@"Cilindraje"];
            [title setTag:6];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(25+width, 10, width, 15)];
            [title setFont:[UIFont systemFontOfSize:13]];
            [title setTextColor:[UIColor lightGrayColor]];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setContentScaleFactor:0.7];
            [title setText:@"Kilometraje"];
            [title setTag:7];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(35+(width*2), 10, width, 15)];
            [title setFont:[UIFont systemFontOfSize:13]];
            [title setTextColor:[UIColor lightGrayColor]];
            [title setTextAlignment:NSTextAlignmentRight];
            [title setContentScaleFactor:0.7];
            [title setText:@"Modelo"];
            [title setTag:8];
            [cell.contentView addSubview:title];
            
            // Values
            title = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, width, 15)];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:[NSString stringWithFormat:@"%@cc", [numberFormatter stringFromNumber:self.listing.engineSize]]];
            [title setTag:7];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(25+width, 30, width, 15)];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setContentScaleFactor:0.7];
            // Format number
            [title setText:[NSString stringWithFormat:@"%@ kms", [numberFormatter stringFromNumber:self.listing.odometer]]];
            [title setTag:7];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(35+(width*2), 30, width, 15)];
            [title setTextAlignment:NSTextAlignmentRight];
            [title setContentScaleFactor:0.7];
            [title setText:self.listing.year.stringValue];
            [title setTag:7];
            [cell.contentView addSubview:title];
            
            
            // Labels
            width = (self.tableView.frame.size.width-40);
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, (width/5)*1, 20)];
            [title setFont:[UIFont systemFontOfSize:13]];
            [title setTextColor:[UIColor lightGrayColor]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:@"Color"];
            [title setTag:8];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(15, 85, (width/5)*1, 20)];
            [title setFont:[UIFont systemFontOfSize:13]];
            [title setTextColor:[UIColor lightGrayColor]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:@"Tipo"];
            [title setTag:8];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(15, 110, (width/5)*1, 20)];
            [title setFont:[UIFont systemFontOfSize:13]];
            [title setTextColor:[UIColor lightGrayColor]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:@"Ciudad"];
            [title setTag:8];
            [cell.contentView addSubview:title];
            
            
            // Values
            title = [[UILabel alloc]initWithFrame:CGRectMake(25+(width/5)*1, 60, (width/5)*4, 20)];
            [title setFont:[UIFont systemFontOfSize:15]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:_listing.color];
            [title setTag:7];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(25+(width/5)*1, 85, (width/5)*4, 20)];
            [title setFont:[UIFont systemFontOfSize:15]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:_listing.type.name];
            [title setTag:7];
            [cell.contentView addSubview:title];
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(25+(width/5)*1, 110, (width/5)*4, 20)];
            [title setFont:[UIFont systemFontOfSize:15]];
            [title setTextAlignment:NSTextAlignmentLeft];
            [title setContentScaleFactor:0.7];
            [title setText:_listing.city.name];
            [title setTag:7];
            [cell.contentView addSubview:title];
        }else if(indexPath.row == 3){
            CGFloat width = self.tableView.frame.size.width - 20;
            UITextView *description = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, width, 500)];
            [description setText:self.listing.descriptionText];
            [description setTextColor:[UIColor grayColor]];
            [description setFont:[UIFont systemFontOfSize:15]];
            [description setEditable:NO];
            [description setScrollEnabled:NO];
            [description sizeToFit];
            [description setFrame:CGRectMake(10, 0, width, description.frame.size.height)];
            [cell.contentView addSubview:description];
        }else if(indexPath.row == 4){
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID"
                                                                           ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *features = [_listing.features sortedArrayUsingDescriptors:sortDescriptors];
            
            int y = 10;
            int x = 15;
            
            
            // All
            for (int i = 0; i < features.count; i++) {
                Feature *feature = [features objectAtIndex:i];

                // Labels
                CGFloat width = (self.tableView.frame.size.width-50)/2;
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, 17)];
                [title setFont:[UIFont systemFontOfSize:15]];
                [title setTextColor:[UIColor lightGrayColor]];
                [title setTextAlignment:NSTextAlignmentLeft];
                [title setAdjustsFontSizeToFitWidth:YES];
                [title setText:feature.name];
                [cell.contentView addSubview:title];
                
                if(i % 2){
                    y += 22;
                    x = 15;
                }else{
                    x += 20+width;
                }
                    
            }
            
        }
    }
    
    return cell;
}

- (void)showPhotoViewer:(UITapGestureRecognizer *)recognizer{
    // Set up images
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ordering" ascending:YES];
    NSArray *images = [self.listing.images sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    if(images.count > 0){
        NSArray *photos = [[NSArray alloc]init];
        
        for (int i = 0; i < images.count; i++) {
            UIImageView *img = [[UIImageView alloc]init];
            [img sd_setImageWithURL:[[images objectAtIndex:i] imageURL] placeholderImage:[UIImage imageNamed:@"listing_image"]];
            IDCPhoto *photo = [[IDCPhoto alloc]init];
            [photo setImage:img.image];
            [photo setPlaceholderImage:[UIImage imageNamed:@"listing_image"]];
            
            photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:_listing.title attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
            photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:_listing.user.name attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
            
            NSString *phones = @"";
            if(_listing.user.phone1 && _listing.user.phone2){
                phones = [NSString stringWithFormat:@"%@ - %@", _listing.user.phone1, _listing.user.phone2];
            }else if(_listing.user.phone1){
                phones = [NSString stringWithFormat:@"%@", _listing.user.phone1];
            }else{
                phones = @"User has no registered phone numbers";
            }
            
            photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:phones attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
            
            photos = [photos arrayByAddingObject:photo];
        }
        
        NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
        [self presentViewController:photosViewController animated:YES completion:nil];
    }
}

- (void)goToContactView:(id)sender{
    [(XLPagerTabStripViewController *)self.parentViewController moveToViewControllerAtIndex:1 animated:YES];
}

- (void)likeButtonPressed:(UIButton *)sender{
    NSLog(@"Like button pressed");
    
    if(![[IDCAuthManager sharedInstance] isAuthorized]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginRegisterPagerViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginRegisterPager"];
        [self.navigationController presentViewController:loginView animated:YES completion:nil];
        
        return;
    }
    
//    if(_listing.isLiked){
//        [sender.imageView setTintColor:[UIColor whiteColor]];
//    }else{
//        [sender.imageView setTintColor:[UIColor redColor]];
//    }
    
    [[BMCOAPIManager sharedInstance] POSTLikeWithParams:_listing.listingID onCompletion:^(BOOL liked, NSError *error){
        if(!error){
            if(liked){
                [sender.imageView setTintColor:[UIColor redColor]];
                NSLog(@"Listing liked");
            }else{
                [sender.imageView setTintColor:[UIColor whiteColor]];
                NSLog(@"Listing unliked");
            }
        }else{
            NSLog(@"Error");
        }
    }];
}

#pragma mark Slideshow delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.tag == 999){
        CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    }
}

#pragma mark - XLPagerTabStripViewControllerDelegate
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return @"Información";
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    return [UIColor whiteColor];
}


@end
