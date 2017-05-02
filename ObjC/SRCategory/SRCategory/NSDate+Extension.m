//
//  NSDate+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (BOOL)isToday {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:self];
    NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
    return [dateString isEqualToString:currentDateString];
}

- (BOOL)isYesterday {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    NSString *dateString = [formatter stringFromDate:self];
    
    // 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
    
    NSDate *date = [formatter dateFromString:dateString];
    NSDate *currentDate = [formatter dateFromString:currentDateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:date toDate:currentDate options:0];
    return (components.year == 0) && (components.month == 0) && (components.day == 1);
}

- (BOOL)isThisYear {
    
    //NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    //NSDateComponents *currentComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    //return components == currentComponents.year;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
    return components.year == 0;
}

+ (NSString *)createdDateWithTimeInterval:(NSTimeInterval)timeInterval {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.timeZone = [NSTimeZone localTimeZone];
    //formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:(timeInterval)];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:createdDate toDate:now options:0];
    if ([createdDate isThisYear]) {
        if ([createdDate isToday]) {
            if (components.hour >= 1) {
                return [NSString stringWithFormat:@"%zd小时前", components.hour];
            } else if (components.minute >= 5){
                return [NSString stringWithFormat:@"%zd分钟前", components.minute];
            } else {
                return @"刚刚";
            }
        }
        if ([createdDate isYesterday]) {
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createdDate];
        }
        formatter.dateFormat = @"MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    }
}

+ (NSString *)weekdayFromDate:(NSDate *)date {
    
    NSArray *weekdays = @[[NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Beijing"]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return [weekdays objectAtIndex:dateComponents.weekday];
}

@end
