//
//  URUNColorManager.m
//  UrUn
//
//  Created by Paulo Mogollon on 11/28/13.
//  Copyright (c) 2013 Indesign Colombia. All rights reserved.
//

#import "UIColor+BuscoMoto.h"

@implementation UIColor(BuscoMoto)

+ (UIColor*)colorWithHexString:(NSString*)hex{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6){
        return [UIColor grayColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString length] != 6){
        return  [UIColor grayColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIColor*)lighterGrayColor{
    return [UIColor colorWithWhite:0.804 alpha:1.000];
}
+(UIColor*)lightestGrayColor{
    return [UIColor colorWithWhite:0.95 alpha:1.000];
}
// APP Colors
+(UIColor*)primaryColor{
    return [UIColor colorWithRed:28.0/255.0 green:123.0/255.0 blue:186.0/255.0 alpha:1];
}
+(UIColor*)secondaryColor{
    return [UIColor colorWithRed:62.0f/255.0f green:71.0f/255.0f blue:41.0f/255.0f alpha:1.0];
}

@end
