//
//  APPUDate.m
//  UBosque
//
//  Created by Indesign on 6/12/14.
//  Copyright (c) 2014 Indesign Colombia. All rights reserved.
//

#import "IDCDate.h"

@implementation IDCDate

+ (NSCalendar*)getCalendar{
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    
    return calendar;
}

+ (NSDateFormatter *)dateFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        [kDateFormatter setLocale:[NSLocale currentLocale]];
        kDateFormatter.dateFormat = @"yyyy-MM-dd";  // you configure this based on the strings that your webservice uses!!
    });
    
    return kDateFormatter;
}

+ (NSDateFormatter *)webServiceFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        kDateFormatter.timeZone = [NSTimeZone localTimeZone];
        kDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";  // you configure this based on the strings that your webservice uses!!
    });
    return kDateFormatter;
}

+ (NSDateFormatter *)webServiceReverseFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        kDateFormatter.timeZone = [NSTimeZone localTimeZone];
        kDateFormatter.dateFormat = @"yyyy-MM-dd%20HH:mm:ss";  // you configure this based on the strings that your webservice uses!!
    });
    return kDateFormatter;
}

+ (NSDateFormatter*)completeDateFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *gmt = [NSTimeZone localTimeZone];
        [kDateFormatter setTimeZone:gmt];
        [kDateFormatter setLocale:[NSLocale currentLocale]];
        [kDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    
    return kDateFormatter;
}

+ (NSDateFormatter *)daynameMonthDaynumberDateFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages]objectAtIndex:0]];
        kDateFormatter.dateFormat = @"EEEE, MMM dd";  // you configure this based on the strings that your webservice uses!!
    });
    
    return kDateFormatter;
}

+ (NSDateFormatter *)hourMeridianFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.timeZone = [NSTimeZone localTimeZone];
        kDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages]objectAtIndex:0]];
        kDateFormatter.dateFormat = @"h:mm a";  // you configure this based on the strings that your webservice uses!!
    });
    
    return kDateFormatter;
}

+ (NSDateFormatter *)hourFormatter{
    static NSDateFormatter *kDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.timeZone = [NSTimeZone localTimeZone];
        kDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages]objectAtIndex:0]];
        kDateFormatter.dateFormat = @"hh:mm:ss";  // you configure this based on the strings that your webservice uses!!
    });
    
    return kDateFormatter;
}


+ (NSString*)getTimeSinse:(NSTimeInterval)timeInt{
    if(timeInt < 60){
        return NSLocalizedString(@"ONE_MINUTE", @"ONE MINUTE SINCE (1m)");
    }else if (timeInt < 3600){
        return [NSString stringWithFormat:NSLocalizedString(@"MINUTES_SINSE", @"MINUTES SINCE (%dm)"), (int)timeInt/60];
    }else if (timeInt < 86400){
        return [NSString stringWithFormat:NSLocalizedString(@"HOURS_SINCE", @"HOURS SINCE (%dh)"), (int)timeInt/3600];
    }else if (timeInt < 604800){
        return [NSString stringWithFormat:NSLocalizedString(@"DAYS_SINSE", @"DAYS SINCE (%dD)"), (int)timeInt/86400];
    }else if (timeInt < 2592000){
        return [NSString stringWithFormat:NSLocalizedString(@"WEEKS_SINSE", @"WEEKS SINCE (%dw)"), (int)timeInt/604800];
    }else if (timeInt < 31104000){
        return [NSString stringWithFormat:NSLocalizedString(@"MONTHS_SINSE", @"MONTHS SINCE (%dM)"), (int)timeInt/2592000];
    }else{
        return [NSString stringWithFormat:NSLocalizedString(@"YEARS_SINSE", @"YEARS SINCE (%dY)"), (int)timeInt/31104000];
    }
    return @"";
}

+ (NSString*)getDayName:(int)dayNumber{
    if(dayNumber==1){
        return NSLocalizedString(@"MONDAY", @"Lunes");
    }else if (dayNumber==2){
        return NSLocalizedString(@"TUESDAY", @"Martes");
    }else if (dayNumber==3){
        return NSLocalizedString(@"WEDNESDAY", @"Miercoles");
    }else if (dayNumber==4){
        return NSLocalizedString(@"THURSDAY", @"Jueves");
    }else if (dayNumber==5){
        return NSLocalizedString(@"FRIDAY", @"Viernes");
    }else if (dayNumber==6){
        return NSLocalizedString(@"SATURDAY", @"Sabado");
    }else if (dayNumber==7){
        return NSLocalizedString(@"SUNDAY", @"Domingo");
    }else{
        return NSLocalizedString(@"ERROR", @"error");
    }
}

