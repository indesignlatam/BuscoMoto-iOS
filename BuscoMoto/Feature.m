//
//  Feture.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Feature.h"

@implementation Feature

+(EKObjectMapping *)objectMapping{
    //
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"objectID",
                                               @"name"              : @"name",
                                               @"slug"              : @"slug",
                                               @"category_id"       : @"categoryID",
                                               }];
    }];
}

@end
