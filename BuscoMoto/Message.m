//
//  Message.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/26/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "Message.h"

@implementation Message

+(EKObjectMapping *)objectMapping{
    //
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{@"id"                : @"objectID",
                                               @"name"              : @"name",
                                               @"email"             : @"email",
                                               @"phone"             : @"phone",
                                               @"comments"          : @"comments",
                                               }];
        
        // Dates
        [mapping mapKeyPath:@"created_at" toProperty:@"createdAt" withDateFormatter:[IDCDate webServiceFormatter]];
        [mapping mapKeyPath:@"updated_at" toProperty:@"updatedAt" withDateFormatter:[IDCDate webServiceFormatter]];
        
        // Relationships
        [mapping hasOne:[User class] forKeyPath:@"user"];
        [mapping hasMany:[Listing class] forKeyPath:@"listing"];
    }];
}

@end
