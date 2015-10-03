//
//  ModelReference.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/26/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

#import "Manufacturer.h"

@interface Reference : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *modelID;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSDate *updatedAt;

@property (nonatomic, retain) Manufacturer *manufacturer;

@end
