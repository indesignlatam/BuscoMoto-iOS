//
//  Feture.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"

@interface Feature : NSObject <EKMappingProtocol>

@property (nonatomic, retain) NSNumber *objectID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSNumber *categoryID;
//@property (nonatomic, retain) FeatureCategory *category;

@end
