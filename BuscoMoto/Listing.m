//
//  Listing.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Listing.h"

#import "IDCDate.h"

@implementation Listing

+(EKObjectMapping *)objectMapping{
    //
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"title",
                                          @"slug",
                                          @"district",
                                          @"color",
                                          @"price",
                                          @"year",
                                          @"odometer",
                                          @"views",
                                          @"points",
                                          ]];
        
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"objectID",
                                               @"description"       : @"descriptionText",
                                               @"license_number"    : @"licenseNumber",
                                               @"image_url"         : @"imageURL",
                                               @"engine_size"       : @"engineSize",
                                               }];
        
        // Dates
        [mapping mapKeyPath:@"featured_expires_at" toProperty:@"featuredExpiresAt" withDateFormatter:[IDCDate webServiceFormatter]];
        [mapping mapKeyPath:@"expires_at" toProperty:@"expiresAt" withDateFormatter:[IDCDate webServiceFormatter]];
        [mapping mapKeyPath:@"updated_at" toProperty:@"updatedAt" withDateFormatter:[IDCDate webServiceFormatter]];
        
        // Relationships
        [mapping hasOne:[User class] forKeyPath:@"user"];
        [mapping hasOne:[City class] forKeyPath:@"city"];
        [mapping hasOne:[ListingType class] forKeyPath:@"listing_type" forProperty:@"type"];
        [mapping hasMany:[Image class] forKeyPath:@"images"];
        [mapping hasMany:[Feature class] forKeyPath:@"features"];
    }];
}

@end
