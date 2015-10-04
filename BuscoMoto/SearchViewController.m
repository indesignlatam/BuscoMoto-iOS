//
//  SearchViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/24/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "SearchViewController.h"

#import "Manufacturer.h"
#import "Reference.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_searchModelSlider addTarget:self action:@selector(modelChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Price stepper setup
    _searchPriceStepper.value = 0.0f;
    _searchPriceStepper.stepInterval = 1000000.0f;
    _searchPriceStepper.maximum = 30000000.0f;
    _searchPriceStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        
        if(count > 0 && count < 30000000){
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:count]]];
        }else if(count >= 3000000){
            stepper.countLabel.text = [NSString stringWithFormat:@"%@ o más", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:count]]];
        }else{
            stepper.countLabel.text = [NSString stringWithFormat:@"Cualquiera"];
        }
    };
    [_searchPriceStepper setup];
    
    // Odometter stepper setup
    _searchOdometerStepper.value = 0.0f;
    _searchOdometerStepper.stepInterval = 2500.0f;
    _searchOdometerStepper.maximum = 50000.0f;
    _searchOdometerStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        
        if(count > 0 && count < 50000){
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:count]]];
        }else if(count >= 50000){
            stepper.countLabel.text = [NSString stringWithFormat:@"%@ o más", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:count]]];
        }else{
            stepper.countLabel.text = [NSString stringWithFormat:@"Cualquiera"];
        }
    };
    [_searchOdometerStepper setup];
    
    _selectedTypes = [[NSMutableArray alloc]init];
    
    
    if(_params){
        if([_params objectForKey:@"listing_types"]){
            _selectedTypes = [_params objectForKey:@"listing_types"];
        }
        
        if([_params objectForKey:@"manufacturers"]){
            _selectedManufacturersRows  = [_params objectForKey:@"selectedManufacturersRows"];
            
            NSPredicate *filter     = [NSPredicate predicateWithFormat:@"manufacturerID IN %@", [_params objectForKey:@"manufacturers"]];
            _selectedManufacturers  = [Manufacturer MR_findAllWithPredicate:filter];

            [self setPosibleModels:_selectedManufacturers];
        }
        
        if([_params objectForKey:@"models"]){
            _selectedModelsRows = [_params objectForKey:@"selectedModelsRows"];

            NSPredicate *filter = [NSPredicate predicateWithFormat:@"modelID IN %@", [_params objectForKey:@"models"]];
            _selectedModels     = [Reference MR_findAllWithPredicate:filter];
        }
        
        if([_params objectForKey:@"price_max"]){
            _searchPriceStepper.value = [(NSNumber*)[_params objectForKey:@"price_max"] floatValue];
        }
        
        if([_params objectForKey:@"odometer_max"]){
            _searchOdometerStepper.value = [(NSNumber*)[_params objectForKey:@"odometer_max"] floatValue];
        }
        
        if([_params objectForKey:@"year_max"] || [_params objectForKey:@"year_min"]){
            _searchModelSlider.currentUpperValue = [(NSNumber*)[_params objectForKey:@"year_max"] floatValue];
            _searchModelSlider.currentLowerValue = [(NSNumber*)[_params objectForKey:@"year_min"] floatValue];
        }
    }
    
    // Set listing types scrollbar
    NSArray *types = @[@"icon_street",
                       @"icon_sport",
                       @"icon_turism",
                       @"icon_motocross",
                       @"icon_atv",
                       @"icon_chopper",
                       @"icon_scooter"];
    NSArray *typesNames = @[@"Calle",
                            @"Deportiva",
                            @"Turismo",
                            @"Enduro/MX",
                            @"ATV",
                            @"Chopper",
                            @"Scooter"];
    NSArray *typesIDS = @[[NSNumber numberWithInt:1],
                          [NSNumber numberWithInt:3],
                          [NSNumber numberWithInt:2],
                          [NSNumber numberWithInt:5],
                          [NSNumber numberWithInt:7],
                          [NSNumber numberWithInt:6],
                          [NSNumber numberWithInt:4]];
    
    
    CGFloat x = 0;
    CGFloat width = 70;
    
    for (int i = 0; i < types.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, width, _searchListingTypeScroll.frame.size.height)];
        [button setImage:[UIImage imageNamed:[types objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitle:[typesNames objectAtIndex:i] forState:UIControlStateNormal];
        [button setTag:[[typesIDS objectAtIndex:i] integerValue]];
        [button setTintColor:[UIColor lighterGrayColor]];
        [button setTitleColor:[UIColor lighterGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor primaryColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button addTarget:self action:@selector(typeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        if([_selectedTypes containsObject:[NSNumber numberWithInteger:button.tag]]){
            [button setSelected:YES];
            [button setTintColor:[UIColor primaryColor]];
        }
        
        [button setContentEdgeInsets:UIEdgeInsetsMake(-12, 0, 12, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(70, -100, 0, 0)];
        
        x = x + width;
        [_searchListingTypeScroll addSubview:button];
    }
    
    [_searchListingTypeScroll setContentSize:CGSizeMake(x, _searchListingTypeScroll.frame.size.height)];
    [_searchListingTypeScroll setContentOffset:CGPointMake(0, 0)];
    [_searchListingTypeScroll setShowsHorizontalScrollIndicator:NO];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    [[BMCONoAUTHAPIManager sharedInstance] GETSearchData:^(id data, NSError *error) {
        if (!error){
            _manufacturers = [Manufacturer MR_findAllSortedBy:@"ordering,name" ascending:YES];
        }else{
            NSLog(@"ERROR: %@", error);
        }
    }];
}


- (IBAction)selectManufacturer:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Marcas"
                                                   cancelButtonTitle:@"Cancelar"
                                                  confirmButtonTitle:@"Seleccionar"];
    [picker setHeaderBackgroundColor:[UIColor primaryColor]];
    [picker setConfirmButtonBackgroundColor:[UIColor primaryColor]];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.allowMultipleSelection = YES;
    picker.tag = 1;
    [picker setSelectedRows:_selectedManufacturersRows];
    [picker show];
}

- (IBAction)selectReference:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Referencias (Modelos)"
                                                   cancelButtonTitle:@"Cancelar"
                                                  confirmButtonTitle:@"Seleccionar"];
    [picker setHeaderBackgroundColor:[UIColor primaryColor]];
    [picker setConfirmButtonBackgroundColor:[UIColor primaryColor]];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.allowMultipleSelection = YES;
    picker.tag = 2;
    [picker setSelectedRows:_selectedModelsRows];
    [picker show];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)search:(id)sender {
    id<SearchViewControllerDelegate> strongDelegate = self.delegate;
    
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(searchViewController:didFinish:)]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        // Set selected manufacturers
        if(_selectedTypes.count > 0){
            NSLog(@"TYPES: %@", _selectedTypes);
            [params setObject:_selectedTypes forKey:@"listing_types"];
        }
        
        // Set selected manufacturers
        if(_selectedManufacturers.count > 0){
            NSMutableArray *ids = [[NSMutableArray alloc]init];

            for (Manufacturer *man in _selectedManufacturers) {
                [ids addObject:man.manufacturerID];
            }
            
            [params setObject:ids forKey:@"manufacturers"];
            [params setObject:_selectedManufacturersRows forKey:@"selectedManufacturersRows"];
        }
        // Set selected models
        if(_selectedModels.count > 0){
            NSMutableArray *ids = [[NSMutableArray alloc]init];
            
            for (Reference *man in _selectedModels) {
                [ids addObject:man.modelID];
            }
            
            [params setObject:ids forKey:@"models"];
            [params setObject:_selectedModelsRows forKey:@"selectedModelsRows"];
        }
        // Set Year range
        if(_searchModelSlider.currentLowerValue != 1970 || _searchModelSlider.currentUpperValue != 2016){
            [params setObject:[NSNumber numberWithInt:(int)_searchModelSlider.currentLowerValue] forKey:@"year_min"];
            [params setObject:[NSNumber numberWithInt:(int)_searchModelSlider.currentUpperValue] forKey:@"year_max"];
        }
        // Set price range
        if(_searchPriceStepper.value > 0){
            [params setObject:[NSNumber numberWithInt:0] forKey:@"price_min"];
            [params setObject:[NSNumber numberWithInt:(int)_searchPriceStepper.value] forKey:@"price_max"];
        }
        // Set odometer range
        if(_searchOdometerStepper.value > 0){
            [params setObject:[NSNumber numberWithInt:0] forKey:@"odometer_min"];
            [params setObject:[NSNumber numberWithInt:(int)_searchOdometerStepper.value] forKey:@"odometer_max"];
        }

        
        [strongDelegate searchViewController:self didFinish:params];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma CZpicker delegate
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    if(pickerView.tag == 1){
        return _manufacturers.count;
    }else if(pickerView.tag == 2){
        return _models.count;
    }
    
    return _manufacturers.count;
}



