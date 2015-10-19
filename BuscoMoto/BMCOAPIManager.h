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
- (void)PUTUser:(NSNumber *)userID withParams:(NSDictionary*)params onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)GETListings:(GetArrayCompletitionBlock)completionBlock;
- (void)POSTLikeWithParams:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock;
- (void)POSTRenovateListingWithID:(NSNumber *)objectID onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)DELETEListingWithID:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock;
- (void)POSTListingWithParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)POSTListingImage:(UIImage*)image withParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)PUTListing:(NSNumber *)objectID WithParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)DELETEListingImage:(NSNumber *)imageID onCompletion:(GetBOOLCompletitionBlock)completionBlock;

@end
