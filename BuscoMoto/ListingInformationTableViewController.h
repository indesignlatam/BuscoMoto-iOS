//
//  ListingInformationTableViewController.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/6/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOCropViewController.h"
#import "CZPicker.h"
#import "Manufacturer.h"
#import "Reference.h"
#import "City.h"
#import "Feature.h"

@interface ListingInformationTableViewController : UITableViewController <CZPickerViewDataSource, CZPickerViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) UIScrollView *slideShow;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) NSArray *models;
@property (nonatomic, retain) NSArray *manufacturers;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, retain) NSArray *features;

@property (nonatomic, retain) NSArray *selectedManufacturers;
@property (nonatomic, retain) NSArray *selectedManufacturersRows;
@property (nonatomic, retain) NSArray *selectedModels;
@property (nonatomic, retain) NSArray *selectedModelsRows;
@property (nonatomic, retain) City *selectedCity;
@property (nonatomic, retain) NSArray *selectedCityRows;
@property (nonatomic, retain) NSArray *selectedFeatures;
@property (nonatomic, retain) NSArray *selectedFeaturesRows;


@property (strong, nonatomic) IBOutlet UITableViewCell *cellManufacturer;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellModel;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellCity;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPrice;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellOdometer;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellLicense;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellColor;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellDescription;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellAditionals;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellYear;
@property (strong, nonatomic) IBOutlet UITextView *textAreaDescription;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellNext;
@end