/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    if(pickerView.tag == 1){
        return [[_manufacturers objectAtIndex:row] name];
    }else if(pickerView.tag == 2){
        return [NSString stringWithFormat:@"%@ (%@)", [[_models objectAtIndex:row] name], [[_models objectAtIndex:row] manufacturer].name];
    }
    
    return [[_manufacturers objectAtIndex:row] name];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows{
    if(pickerView.tag == 1){
        // Manufacturers
        _selectedManufacturersRows = rows;
        NSIndexSet *indexSet = [self indicesOfObjectsInArray:rows];
        _selectedManufacturers = [_manufacturers objectsAtIndexes:indexSet];
        [self setPosibleModels:_selectedManufacturers];
    }else if(pickerView.tag == 2){
        // Models
        _selectedModelsRows = rows;
        NSIndexSet *indexSet = [self indicesOfObjectsInArray:rows];
        _selectedModels = [_models objectsAtIndexes:indexSet];
    }
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    
}

- (void)setPosibleModels:(NSArray*)manufacturers{
    NSMutableArray *manIDS = [[NSMutableArray alloc]init];
    if([[manufacturers firstObject] isKindOfClass:NSManagedObject.class]){
        for (Manufacturer *man in manufacturers) {
            [manIDS addObject:man.manufacturerID];
        }
    }else{
        manIDS = manufacturers.mutableCopy;
    }
    
    // TODO: if no manufacturer selected delete all selected models
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"manufacturer.manufacturerID IN %@", manIDS];
    NSArray *array = [Reference MR_findAllWithPredicate:filter];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    _models = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (NSIndexSet *)indicesOfObjectsInArray:(NSArray *) array{
    if (array.count == 0){
        return ( [NSIndexSet indexSet] );
    }
    
    NSMutableIndexSet * indices = [NSMutableIndexSet indexSet];
    
    for (NSNumber *obj in array){
        [indices addIndex: obj.integerValue];
    }
    
    return [indices copy];
}

#pragma Types buttons event
- (void)typeButtonTouch:(UIButton*)button{
    if(!button.isSelected){
        [button setSelected:YES];
        [button setTintColor:[UIColor primaryColor]];
        [_selectedTypes addObject:[NSNumber numberWithLong:(long)button.tag]];
    }else{
        [button setSelected:NO];
        [button setTintColor:[UIColor lighterGrayColor]];
        
        [_selectedTypes removeObject:[NSNumber numberWithLong:(long)button.tag]];
    }
    
}

#pragma Model(Year) change event
- (void)modelChanged:(BMARangeSlider*)slider{
    _searchModelTitle.text = [NSString stringWithFormat:@"Modelo %d - %d", (int)slider.currentLowerValue, (int)slider.currentUpperValue];
}

@end
