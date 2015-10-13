//
//  BMCOAPIManager.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "BMCOAPIManager.h"

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
                                                    forPath:@"v2/user_email"
                                             withParameters:@{@"email" : email}];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            NSDictionary *jsonData = [op.responseObject objectForKey:@"data"];
                            NSLog(@"%@", op.responseObject);
                            if(jsonData){
                                User *user = [EKManagedObjectMapper objectFromExternalRepresentation:jsonData withMapping:[User objectMapping] inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
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
                                                    forPath:@"v2/user/listings"
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
                                                    forPath:[NSString stringWithFormat:@"%@%@%@", @"v2/listings/", objectID, @"/like"]
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

- (void)POSTListingWithParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:@"v2/listings"
                                             withParameters:params];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        NSLog(@"RO; %@", op.responseObject);
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                Listing *listing = [EKMapper objectFromExternalRepresentation:data withMapping:[Listing objectMapping]];
                                
                                completionBlock(listing, nil);
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

- (void)POSTListingImage:(UIImage*)image withParams:(NSDictionary *)params onCompletion:(GetBOOLCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:@"v2/listings/image"
                                             withParameters:params
                                                  bodyBlock:^(id <AFMultipartFormData>formData) {
                                                      NSData *data = UIImageJPEGRepresentation(image, 0.8);
                                                      [formData appendPartWithFileData:data name:@"image" fileName:@"temp_image.jpeg" mimeType:@"image/jpeg"];
                                                  }];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        NSLog(@"RO; %@", op.responseObject);
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            //id data = [op.responseObject objectForKey:@"data"];
//                            if([data isKindOfClass:[NSDictionary class]]){
//                                Listing *listing = [EKMapper objectFromExternalRepresentation:data withMapping:[Listing objectMapping]];
//                                
//                                
//                            }
                            completionBlock(true, nil);
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"ERROR LD: %@", localizedDescription);
                    completionBlock(nil, op.error);
                }];
}

- (void)POSTRenovateListingWithID:(NSNumber *)objectID onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:[NSString stringWithFormat:@"v2/listings/%@/renovate", objectID]
                                             withParameters:nil];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                Listing *listing = [EKMapper objectFromExternalRepresentation:data withMapping:[Listing objectMapping]];
                                completionBlock(listing, nil);
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

- (void)DELETEListingWithID:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"DELETE"
                                                    forPath:[NSString stringWithFormat:@"v2/listings/%@", objectID]
                                             withParameters:nil];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                completionBlock([data objectForKey:@"success"], nil);
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
