//
//  User.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "User.h"

#import "Listing.h"
#import "IDCDate.h"

@implementation User

+(EKObjectMapping *)objectMapping{
    //
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name",
                                          @"username",
                                          @"email",
                                          @"confirmed",
                                          ]];
        
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"objectID",
                                               @"description"       : @"descriptionText",
                                               @"phone_1"           : @"phone1",
                                               @"phone_2"           : @"phone2",
                                               @"image_url"        : @"imagePath",
                                               @"email_notifications": @"emailNotifications",
                                               @"privacy_name"      : @"privacyName",
                                               @"privacy_phone"     : @"privacyPhone",
                                               }];
        
        // Dates
        [mapping mapKeyPath:@"updated_at" toProperty:@"updatedAt" withDateFormatter:[IDCDate webServiceFormatter]];
        
        // Relationships
        //[mapping hasMany:[Listing class] forKeyPath:@"listings"];
    }];
}

@end
