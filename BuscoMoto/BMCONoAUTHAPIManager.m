//
//  BMCONoAUTHAPIManager.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/21/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "BMCONoAUTHAPIManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "Listing.h"
#import "Message.h"
#import "Reference.h"
#import "Feature.h"

static NSString * const connectionManagerBaseURL = @"http://local.buscomoto.co/api/v2";
//static NSString * const connectionManagerBaseURL = @"http://dev.buscomoto.co/api/v2";

@implementation BMCONoAUTHAPIManager

+ (instancetype)sharedInstance {
    static BMCONoAUTHAPIManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Network activity indicator manager setup
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        // Session configuration setup
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{@"User-Agent"    : @"BMCO iOS Client"
                                                       };
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024     // 10MB. memory cache
                                                          diskCapacity:50 * 1024 * 1024     // 50MB. on disk cache
                                                              diskPath:nil];
        
        sessionConfiguration.URLCache = cache;
        sessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        // Initialize the session
        _sharedInstance = [[BMCONoAUTHAPIManager alloc] initWithBaseURL:[NSURL URLWithString:connectionManagerBaseURL] sessionConfiguration:sessionConfiguration];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (!self) return nil;
    
    // Configuraciones adicionales de la sesión
    
    // SSL Pinning
    //    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    //    securityPolicy.SSLPinningMode = AFSSLPinningModePublicKey;
    //    self.securityPolicy = securityPolicy;
    //    NSLog(@"Certificate: %@", securityPolicy.pinnedCertificates);
    
    return self;
}

- (void)GETListingsWithParams:(NSDictionary *) params onCompletion:(GetPaginatorCompletitionBlock)completionBlock{
    [self GET:@"listings" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        @try {
            NSArray *objects = @[];
            NSMutableDictionary *paginator = [[NSMutableDictionary alloc]init];
            if([responseObject isKindOfClass:[NSDictionary class]]){
                paginator = [responseObject mutableCopy];
                NSArray *jsonData = [responseObject objectForKey:@"data"];
                if(jsonData){
                    objects = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:jsonData withMapping:[Listing objectMapping] inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
                }
            }
            
            [paginator removeObjectForKey:@"data"];
            completionBlock(objects, paginator,nil);
        }@catch (NSException *ex) {
            NSLog(@"Exception catched: %@", ex.description);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error fetching user: %@", error);
        completionBlock(nil, nil, error);
    }];
}

- (void)POSTMessageWithParams:(NSDictionary *) params onCompletion:(GetObjectCompletitionBlock)completionBlock{
    NSString *path = [NSString stringWithFormat:@"messages"];
    [self POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        @try {
            Message *message = NULL;
            if([responseObject isKindOfClass:[NSDictionary class]] ){
                NSDictionary *jsonData = [responseObject objectForKey:@"data"];
                if(jsonData){
                    message = [EKMapper objectFromExternalRepresentation:jsonData withMapping:[Message objectMapping]];
                }
            }
            completionBlock(message, nil);
        }@catch (NSException *ex) {
            NSLog(@"Exception catched: %@", ex.description);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR ON MESSAGE: %@", error);
        completionBlock(nil, error);
    }];
}

- (void)GETSearchData:(GetObjectCompletitionBlock)completionBlock{
    NSString *path = [NSString stringWithFormat:@"search"];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @try {
            NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
            if([responseObject isKindOfClass:[NSDictionary class]] ){
                NSDictionary *jsonData = [responseObject objectForKey:@"data"];
                if(jsonData){
                    // Save models and manufacturers to core data
                    NSArray *array = [jsonData objectForKey:@"models"];
                    NSArray *objects = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:array withMapping:[Reference objectMapping] inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
                    [data setObject:objects forKey:@"models"];
                    
                    // Save cities to core data
                    array = [jsonData objectForKey:@"cities"];
                    objects = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:array withMapping:[City objectMapping] inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
                    
                    // Save features to core data
                    array = [jsonData objectForKey:@"features"];
                    objects = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:array withMapping:[Feature objectMapping] inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
                }
            }
            completionBlock(data, nil);
        }@catch (NSException *ex) {
            NSLog(@"Exception catched: %@", ex.description);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSString* errorStr = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        NSLog(@"ERROR: %@", error);
        completionBlock(nil, error);
    }];
}

@end
