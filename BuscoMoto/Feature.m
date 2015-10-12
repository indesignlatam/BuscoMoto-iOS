//
//  Feture.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Feature.h"

@implementation Feature

@dynamic featureID;
@dynamic name;
@dynamic slug;
@dynamic categoryID;

+(EKManagedObjectMapping *)objectMapping{
    //
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([Feature class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"featureID",
                                               @"name"              : @"name",
                                               @"slug"              : @"slug",
                                               @"category_id"       : @"categoryID",
                                               }];
    }];
}

@end
