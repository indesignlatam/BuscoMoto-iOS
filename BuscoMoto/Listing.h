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
#import "ListingType.h"


@interface Listing : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *listingID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSString *district;
@property (nonatomic, retain) NSString *descriptionText;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *licenseNumber;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *engineSize;
@property (nonatomic, retain) NSNumber *year;
@property (nonatomic, retain) NSNumber *odometer;
@property (nonatomic, retain) NSNumber *views;
@property (nonatomic, retain) NSNumber *points;

@property BOOL liked;
@property bool contacted;

@property (nonatomic, retain) NSDate *featuredExpiresAt;
@property (nonatomic, retain) NSDate *expiresAt;
@property (nonatomic, retain) NSDate *updatedAt;


@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *features;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) ListingType *type;

@end

@interface Listing (CoreDataGeneratedAccessors)

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
