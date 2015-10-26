//
//  AppDelegate.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 9/9/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "AppDelegate.h"

static NSString * const kStoreName = @"com.IDC.BMCO.sqlite";
static NSString * const K_KEYCHAIN_STORE = @"com.IDC.BMCO";

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[MagicalRecord setupCoreDataStack];
    // Setup magical record
    [self copyDefaultStoreIfNecessary];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kStoreName];
    
    // Load common data
    [self loadCommonData];
    
    [[IDCAuthManager sharedInstance]resignAuthorization];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:28.0/255.0 green:123.0/255.0 blue:186.0/255.0 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIImage *icon = [UIImage imageNamed:@"icon_1"];
    UIColor *color = [UIColor colorWithRed:28.0/255.0 green:123.0/255.0 blue:186.0/255.0 alpha:1];
    _splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    
    // customize duration, icon size, or icon color here;
    [self.window.rootViewController.view addSubview:_splashView];
    
    return YES;
}

/**
 * Coredata things
 */
- (void)copyDefaultStoreIfNecessary;{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kStoreName];
    
    // If the expected store doesn't exist, copy the default store.
    if(![fileManager fileExistsAtPath:[storeURL path]]){
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kStoreName stringByDeletingPathExtension] ofType:[kStoreName pathExtension]];
        
        if(defaultStorePath){
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if(!success){
                NSLog(@"Failed to install default store");
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [MagicalRecord saveWithBlockAndWait:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
    [MagicalRecord cleanUp];
}


#pragma LOAD INITAL DATA
-(void)loadCommonData{
    [[BMCONoAUTHAPIManager sharedInstance] GETSearchData:^(id data, NSError *error) {
        if (!error){
            NSLog(@"COMMON DATA LOADED");
        }else{
            NSLog(@"COMMON DATA LOADING ERROR: %@", error);
        }
    }];
}

@end
