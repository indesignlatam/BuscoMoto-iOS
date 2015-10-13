//
//  User.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

@interface User : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone1;
@property (nonatomic, retain) NSString *phone2;
@property (nonatomic, retain) NSString *descriptionText;
@property (nonatomic, retain) NSString *imageURL;

@property BOOL emailNotifications;
@property BOOL privacyName;
@property BOOL privacyPhone;
@property BOOL confirmed;

@property (nonatomic, retain) NSDate *updatedAt;

@end
