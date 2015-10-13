//
//  Image.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Image.h"

@implementation Image

@dynamic imageID;
@dynamic imageURL;
@dynamic ordering;

+(EKManagedObjectMapping *)objectMapping{
    //
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([self class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"imageID",
                                               @"image_url"         : @"imageURL",
                                               @"ordering"          : @"ordering",
                                               }];
        mapping.primaryKey = @"imageID";
    }];
}

@end
