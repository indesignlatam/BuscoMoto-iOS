//
//  Image.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

#import "Listing.h"

@interface Image : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *imageID;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSNumber *ordering;


@end
