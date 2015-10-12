//
//  Feture.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/22/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <EasyMapping/EasyMapping.h>

@interface Feature : EKManagedObjectModel

@property (nonatomic, retain) NSNumber *featureID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSNumber *categoryID;
//@property (nonatomic, retain) FeatureCategory *category;

@end
