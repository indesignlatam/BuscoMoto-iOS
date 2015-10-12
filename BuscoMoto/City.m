//
//  City.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "City.h"

@implementation City

@dynamic cityID;
@dynamic name;
@dynamic ordering;

+(EKManagedObjectMapping *)objectMapping{
    //
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([City class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"cityID",
                                               @"name"              : @"name",
                                               @"ordering"          : @"ordering",
                                               }];
    }];
}

@end
