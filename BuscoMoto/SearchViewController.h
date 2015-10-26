//
//  SearchViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/24/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZPicker.h"
#import "BMARangeSlider.h"
#import "BMASlider.h"
#import "PKYStepper.h"

@protocol SearchViewControllerDelegate;

@interface SearchViewController : UIViewController <CZPickerViewDataSource, CZPickerViewDelegate>

@property (nonatomic, weak) id<SearchViewControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, retain) NSArray *models;
@property (nonatomic, retain) NSArray *manufacturers;
@property (nonatomic, retain) NSArray *cities;

@property (nonatomic, retain) NSMutableArray *selectedTypes;
@property (nonatomic, retain) NSArray *selectedManufacturers;
@property (nonatomic, retain) NSArray *selectedManufacturersRows;
@property (nonatomic, retain) NSArray *selectedModels;
@property (nonatomic, retain) NSArray *selectedModelsRows;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *viewTitle;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutlet UILabel *searchListingType;
@property (strong, nonatomic) IBOutlet UIScrollView *searchListingTypeScroll;


@property (strong, nonatomic) IBOutlet UILabel *searchManufacturerTitle;
@property (strong, nonatomic) IBOutlet UIButton *searchManufacturerButton;

@property (strong, nonatomic) IBOutlet UILabel *searchReferenceTitle;
@property (strong, nonatomic) IBOutlet UIButton *searchReferenceButton;

@property (strong, nonatomic) IBOutlet UILabel *searchModelTitle;
@property (strong, nonatomic) IBOutlet BMARangeSlider *searchModelSlider;

@property (strong, nonatomic) IBOutlet UILabel *searchPriceTitle;
@property (strong, nonatomic) IBOutlet PKYStepper *searchPriceStepper;

@property (strong, nonatomic) IBOutlet UILabel *searchOdomoterTitle;
@property (strong, nonatomic) IBOutlet PKYStepper *searchOdometerStepper;


- (IBAction)selectManufacturer:(id)sender;
- (IBAction)selectReference:(id)sender;


- (IBAction)closeView:(id)sender;
- (IBAction)search:(id)sender;

@end


@protocol SearchViewControllerDelegate <NSObject>

- (void)searchViewController:(SearchViewController*)viewController didFinish:(NSDictionary*)params;

@end
