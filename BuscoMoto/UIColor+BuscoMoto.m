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
    return [UIColor colorWithHexString:@"1C7BBA"];
}
+(UIColor*)secondaryColor{
    return [UIColor colorWithHexString:@"00a99d"];
}
+(UIColor*)ternaryColor{
    return [UIColor colorWithHexString:@"FF2D55"];
}

+(UIColor*)successColor{
    return [UIColor colorWithHexString:@"00a26a"];
}
+(UIColor*)warningColor{
    return [UIColor colorWithHexString:@"f7af00"];
}
+(UIColor*)dangerColor{
    return [UIColor colorWithHexString:@"ff3b30"];
}
+(UIColor*)infoColor{
    return [UIColor colorWithHexString:@"eeeeee"];
}
@end
