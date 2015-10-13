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

@dynamic name;
@dynamic username;
@dynamic email;
@dynamic confirmed;
@dynamic userID;
@dynamic descriptionText;
@dynamic phone1;
@dynamic phone2;
@dynamic imageURL;
@dynamic emailNotifications;
@dynamic privacyName;
@dynamic privacyPhone;
@dynamic updatedAt;



+(EKManagedObjectMapping *)objectMapping{
    //
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([self class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name",
                                          @"username",
                                          @"email",
                                          @"confirmed",
                                          ]];
        
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"userID",
                                               @"description"       : @"descriptionText",
                                               @"phone_1"           : @"phone1",
                                               @"phone_2"           : @"phone2",
                                               @"image_url"         : @"imageURL",
                                               @"email_notifications": @"emailNotifications",
                                               @"privacy_name"      : @"privacyName",
                                               @"privacy_phone"     : @"privacyPhone",
                                               }];
        
        // Dates
        [mapping mapKeyPath:@"updated_at" toProperty:@"updatedAt" withDateFormatter:[IDCDate webServiceFormatter]];
        
        // Relationships
        //[mapping hasMany:[Listing class] forKeyPath:@"listings"];
        
        mapping.primaryKey = @"userID";
    }];
}

@end
