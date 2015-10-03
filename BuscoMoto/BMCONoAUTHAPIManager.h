//
//  BMCONoAUTHAPIManager.h
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^GetObjectCompletitionBlock)(id data, NSError *error);
typedef void (^GetArrayCompletitionBlock)(NSArray *data, NSError *error);
typedef void (^GetPaginatorCompletitionBlock)(NSArray *data, NSDictionary *paginator, NSError *error);

@interface BMCONoAUTHAPIManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)GETListingsWithParams:(NSDictionary *) params onCompletion:(GetPaginatorCompletitionBlock)completionBlock;
- (void)POSTMessageWithParams:(NSDictionary *) params onCompletion:(GetObjectCompletitionBlock)completionBlock;
- (void)GETSearchData:(GetObjectCompletitionBlock)completionBlock;
@end
