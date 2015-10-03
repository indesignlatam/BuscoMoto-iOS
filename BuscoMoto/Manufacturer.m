//
//  Manufacturer.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/26/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Manufacturer.h"

@implementation Manufacturer

@dynamic manufacturerID;
@dynamic name;
@dynamic imageURL;
@dynamic ordering;
@dynamic updatedAt;

+ (EKManagedObjectMapping *)objectMapping{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([Manufacturer class]) withBlock:^(EKManagedObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"manufacturerID",
                                               @"name"              : @"name",
                                               @"image_url"         : @"imageURL",
                                               @"ordering"          : @"ordering",
                                               }];
        
        // Dates
        [mapping mapKeyPath:@"updated_at" toProperty:@"updatedAt" withDateFormatter:[IDCDate webServiceFormatter]];
        
        mapping.primaryKey = @"manufacturerID";
    }];
}

@end
