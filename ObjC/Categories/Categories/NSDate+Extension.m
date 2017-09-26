//
//  NSDate+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDate *)currentDateUTC {
    NSInteger timeIntervalForCurrentDate = [[NSDate date] timeIntervalSince1970];
    NSInteger secondsFromGMT = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSInteger timeIntervalForCurrentDateTrue = timeIntervalForCurrentDate - secondsFromGMT;
    return [NSDate dateWithTimeIntervalSince1970:timeIntervalForCurrentDateTrue];
}

- (BOOL)isToday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfDateString = [formatter stringFromDate:self];
    NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
    return [selfDateString isEqualToString:currentDateString];
}

- (BOOL)isYesterday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfDateString = [formatter stringFromDate:self];
    NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
    NSDate *selfDate = [formatter dateFromString:selfDateString];
    NSDate *currentDate = [formatter dateFromString:currentDateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:selfDate toDate:currentDate options:0];
    return (components.year == 0) && (components.month == 0) && (components.day == 1);
}

- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *components = [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
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

+ (NSString *)weekdayOfDate:(NSDate *)date {
    NSArray *weekdays = @[[NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Beijing"]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return [weekdays objectAtIndex:dateComponents.weekday];
}

+ (NSInteger)daysIntervalFromCurrentTime:(NSString *)destTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.0";
    NSDate *destTimeDate = [dateFormatter dateFromString:destTimeString];
    
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *components = [calendar components:unit fromDate:currentDate toDate:destTimeDate options:0];
    NSLog(@"daysIntervalFromCurrentTime components: %@", components);
    return components.day;
}

@end