+ (NSString*)getOpensOrClosesIn:(NSTimeInterval)timeint or:(NSTimeInterval)timeintDue{
    if(timeint<0){// no ha abierto
        if (timeint < -31104000){
            return [NSString stringWithFormat:NSLocalizedString(@"OPENS_IN_YEARS", @"Abre en (%dY)"), (int)((timeint/-31104000)+0.5)];
        }else if (timeint < -2592000){
            return [NSString stringWithFormat:NSLocalizedString(@"OPENS_IN_MONTHS", @"Abre en (%dM)"), (int)((timeint/-2592000)+0.5)];
        }else if (timeint < -86400){
            return [NSString stringWithFormat:NSLocalizedString(@"OPENS_IN_DAYS", @"Abre en (%dd)"), (int)((timeint/-86400)+0.5)];
        }else if (timeint < -3600){
            return [NSString stringWithFormat:NSLocalizedString(@"OPENS_IN_HOURS", @"Abre en (%dh)"), (int)((timeint/-3600)+0.5)];
        }else if(timeint < -60){
            return [NSString stringWithFormat:NSLocalizedString(@"OPENS_IN_MINUTES", @"Abre en (%dm)"), (int)((timeint/-60)+0.5)];
        }else{
            return NSLocalizedString(@"OPEN", @"Abierto");
        }
    }else{// ya abrio
        timeint = timeintDue;
        if (timeint < -31104000){
            return [NSString stringWithFormat:NSLocalizedString(@"CLOSES_IN_YEARS", @"Cierra en (%dY)"), (int)((timeint/-31104000)+0.5)];
        }else if (timeint < -2592000){
            return [NSString stringWithFormat:NSLocalizedString(@"CLOSES_IN_MONTHS", @"Cierra en (%dM)"), (int)((timeint/-2592000)+0.5)];
        }else if (timeint < -86400){
            return [NSString stringWithFormat:NSLocalizedString(@"CLOSES_IN_DAYS", @"Cierra en (%dd)"), (int)((timeint/-86400)+0.5)];
        }else if (timeint < -3600){
            return [NSString stringWithFormat:NSLocalizedString(@"CLOSES_IN_HOURS", @"Cierra en (%dh)"), (int)((timeint/-3600)+0.5)];
        }else if(timeint < -60){
            return [NSString stringWithFormat:NSLocalizedString(@"CLOSES_IN_MINUTES", @"Cierra en (%dm)"), (int)((timeint/-60)+0.5)];
        }else if(timeint < 0){
            return [NSString stringWithFormat:NSLocalizedString(@"CLOSES_IN_SECONDS", @"Cierra en (%ds)"), (int)timeint];
        }else{
            return NSLocalizedString(@"CLOSED", @"Cerrado");
        }
    }
}

+ (NSString*)getArrivesIn:(NSTimeInterval)timeint{
    if(-timeint>0){// no ha llegado
        if (-timeint > 31104000){
            return [NSString stringWithFormat:NSLocalizedString(@"ARRIVES_IN_YEARS", @"Llega en (%dY)"), (int)((-timeint/31104000)+0.5)];
        }else if (-timeint > 2592000){
            return [NSString stringWithFormat:NSLocalizedString(@"ARRIVES_IN_MONTHS", @"Llega en (%dM)"), (int)((-timeint/2592000)+0.5)];
        }else if (-timeint > 86400){
            return [NSString stringWithFormat:NSLocalizedString(@"ARRIVES_IN_DAYS", @"Llega en (%dd)"), (int)((-timeint/86400)+0.5)];
        }else if (-timeint > 3600){
            return [NSString stringWithFormat:NSLocalizedString(@"ARRIVES_IN_HOURS", @"Llega en (%dh)"), (int)((-timeint/3600)+0.5)];
        }else if(-timeint > 60){
            return [NSString stringWithFormat:NSLocalizedString(@"ARRIVES_IN_MINUTES", @"Llega en (%dm)"), (int)((-timeint/60)+0.5)];
        }else if(-timeint > 0){
            return [NSString stringWithFormat:NSLocalizedString(@"ARRIVES_IN_SECONDS", @"Llega en (%dm)"), (int)((-timeint)+0.5)];
        }else{
            return NSLocalizedString(@"ARRIVED", @"Llego");
        }
    }else{
        return NSLocalizedString(@"ARRIVED", @"Llego");
    }
}



@end
