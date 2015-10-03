//
//  Image.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Image.h"

@implementation Image

+(EKObjectMapping *)objectMapping{
    //
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"objectID",
                                               @"image_url"         : @"imageURL",
                                               @"ordering"          : @"ordering",
                                               }];
    }];
}

@end
