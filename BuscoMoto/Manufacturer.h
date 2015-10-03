//
//  Manufacturer.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/26/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

@interface Manufacturer : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *manufacturerID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSNumber *ordering;

@property (nonatomic, retain) NSDate *updatedAt;

@end
