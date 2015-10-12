//
//  IDCAuthOp.m
//  UBosque
//
//  Created by Paulo Mogollon on 4/5/15.
//  Copyright (c) 2015 Indesign Colombia. All rights reserved.
//

#import "IDCAuthOp.h"

@interface IDCAuthOp()
@property(strong, readwrite) AFHTTPRequestOperationManager *httpRequestOpManager;
@property(strong, readwrite) NSString *method;
@property(strong, readwrite) NSString *path;
@property(strong, readwrite) NSDictionary *params;
@property(copy) void (^bodyBlock) (id <AFMultipartFormData>formData);
@end

@implementation IDCAuthOp

@synthesize responseObject;

@synthesize hasHTTPStatus;
@synthesize httpStatusCode;
@synthesize wasSuccessful;
@synthesize error;

- (IDCAuthOp *)initWithAFHTTPClient:(AFHTTPRequestOperationManager *)httpRequestOpManager requestMethod:(NSString *)method forPath:(NSString *)path withParameters:(NSDictionary *)params{
    self.httpRequestOpManager   = httpRequestOpManager;
    self.method                 = method;
    self.path                   = path;
    self.params                 = params;
    return self;
}

- (IDCAuthOp *)initWithAFHTTPClient:(AFHTTPRequestOperationManager *)httpRequestOpManager requestMethod:(NSString *)method forPath:(NSString *)path withParameters:(NSDictionary *)params bodyBlock:(BodyBlock)bodyBlock{
    self.httpRequestOpManager   = httpRequestOpManager;
    self.method                 = method;
    self.path                   = path;
    self.params                 = params;
    self.bodyBlock              = bodyBlock;
    return self;
}

// queue the authorized network operation using the authToken.
// After success or failure, store the results and execute the callback.
// Operation may be called a second time, with a different authToken,
// if it returns wasSuccessful NO, hasHTTPStatus YES, httpStatusCode 401
- (void)queueOpWith:(NSString*)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", authToken]
                                       forHTTPHeaderField:@"Authorization"];
    
    if([self.method  isEqual: @"GET"] || [self.method  isEqual: @"Get"] || [self.method  isEqual: @"get"]){
        [self GETOpWith:authToken callback:callback];
    }else if([self.method  isEqual: @"POST"] || [self.method  isEqual: @"Post"] || [self.method  isEqual: @"post"]){
        if(self.bodyBlock){
            [self POSTBlockOpWith:authToken callback:callback];
        }else{
            [self POSTOpWith:authToken callback:callback];
        }
    }else if([self.method  isEqual: @"PUT"] || [self.method  isEqual: @"Put"] || [self.method  isEqual: @"put"]){
        [self PUTOpWith:authToken callback:callback];
    }else if([self.method  isEqual: @"PATCH"] || [self.method  isEqual: @"Patch"] || [self.method  isEqual: @"patch"]){
        [self PATCHOpWith:authToken callback:callback];
    }else if([self.method  isEqual: @"DELETE"] || [self.method  isEqual: @"Delete"] || [self.method  isEqual: @"delete"]){
        [self DELETEOpWith:authToken callback:callback];
    }
}

- (void)GETOpWith:(NSString *)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager GET:self.path
                        parameters:self.params
    success:^(AFHTTPRequestOperation *operation, id ro) {
        NSLog(@"GET operation success");
        self.responseObject = ro;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = YES;
        self.error          = nil;
        callback();
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        NSLog(@"Failure: %@", e);
        self.responseObject = nil;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = NO;
        self.error          = e;
        callback();
    }];
}

- (void)POSTOpWith:(NSString *)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager POST:self.path
                         parameters:self.params
    success:^(AFHTTPRequestOperation *operation, id ro) {
        NSLog(@"Success: %@", [ro objectForKey:@"error"]);
        self.responseObject = ro;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = YES;
        self.error          = nil;
        callback();
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        NSLog(@"Failure: %@", e);
        self.responseObject = nil;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = NO;
        self.error          = e;
        callback();
    }];
}

- (void)POSTBlockOpWith:(NSString *)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager POST:self.path
                         parameters:self.params
          constructingBodyWithBlock:self.bodyBlock
    success:^(AFHTTPRequestOperation *operation, id ro) {
        NSLog(@"Success: %@", ro);
        self.responseObject = ro;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = YES;
        self.error          = nil;
        callback();
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        //NSLog(@"Failure: %@", e.localizedDescription);
        self.responseObject = nil;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = NO;
        self.error          = e;
        callback();
    }];
}

- (void)PUTOpWith:(NSString *)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager PUT:self.path
                        parameters:self.params
    success:^(AFHTTPRequestOperation *operation, id ro) {
        NSLog(@"Success: %@", [ro objectForKey:@"error"]);
        self.responseObject = ro;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = YES;
        self.error          = nil;
        callback();
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        NSLog(@"Failure: %@", e);
        self.responseObject = nil;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = NO;
        self.error          = e;
        callback();
    }];
}

- (void)PATCHOpWith:(NSString *)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager PATCH:self.path
                          parameters:self.params
    success:^(AFHTTPRequestOperation *operation, id ro) {
        NSLog(@"Success: %@", [ro objectForKey:@"error"]);
        self.responseObject = ro;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = YES;
        self.error          = nil;
        callback();
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        NSLog(@"Failure: %@", e);
        self.responseObject = nil;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = NO;
        self.error          = e;
        callback();
    }];
}

- (void)DELETEOpWith:(NSString *)authToken callback:(void (^)())callback{
    [self.httpRequestOpManager DELETE:self.path
                           parameters:self.params
    success:^(AFHTTPRequestOperation *operation, id ro) {
        NSLog(@"Success: %@", [ro objectForKey:@"error"]);
        self.responseObject = ro;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = YES;
        self.error          = nil;
        callback();
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        NSLog(@"Failure: %@", e);
        self.responseObject = nil;
        self.hasHTTPStatus  = YES;
        self.httpStatusCode = [operation.response statusCode];
        self.wasSuccessful  = NO;
        self.error          = e;
        callback();
    }];
}

@end
