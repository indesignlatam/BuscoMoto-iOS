//
//  OACSAuthClient.h
//  OAuthClientSetup
//
//  Created by Douglas Lovell on 2/5/14.
//  Copyright (c) 2014 Telegraphy Interactive
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>
#import "AFOAuth2Manager.h"
#import "AFNetworking.h"

@protocol AuthOp
// queue the authorized network operation using the authToken.
// After success or failure, store the results and execute the callback.
// Operation may be called a second time, with a different authToken,
// if callback finds wasSuccessful NO, hasHTTPStatus YES, httpStatusCode 401
- (void)queueOpWith:(NSString*)authToken callback:(void (^)())callback;

// whether the operation returned an HTTP status code
@property (readwrite) BOOL hasHTTPStatus;

// available if hasHTTPStatus returns YES
@property (readwrite) long httpStatusCode;

// whether the operation succeeded
@property (readwrite) BOOL wasSuccessful;

// error available if wasSuccessful returns NO
@property (strong, readwrite) NSError *error;

@end

@interface IDCAuthManager : AFOAuth2Manager

@property (strong, nonatomic) AFHTTPRequestOperationManager *httpRequestOpManager;
@property (strong, nonatomic) AFOAuthCredential *creds;

+ (instancetype)sharedInstance;

- (BOOL)isAuthorized;
- (BOOL)isConfigured;
- (void)authorizeUser:(NSString *)username password:(NSString *)password onSuccess:(void (^)(AFOAuthCredential*))success onFailure:(void (^)(NSString *))failure;
- (void)authorizedOp:(id<AuthOp>)op onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure;
- (void)resignAuthorization;

@end
