//
//  EditListingTableViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/14/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "EditListingTableViewController.h"

@interface EditListingTableViewController ()

@end

@implementation EditListingTableViewController

@synthesize listing;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Editar Publicación"];
    
    if(!self.listing){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Guardar" style:UIBarButtonItemStylePlain target:self action:@selector(saveListing)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    [self loadData];
    
    if(listing.images.allObjects.count > 0){
        self.images = [listing.images.allObjects mutableCopy];
    }else{
        self.images = [[NSMutableArray alloc]init];
    }
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // INIT TABLE
    [_cellManufacturer.textLabel setText:@"Marca"];
    [_cellManufacturer.detailTextLabel setText:listing.manufacturer.name];
    _selectedManufacturers = @[listing.manufacturer];
    
    [_cellModel.textLabel setText:@"Referencia"];
    [_cellModel.detailTextLabel setText:listing.reference.name];
    _selectedModels = @[listing.reference];
    
    [_cellCity.textLabel setText:@"Ciudad"];
    [_cellCity.detailTextLabel setText:listing.city.name];
    _selectedCity = listing.city;

    
    [_cellDistrict.textLabel setText:@"Barrio"];
    [_cellDistrict.detailTextLabel setText:listing.district];
    
    [_cellPrice.textLabel setText:@"Precio"];
    [_cellPrice.detailTextLabel setText:[formatter stringFromNumber:listing.price]];
    
    [_cellOdometer.textLabel setText:@"Kilometraje"];
    [_cellOdometer.detailTextLabel setText:[formatter stringFromNumber:listing.odometer]];
    
    [_cellLicense.textLabel setText:@"Placa"];
    [_cellLicense.detailTextLabel setText:listing.licenseNumber];
    
    [_cellYear.textLabel setText:@"Modelo (Año)"];
    [_cellYear.detailTextLabel setText:[listing.year stringValue]];
    
    [_cellColor.textLabel setText:@"Color"];
    [_cellColor.detailTextLabel setText:listing.color];
    
    if(listing.descriptionText.length > 0){
        [_textAreaDescription setText:listing.descriptionText];
    }else{
        [_textAreaDescription setPlaceholder:@"Descripción"];
    }
    
    [_cellAditionals.textLabel setText:@"Caracteristicas"];
    
    if(listing.features.count > 0){
        _selectedFeatures = listing.features.allObjects;
        NSString *text = [NSString stringWithFormat:@"%@ +%lu", [[_selectedFeatures firstObject] name], (unsigned long)_selectedFeatures.count];
        [_cellAditionals.detailTextLabel setText:text];
    }else{
        [_cellAditionals.detailTextLabel setText:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    [[BMCONoAUTHAPIManager sharedInstance] GETSearchData:^(id data, NSError *error) {
        if (!error){
            _manufacturers = [Manufacturer MR_findAllSortedBy:@"ordering,name" ascending:YES];
            _cities = [City MR_findAllSortedBy:@"ordering,name" ascending:YES];
            _features = [Feature MR_findAllSortedBy:@"categoryID,name" ascending:YES];
            
            NSInteger anIndex = [_manufacturers indexOfObject:listing.manufacturer];
            if(NSNotFound != anIndex) {
                _selectedManufacturersRows = @[[NSNumber numberWithInteger:anIndex]];
                [self setPosibleModels:_selectedManufacturers];
            }
            
            anIndex = [_models indexOfObject:listing.reference];
            if(NSNotFound != anIndex) {
                _selectedModelsRows = @[[NSNumber numberWithInteger:anIndex]];
            }
            
            anIndex = [_cities indexOfObject:listing.city];
            if(NSNotFound != anIndex) {
                _selectedCityRows = @[[NSNumber numberWithInteger:anIndex]];
            }
            
            _selectedFeaturesRows = @[];
            for (Feature *feature in listing.features) {
                anIndex = [_features indexOfObject:feature];
                if(NSNotFound != anIndex) {
                    _selectedFeaturesRows = [_selectedFeaturesRows arrayByAddingObject:[NSNumber numberWithInteger:anIndex]];
                }
            }
        }else{
            NSLog(@"ERROR: %@", error);
        }
    }];
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.width/1.777777)];
        CGFloat width   = self.tableView.frame.size.width;
        CGFloat height  = self.tableView.frame.size.width/1.777777777;
        
        _slideShow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        [_slideShow setTag:999];
        [_slideShow setDelegate:self];
        [_slideShow setPagingEnabled: YES];
        [_slideShow setShowsHorizontalScrollIndicator:NO];
        
        CGFloat xP = (width/2) - ((width/2)/2);
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(xP, height-30, width/2, 15)];
        [_pageControl setNumberOfPages:_images.count];
        [_pageControl setCurrentPage:0];
        
        int x = 0;
        
        if(_images.count > 0){
            for (int i = 0; i < _images.count; i++) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, _slideShow.frame.size.height)];
                [img setContentMode:UIViewContentModeScaleAspectFit];
                if([[_images objectAtIndex:i] isKindOfClass:[NSManagedObject class]]){
                    Image *image = [_images objectAtIndex:i];
                    [img sd_setImageWithURL:[NSURL URLWithString:image.imageURL] placeholderImage:[UIImage imageNamed:@"listing_image"]];
                }else{
                    [img setImage:[_images objectAtIndex:i]];
                }
                [img setUserInteractionEnabled:YES];
                //The setup code (in viewDidLoad in your view controller)
                UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActions)];
                [img addGestureRecognizer:singleFingerTap];
                
                x = x + width;
                [_slideShow addSubview:img];
            }
            
            [_slideShow setContentSize:CGSizeMake(x, _slideShow.frame.size.height)];
            [_slideShow setContentOffset:CGPointMake(0, 0)];
            
            [view addSubview:_slideShow];
            [view addSubview:_pageControl];
            [view sizeToFit];
        }else{
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, _slideShow.frame.size.height)];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [img setImage:[UIImage imageNamed:@"load_image"]];
            [img setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActions)];
            [img addGestureRecognizer:singleFingerTap];
            
            x = x + width;
            [_slideShow addSubview:img];
            [view addSubview:_slideShow];
        }
        return view;
    }
    
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return tableView.frame.size.width/1.777777;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                [self showCZPickerForManufacturers];
                break;
            case 1:
                [self showCZPickerForModels];
                break;
            case 2:
                [self showCZPickerForCities];
                break;
            default:
                break;
        }
        
        if(indexPath.row == 3){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Barrio" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                [textField setText:_cellDistrict.detailTextLabel.text];
                textField.keyboardType = UIKeyboardTypeAlphabet;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_cellDistrict.textLabel setTextColor:[UIColor blackColor]];
                [_cellDistrict.detailTextLabel setText:[alert.textFields firstObject].text];
                [_cellDistrict setAccessoryType:UITableViewCellAccessoryCheckmark];
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Precio" message:@"Escoge un precio que este de acuerdo al modelo y estado de tu moto." preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                [textField setText:_cellPrice.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 11;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 7 || [alert.textFields firstObject].text.length > 11){
                    // Invalid price input
                    [_cellPrice.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellPrice setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellPrice.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellPrice.textLabel setTextColor:[UIColor blackColor]];
                    [_cellPrice.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellPrice setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Kilometraje" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                [textField setText:_cellOdometer.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 12;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 1 || [alert.textFields firstObject].text.length > 7){
                    // Invalid price input
                    [_cellOdometer.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellOdometer setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellOdometer.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellOdometer.textLabel setTextColor:[UIColor blackColor]];
                    [_cellOdometer.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellOdometer setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 2){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Modelo (Año)" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                [textField setText:_cellYear.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 13;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length != 4){
                    // Invalid price input
                    [_cellYear.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellYear setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellYear.detailTextLabel setText:[alert.textFields firstObject].text];
                    // UIALERTVIEW
                    
                }else{
                    [_cellYear.textLabel setTextColor:[UIColor blackColor]];
                    [_cellYear.detailTextLabel setText:[alert.textFields firstObject].text];
                    [_cellYear setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 3){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Placa" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                [textField setText:_cellLicense.detailTextLabel.text];
                textField.delegate = self;
                textField.tag = 14;
                textField.keyboardType = UIKeyboardTypeAlphabet;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 5 || [alert.textFields firstObject].text.length > 6){
                    // Invalid price input
                    [_cellLicense.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellLicense setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellLicense.detailTextLabel setText:[[alert.textFields firstObject].text uppercaseString]];
                    // UIALERTVIEW
                    
                }else{
                    [_cellLicense.textLabel setTextColor:[UIColor blackColor]];
                    [_cellLicense.detailTextLabel setText:[[alert.textFields firstObject].text uppercaseString]];
                    [_cellLicense setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 4){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Color" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                // optionally configure the text field
                [textField setText:_cellColor.detailTextLabel.text];
                textField.keyboardType = UIKeyboardTypeAlphabet;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if([alert.textFields firstObject].text.length < 3 || [alert.textFields firstObject].text.length > 12){
                    // Invalid price input
                    [_cellColor.textLabel setTextColor:[UIColor dangerColor]];
                    [_cellColor setAccessoryType:UITableViewCellAccessoryNone];
                    [_cellColor.detailTextLabel setText:[[alert.textFields firstObject].text capitalizedString]];
                    // UIALERTVIEW
                    
                }else{
                    [_cellColor.textLabel setTextColor:[UIColor blackColor]];
                    [_cellColor.detailTextLabel setText:[[alert.textFields firstObject].text capitalizedString]];
                    [_cellColor setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(indexPath.row == 5){
            
        }else if(indexPath.row == 6){
            [self showCZPickerForFeatures];
        }
    }
}


- (void)saveListing{
    if(![self isComplete]){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Te falta algo" message:@"Debes llenar los campos en rojo y subir al menos 2 fotos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    [KVNProgress showProgress:0.1f status:@"Guardando Publicación"];
    
    NSMutableArray *features = [[NSMutableArray alloc]init];
    
    for (Feature *feature in _selectedFeatures) {
        [features addObject:feature.featureID];
    }
    
    
    if(_textAreaDescription.text.length == 0){
        [_textAreaDescription setText:@""];
    }
    
    NSDictionary *params = @{@"manufacturer_id" : [[_selectedManufacturers firstObject] manufacturerID],
                             @"model_id" : [[_selectedModels firstObject] modelID],
                             @"engine_size" : listing.engineSize,
                             @"city_id" : [_selectedCity cityID],
                             @"district" : _cellDistrict.detailTextLabel.text,
                             @"price" : _cellPrice.detailTextLabel.text,
                             @"odometer" : _cellOdometer.detailTextLabel.text,
                             @"license_number" : _cellLicense.detailTextLabel.text,
                             @"color" : _cellColor.detailTextLabel.text,
                             @"year" : _cellYear.detailTextLabel.text,
                             @"description" : _textAreaDescription.text,
                             @"features" : features
                             };
    
    [KVNProgress showProgress:0.3f status:@"Guardando Publicación"];
    
    [[BMCOAPIManager sharedInstance]PUTListing:listing.listingID WithParams:params onCompletion:^(NSNumber *listingID, NSError *error){
        if(!error && listingID){
            [self.navigationController popViewControllerAnimated:YES];
            [KVNProgress showSuccessWithStatus:@"Publicación Guardada Exitosamente"];
        }else{
            [KVNProgress showErrorWithStatus:@"Error al guardar la publicación"];
        }
    }];
}


- (BOOL)isComplete{
    BOOL completed = YES;
    
    if(_images.count < 2){
        completed = NO;
    }
    
    if(_selectedManufacturers.count != 1){
        completed = NO;
        [_cellManufacturer.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellManufacturer.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(_selectedModels.count != 1){
        completed = NO;
        [_cellModel.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellModel.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(!_selectedCity){
        completed = NO;
        [_cellCity.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellCity.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(_cellPrice.detailTextLabel.text.length < 6){
        completed = NO;
        [_cellPrice.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellPrice.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(_cellOdometer.detailTextLabel.text.length == 0){
        completed = NO;
        [_cellOdometer.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellOdometer.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(_cellYear.detailTextLabel.text.length != 4){
        completed = NO;
        [_cellYear.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellYear.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(_cellLicense.detailTextLabel.text.length < 5 || _cellLicense.detailTextLabel.text.length > 6){
        completed = NO;
        [_cellLicense.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellLicense.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(_cellColor.detailTextLabel.text.length < 3){
        completed = NO;
        [_cellColor.textLabel setTextColor:[UIColor dangerColor]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryNone];
    }else{
        [_cellColor.textLabel setTextColor:[UIColor blackColor]];
    }
    
    return completed;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 11){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSCharacterSet *setToRemove = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *setToKeep = [setToRemove invertedSet];
        newString = [[newString componentsSeparatedByCharactersInSet:setToKeep]componentsJoinedByString:@""];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        
        if(textField.text.length >= 11 && ![string isEqualToString:@""])
            return NO;
        
        if (numberOfMatches == 0)
            return NO;
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        NSNumber *myNumber = [f numberFromString:newString];
        
        NSNumber *formatedValue = [[NSNumber alloc] initWithInt:[myNumber intValue]];
        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
        [_currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        textField.text = [_currencyFormatter stringFromNumber:formatedValue];
        return NO;
    }else if(textField.tag == 12){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSCharacterSet *setToRemove = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *setToKeep = [setToRemove invertedSet];
        newString = [[newString componentsSeparatedByCharactersInSet:setToKeep]componentsJoinedByString:@""];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        
        if(textField.text.length >= 7 && ![string isEqualToString:@""])
            return NO;
        
        if (numberOfMatches == 0)
            return NO;
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        NSNumber *myNumber = [f numberFromString:newString];
        
        NSNumber *formatedValue = [[NSNumber alloc] initWithInt:[myNumber intValue]];
        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
        [_currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        textField.text = [_currencyFormatter stringFromNumber:formatedValue];
        return NO;
    }else if(textField.tag == 13){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSCharacterSet *setToRemove = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *setToKeep = [setToRemove invertedSet];
        newString = [[newString componentsSeparatedByCharactersInSet:setToKeep]componentsJoinedByString:@""];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        
        if(textField.text.length >= 4 && ![string isEqualToString:@""])
            return NO;
        
        if (numberOfMatches == 0)
            return NO;
    }else if(textField.tag == 14){
        if(string.length == 0){
            return YES;
        }
        
        // All digits entered
        if (range.location == 6) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.location < 2 && ![[NSCharacterSet letterCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen and parentheses
        if (range.location > 2 && ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)showImageActions{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setTitle:@"Fotos"];
    [actionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    [actionSheet setDelegate:self];
    [actionSheet addButtonWithTitle:@"Subir foto"];
    
    if(_images.count > 0){
        [actionSheet addButtonWithTitle:@"Editar"];
        [actionSheet addButtonWithTitle:@"Eliminar"];
    }
    
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancelar"];
    [actionSheet showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self pickImage];
    }else if(buttonIndex == 1 && _images.count > 0){
        CGFloat pageWidth = _slideShow.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = _slideShow.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        
        NSLog(@"EDIT: %ld", (long)page);
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:[_images objectAtIndex:page]];
        cropController.delegate = self;
        [cropController setTitle:@"Editar"];
        [self presentViewController:cropController animated:YES completion:nil];
    }else if(buttonIndex == 2 && _images.count > 0){
        // DELETE IMAGE
        CGFloat pageWidth = _slideShow.frame.size.width;
        float fractionalPage = _slideShow.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        
        NSLog(@"DELETE: %ld", (long)page);
        Image *image = [_images objectAtIndex:page];
        [_images removeObjectAtIndex:page];
        [self.tableView reloadData];
        
        
        [[BMCOAPIManager sharedInstance]DELETEListingImage:image.imageID onCompletion:^(BOOL success, NSError *error){
            if(success){
                [JDStatusBarNotification showWithStatus:@"Imagen eliminada exitosamente" dismissAfter:3];
            }else{
                [KVNProgress showErrorWithStatus:@"Error al eliminar la imagen"];
                [_images addObject:image];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)pickImage{
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPickerController.allowsEditing = NO;
    photoPickerController.delegate = (id)self;
    [self presentViewController:photoPickerController animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self dismissViewControllerAnimated:YES completion:^{
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    [[BMCOAPIManager sharedInstance]POSTListingImage:image withParams:@{@"listing_id" : listing.listingID} onCompletion:^(id newImage, NSError *error){
        if(!error && newImage){
            [_images addObject:newImage];
            [self.tableView reloadData];
            
            CGRect frame = CGRectMake(0, self.tableView.frame.origin.y, _slideShow.frame.size.width, _slideShow.frame.size.height);
            
            [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:frame completion:^{
                [_slideShow setContentOffset:CGPointMake(_slideShow.frame.size.width*(_images.count-1), 0) animated:YES];
            }];

            [JDStatusBarNotification showWithStatus:@"Imagen cargada exitosamente" dismissAfter:5];
        }else{
            [KVNProgress showErrorWithStatus:@"Error al cargar la imagen"];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(void)showCZPickerForManufacturers{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Marcas"
                                                   cancelButtonTitle:@"Cancelar"
                                                  confirmButtonTitle:@"Seleccionar"];
    [picker setHeaderBackgroundColor:[UIColor primaryColor]];
    [picker setConfirmButtonBackgroundColor:[UIColor primaryColor]];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.allowMultipleSelection = NO;
    picker.tag = 1;
    [picker setSelectedRows:_selectedManufacturersRows];
    [picker show];
}

-(void)showCZPickerForModels{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Referencias (Modelos)"
                                                   cancelButtonTitle:@"Cancelar"
                                                  confirmButtonTitle:@"Seleccionar"];
    [picker setHeaderBackgroundColor:[UIColor primaryColor]];
    [picker setConfirmButtonBackgroundColor:[UIColor primaryColor]];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.allowMultipleSelection = NO;
    picker.tag = 2;
    [picker setSelectedRows:_selectedModelsRows];
    [picker show];
}

-(void)showCZPickerForCities{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Ciudad"
                                                   cancelButtonTitle:@"Cancelar"
                                                  confirmButtonTitle:@"Seleccionar"];
    [picker setHeaderBackgroundColor:[UIColor primaryColor]];
    [picker setConfirmButtonBackgroundColor:[UIColor primaryColor]];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.allowMultipleSelection = NO;
    picker.tag = 3;
    [picker setSelectedRows:_selectedCityRows];
    [picker show];
}

-(void)showCZPickerForFeatures{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Caracteristicas"
                                                   cancelButtonTitle:@"Cancelar"
                                                  confirmButtonTitle:@"Seleccionar"];
    [picker setHeaderBackgroundColor:[UIColor primaryColor]];
    [picker setConfirmButtonBackgroundColor:[UIColor primaryColor]];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    picker.allowMultipleSelection = YES;
    picker.tag = 4;
    [picker setSelectedRows:_selectedFeaturesRows];
    [picker show];
}


# pragma CZpicker delegate
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    if(pickerView.tag == 1){
        return _manufacturers.count;
    }else if(pickerView.tag == 2){
        return _models.count;
    }else if(pickerView.tag == 3){
        return _cities.count;
    }else if(pickerView.tag == 4){
        return _features.count;
    }
    
    return _manufacturers.count;
}



/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    if(pickerView.tag == 1){
        return [[_manufacturers objectAtIndex:row] name];
    }else if(pickerView.tag == 2){
        return [NSString stringWithFormat:@"%@ (%@)", [[_models objectAtIndex:row] name], [[_models objectAtIndex:row] manufacturer].name];
    }else if(pickerView.tag == 3){
        return [[_cities objectAtIndex:row] name];
    }else if(pickerView.tag == 4){
        return [[_features objectAtIndex:row] name];
    }
    
    return [[_manufacturers objectAtIndex:row] name];
}

-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    if(pickerView.tag == 1){
        // Manufacturers
        _selectedManufacturersRows = @[[NSNumber numberWithInteger:row]];
        _selectedManufacturers = @[[_manufacturers objectAtIndex:row]];
        [self setPosibleModels:_selectedManufacturers];
        [_cellManufacturer.detailTextLabel setText:[[_manufacturers objectAtIndex:row] name]];
        [_cellManufacturer setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else if(pickerView.tag == 2){
        // Models
        _selectedModelsRows = @[[NSNumber numberWithInteger:row]];
        _selectedModels = @[[_models objectAtIndex:row]];
        [_cellModel.detailTextLabel setText:[[_models objectAtIndex:row] name]];
        [_cellModel setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else if(pickerView.tag == 3){
        // Cities
        _selectedCityRows = @[[NSNumber numberWithInteger:row]];
        _selectedCity = [_cities objectAtIndex:row];
        [_cellCity.detailTextLabel setText:[[_cities objectAtIndex:row] name]];
        [_cellCity setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows{
    if(pickerView.tag == 4){
        // Cities
        _selectedFeaturesRows = rows;
        NSIndexSet *indexSet = [self indicesOfObjectsInArray:rows];
        _selectedFeatures = [_features objectsAtIndexes:indexSet];
        
        NSString *text = text = [NSString stringWithFormat:@"%@ +%lu", [[_selectedFeatures firstObject] name], (unsigned long)_selectedFeatures.count];
        
        [_cellAditionals.detailTextLabel setText:text];
        [_cellAditionals setAccessoryType:UITableViewCellAccessoryCheckmark];
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

- (void)dismissView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¿Estas Seguro?" message:@"Si cierras perderas todos los cambios que hayas hecho." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Si" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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

@end
