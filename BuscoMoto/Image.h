//
//  Image.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"

@interface Image : NSObject <EKMappingProtocol>

@property (nonatomic, retain) NSNumber *objectID;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSNumber *ordering;

@end
