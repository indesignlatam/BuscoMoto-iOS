//
//  ListingType.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

@interface ListingType : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *typeID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *slug;



@end
