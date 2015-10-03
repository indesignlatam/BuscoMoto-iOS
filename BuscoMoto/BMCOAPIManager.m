//
//  BMCOAPIManager.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "BMCOAPIManager.h"

#import "EKMapper.h"
#import "IDCAuthManager.h"
#import "IDCAuthOp.h"

#import "Listing.h"

@implementation BMCOAPIManager

+ (instancetype)sharedInstance {
    static BMCOAPIManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // Initialize the session
        _sharedInstance = [[BMCOAPIManager alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init{
    if (self = [super init]){
        
    }
    return self;
}

- (void)GETUserWithEmail:(NSString *)email onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"GET"
                                                    forPath:@"api/v2/user_email"
                                             withParameters:@{@"email" : email}];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            NSDictionary *jsonData = [op.responseObject objectForKey:@"data"];
                            NSLog(@"%@", op.responseObject);
                            if(jsonData){
                                User *user = [EKMapper objectFromExternalRepresentation:jsonData withMapping:[User objectMapping]];
                                completionBlock(user, nil);
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                        completionBlock(nil, nil);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    NSLog(@"Error fetching user: %@", op.error);
                    completionBlock(nil, op.error);
                }];
}

- (void)GETListings:(GetArrayCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"GET"
                                                    forPath:@"api/v2/user/listings"
                                             withParameters:nil];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            NSArray *jsonData = [op.responseObject objectForKey:@"data"];
                            if(jsonData){
                                NSArray *objects = [EKMapper arrayOfObjectsFromExternalRepresentation:jsonData
                                                                                          withMapping:[Listing objectMapping]];
                                completionBlock(objects, nil);
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    NSLog(@"Error fetching user: %@", op.error);
                    completionBlock(nil, op.error);
                }];
}

- (void)POSTLikeWithParams:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:[NSString stringWithFormat:@"%@%@%@", @"api/v2/listings/", objectID, @"/like"]
                                             withParameters:nil];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                completionBlock([[data objectForKey:@"liked"] boolValue], nil);
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    completionBlock(nil, op.error);
                }];
}

@end
