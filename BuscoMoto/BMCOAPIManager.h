//
//  BMCOAPIManager.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GetObjectCompletitionBlock)(id data, NSError *error);
typedef void (^GetBOOLCompletitionBlock)(BOOL success, NSError *error);
typedef void (^GetArrayCompletitionBlock)(NSArray *data, NSError *error);

@interface BMCOAPIManager : NSObject

+ (instancetype)sharedInstance;

- (void)GETUserWithEmail:(NSString *)email onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)GETListings:(GetArrayCompletitionBlock)completionBlock;
- (void)POSTLikeWithParams:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock;

@end
