//
//  ModelReference.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/26/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Reference.h"

@implementation Reference

@dynamic modelID;
@dynamic name;
@dynamic manufacturer;
@dynamic updatedAt;

+ (EKManagedObjectMapping *)objectMapping{
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([Reference class]) withBlock:^(EKManagedObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"modelID",
                                               @"name"              : @"name",
                                               }];
        // Dates
        [mapping mapKeyPath:@"updated_at" toProperty:@"updatedAt" withDateFormatter:[IDCDate webServiceFormatter]];
        
        // Relationships
        [mapping hasOne:[Manufacturer class] forKeyPath:@"manufacturer"];
        
        mapping.primaryKey = @"modelID";
    }];
}

@end
