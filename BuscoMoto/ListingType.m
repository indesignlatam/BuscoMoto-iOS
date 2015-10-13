//
//  ListingType.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "ListingType.h"

@implementation ListingType

@dynamic typeID;
@dynamic name;
@dynamic slug;

+(EKManagedObjectMapping *)objectMapping{
    //
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([self class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"typeID",
                                               @"name"              : @"name",
                                               @"slug"              : @"slug",
                                               }];
        mapping.primaryKey = @"typeID";
    }];
}


@end
