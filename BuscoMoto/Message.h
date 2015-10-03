//
//  Message.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/26/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EKMappingProtocol.h"
#import "Listing.h"
#import "User.h"

@interface Message : NSObject <EKMappingProtocol>

@property (nonatomic, retain) NSNumber *objectID;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *comments;

@property BOOL read;
@property BOOL answered;

@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;

@property (nonatomic, retain) Listing *listing;
@property (nonatomic, retain) User *user;

@end
