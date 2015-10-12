//
//  City.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

@interface City : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *cityID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *ordering;

@end
