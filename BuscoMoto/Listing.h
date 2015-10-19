//
//  Listing.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

#import "User.h"
#import "City.h"
#import "Feature.h"
#import "Image.h"
#import "ListingType.h"
#import "Manufacturer.h"
#import "Reference.h"


@interface Listing : EKManagedObjectModel

@property (nullable, nonatomic, retain) NSString *color;
@property (nullable, nonatomic, retain) NSNumber *contacted;
@property (nullable, nonatomic, retain) NSString *descriptionText;
@property (nullable, nonatomic, retain) NSString *district;
@property (nullable, nonatomic, retain) NSNumber *engineSize;
@property (nullable, nonatomic, retain) NSDate *expiresAt;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *licenseNumber;
@property (nullable, nonatomic, retain) NSNumber *liked;
@property (nullable, nonatomic, retain) NSNumber *listingID;
@property (nullable, nonatomic, retain) NSNumber *odometer;
@property (nullable, nonatomic, retain) NSNumber *points;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *slug;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSNumber *views;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSDate *featuredExpiresAt;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) NSSet<Feature *> *features;
@property (nullable, nonatomic, retain) NSSet<Image *> *images;
@property (nullable, nonatomic, retain) ListingType *type;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) Manufacturer *manufacturer;
@property (nullable, nonatomic, retain) Reference *reference;

@end

@interface Listing (CoreDataGeneratedAccessors)

- (void)addFeaturesObject:(NSManagedObject *)value;
- (void)removeFeaturesObject:(NSManagedObject *)value;
- (void)addFeatures:(NSSet<NSManagedObject *> *)values;
- (void)removeFeatures:(NSSet<NSManagedObject *> *)values;

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet<NSManagedObject *> *)values;
- (void)removeImages:(NSSet<NSManagedObject *> *)values;

@end
