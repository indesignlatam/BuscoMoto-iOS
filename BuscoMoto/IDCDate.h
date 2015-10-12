//
//  APPUDate.h
//  UBosque
//
//  Created by Indesign on 6/12/14.
//  Copyright (c) 2014 Indesign Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCDate : NSObject

+ (NSCalendar*)getCalendar;
+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)webServiceFormatter;
+ (NSDateFormatter *)webServiceReverseFormatter;
+ (NSDateFormatter*)completeDateFormatter;
+ (NSDateFormatter *)daynameMonthDaynumberDateFormatter;
+ (NSDateFormatter *)hourMeridianFormatter;
+ (NSDateFormatter *)hourFormatter;
+ (NSString*)getDayName:(int)dayNumber;
+ (NSString*)getTimeSinse:(NSTimeInterval)timeInt;
+ (NSString*)getExpiresIn:(NSDate*)date;
+ (NSString*)getArrivesIn:(NSTimeInterval)timeint;

@end
