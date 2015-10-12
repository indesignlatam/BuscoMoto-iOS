//
//  URUNColorManager.h
//  UrUn
//
//  Created by Paulo Mogollon on 11/28/13.
//  Copyright (c) 2013 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIColor(BuscoMoto)

+(UIColor*)colorWithHexString:(NSString*)hex;

+(UIColor*)lighterGrayColor;
+(UIColor*)lightestGrayColor;

+(UIColor*)primaryColor;
+(UIColor*)secondaryColor;
+(UIColor*)ternaryColor;

+(UIColor*)dangerColor;
+(UIColor*)successColor;
+(UIColor*)warningColor;
+(UIColor*)infoColor;


@end
