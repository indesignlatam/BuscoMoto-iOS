//
//  OACSAuthClient.m
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

#import "IDCAuthManager.h"

static NSString * const K_BASEURL       = @"http://lapi.buscomoto.co/";
//static NSString * const K_BASEURL       = @"http://dev.buscomoto.co/";
static NSString * const K_CLIENTID      = @"pruebas";
static NSString * const K_CLIENTSECRET  = @"246253d6839bc36084d19545a0d1b88fe07ee099";
static NSString * const K_TOKENPATH     = @"oauth/access_token";



@implementation IDCAuthManager

+ (instancetype)sharedInstance {
    static IDCAuthManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Session configuration setup
        NSURL *baseUrl          = [NSURL URLWithString:K_BASEURL];
        NSString *clientID      = K_CLIENTID;
        NSString *clientSecret  = K_CLIENTSECRET;
        
        // Initialize the session
        _sharedInstance = [[IDCAuthManager alloc] initWithBaseURL:baseUrl
                                                        clientID:clientID
                                                          secret:clientSecret];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:baseUrl clientID:clientID secret:clientSecret{
    self = [super initWithBaseURL:baseUrl
                         clientID:clientID
                           secret:clientSecret];
    if (!self) return nil;
    
    // Set the request manager
    _httpRequestOpManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:K_BASEURL]];
    [_httpRequestOpManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // Set credential if exist
    AFOAuthCredential *credentials = [AFOAuthCredential retrieveCredentialWithIdentifier:self.serviceProviderIdentifier];
    if (credentials) {
        self.creds = credentials;
//        if (self.creds){
//            [self setCredential:(NSURLCredential *)_creds];
//        }
    }
    
    // Configuraciones adicionales de la sesión
    
    // SSL Pinning
    //    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    //    securityPolicy.SSLPinningMode = AFSSLPinningModePublicKey;
    //    self.securityPolicy = securityPolicy;
    //    NSLog(@"Certificate: %@", securityPolicy.pinnedCertificates);
    
    return self;
}

- (BOOL)isAuthorized {
    AFOAuthCredential *credentials = [AFOAuthCredential retrieveCredentialWithIdentifier:self.serviceProviderIdentifier];
    return credentials && self;
}

- (BOOL)isConfigured {
    return self && K_BASEURL && K_CLIENTID && K_CLIENTSECRET && K_TOKENPATH;
}

// Get the access token
- (void)authorizeUser:(NSString *)username password:(NSString *)password onSuccess:(void (^)(AFOAuthCredential*))success onFailure:(void (^)(NSString *))failure {
    [self authenticateUsingOAuthWithURLString:K_TOKENPATH
                                     username:username
                                     password:password
                                        scope:@""
    success:^(AFOAuthCredential *credential) {
        [AFOAuthCredential storeCredential:credential withIdentifier:self.serviceProviderIdentifier];
        NSLog(@"Credentials retrived");
        self.creds = credential;
        success(credential);
    }
    failure:^(NSError *error) {
        NSLog(@"OAuth client authorization error: %@", error);
        NSDictionary *uinfo = [error userInfo];
      
        NSHTTPURLResponse *response = [uinfo valueForKey:AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger status = response.statusCode;
        if (400 <= status && status < 500) {
            [self resignAuthorization];
        }
        failure([uinfo valueForKey:NSLocalizedRecoverySuggestionErrorKey]);
    }];
}

- (void)authorizedOp:(id<AuthOp>)op onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure{
    [self authorizedOp:op onSuccess:success onFailure:failure retry:YES];
}

- (void)resignAuthorization {
    // TODO tell the authorization server to deny the client grant from this user
    //[self.oauthManager clearAuthorizationHeader];
    [AFOAuthCredential deleteCredentialWithIdentifier:self.serviceProviderIdentifier];
    self.creds = nil;
}

#pragma mark private

- (void)authorizedOp:(id<AuthOp>)op onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure retry:(BOOL) doRetry {
    if (!self.creds){
        failure(@"Application is not authorized");
    }else if (self.creds.expired && doRetry){
        [self refreshAndRetry:op onSuccess:success onFailure:failure];
    }else{
        [op queueOpWith:[self.creds accessToken] callback:^(void){
            if ([op wasSuccessful]){
                success();
            }else{
                long status = [op hasHTTPStatus] ? [op httpStatusCode] : 0;
                if (doRetry && 401 == status){
                    [self refreshAndRetry:op
                                onSuccess:success
                                onFailure:failure];
                }else{
//                    if (401 <= status && status < 500){
//                        [self resignAuthorization];
//                    }
                    NSError *error = [op error];
                    failure(error.userInfo[@"NSLocalizedDescription"]);
                }
            }
        }];
    }
}

- (void)refreshAndRetry:(id<AuthOp>)op onSuccess:(void (^)())success onFailure:(void (^)(NSString *))failure {
    if (self.creds.refreshToken) {
        [self authenticateUsingOAuthWithURLString:K_TOKENPATH
                                     refreshToken:self.creds.refreshToken
        success:^(AFOAuthCredential *credential) {
            [AFOAuthCredential storeCredential:credential withIdentifier:self.serviceProviderIdentifier];
            self.creds = credential;
            [self authorizedOp:op onSuccess:success onFailure:failure retry:NO];
        }
        failure:^(NSError *error) {
            NSLog(@"OAuth client authorization error: %@", error);
            NSDictionary *uinfo = [error userInfo];
          
            NSHTTPURLResponse *response = [uinfo valueForKey:AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger status = response.statusCode;
            // Error 400 if refresh_token not valid
            // Error 401 client credentials not valid
            if (400 == status || 401 == status) {
                [self resignAuthorization];
            }
            NSLog(@"Error on refresh: %@", [uinfo valueForKey:NSLocalizedRecoverySuggestionErrorKey]);
            failure(@"Failed to authorize");
        }];
    }else{
        failure(@"Application is not authorized");
    }
}

@end
