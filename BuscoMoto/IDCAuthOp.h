//
//  IDCAuthOp.h
//  UBosque
//
//  Created by Paulo Mogollon on 4/5/15.
//  Copyright (c) 2015 Indesign Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCAuthManager.h"
#import "AFNetworking.h"

@interface IDCAuthOp : NSObject <AuthOp>

@property (strong, readwrite) id responseObject;

- (IDCAuthOp *)initWithAFHTTPClient:(AFHTTPRequestOperationManager *)httpRequestOpManager
                      requestMethod:(NSString *)method
                            forPath:(NSString *)path
                     withParameters:(NSDictionary *)params;

@end