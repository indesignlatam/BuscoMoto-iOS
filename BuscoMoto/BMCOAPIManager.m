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
                                                    forPath:@"api/v2/user_email"
                                             withParameters:@{@"email" : email}];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            NSDictionary *jsonData = [op.responseObject objectForKey:@"data"];
                            if(jsonData){
                                User *user = [User objectWithProperties:jsonData inContext:[NSManagedObjectContext MR_defaultContext]];
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
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)PUTUser:(NSNumber *)userID withParams:(NSDictionary*)params onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"PUT"
                                                    forPath:[NSString stringWithFormat:@"api/v2/user/%@", userID]
                                             withParameters:params];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            NSDictionary *jsonData = [op.responseObject objectForKey:@"data"];
                            if(jsonData){
                                User *user = [User objectWithProperties:jsonData inContext:[NSManagedObjectContext MR_defaultContext]];
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
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
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
                            if([op.responseObject objectForKey:@"data"]){
                                NSDictionary *data = [op.responseObject objectForKey:@"data"];
                                NSArray *jsonData = [data objectForKey:@"listings"];
                                if(jsonData){
                                    NSArray *listigns = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:jsonData withMapping:[Listing objectMapping] inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
                                    completionBlock(listigns, nil);
                                }
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)POSTLikeWithParams:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:[NSString stringWithFormat:@"api/v2/listings/%@/like", objectID]
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
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)POSTListingWithParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:@"api/v2/listings"
                                             withParameters:params];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                if([data objectForKey:@"success"]){
                                    completionBlock([data objectForKey:@"id"], nil);
                                }else{
                                    completionBlock(nil, nil);
                                }
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)PUTListing:(NSNumber *)objectID WithParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"PUT"
                                                    forPath:[NSString stringWithFormat:@"api/v2/listings/%@", objectID]
                                             withParameters:params];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                if([data objectForKey:@"success"]){
                                    completionBlock([data objectForKey:@"id"], nil);
                                }else{
                                    completionBlock(nil, nil);
                                }
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}


- (void)POSTListingImage:(UIImage*)image withParams:(NSDictionary *)params onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:@"api/v2/listings/image"
                                             withParameters:params
                                                  bodyBlock:^(id <AFMultipartFormData>formData) {
                                                      NSData *data = UIImageJPEGRepresentation(image, 0.8);
                                                      [formData appendPartWithFileData:data name:@"image" fileName:@"temp_image.jpeg" mimeType:@"image/jpeg"];
                                                  }];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            if([[op.responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                                NSDictionary *data = [[op.responseObject objectForKey:@"data"] objectForKey:@"image"];
                                Image *newImage = [Image objectWithProperties:data inContext:[NSManagedObjectContext MR_defaultContext]];
                                completionBlock(newImage, nil);
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"ERROR: %@", localizedDescription);
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)DELETEListingImage:(NSNumber *)imageID onCompletion:(GetBOOLCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"DELETE"
                                                    forPath:[NSString stringWithFormat:@"api/v2/listings/image/%@", imageID]
                                             withParameters:nil];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            if([[op.responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                                completionBlock([op.responseObject objectForKey:@"data"], nil);
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"ERROR: %@", localizedDescription);
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)POSTRenovateListingWithID:(NSNumber *)objectID onCompletion:(GetObjectCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"POST"
                                                    forPath:[NSString stringWithFormat:@"api/v2/listings/%@/renovate", objectID]
                                             withParameters:nil];
    [manager authorizedOp:op
                onSuccess:^() {
                    @try {
                        if([op.responseObject isKindOfClass:[NSDictionary class]]){
                            id data = [op.responseObject objectForKey:@"data"];
                            if([data isKindOfClass:[NSDictionary class]]){
                                Listing *listing = [Listing objectWithProperties:data inContext:[NSManagedObjectContext MR_defaultContext]];
                                completionBlock(listing , nil);
                            }
                        }
                    }@catch (NSException *ex) {
                        NSLog(@"Exception catched: %@", ex.description);
                    }
                }
                onFailure:^(NSString *localizedDescription) {
                    NSLog(@"%@", localizedDescription);
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

- (void)DELETEListingWithID:(NSNumber *)objectID onCompletion:(GetBOOLCompletitionBlock)completionBlock{
    IDCAuthManager *manager = [IDCAuthManager sharedInstance];
    IDCAuthOp *op = [[IDCAuthOp alloc] initWithAFHTTPClient:manager.httpRequestOpManager
                                              requestMethod:@"DELETE"
                                                    forPath:[NSString stringWithFormat:@"api/v2/listings/%@", objectID]
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
                    if(op.error.code == -1009){
                        [CRToastManager showNotificationWithMessage:@"No estas conectado a internet" completionBlock:nil];
                    }
                    completionBlock(nil, op.error);
                }];
}

@end
