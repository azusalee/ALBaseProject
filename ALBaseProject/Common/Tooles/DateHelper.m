//
//  DateHelper.m
//  kuxing
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper


static NSDateFormatter *_timeFormatter;
static NSDateFormatter *_monthDayFormatter;
static NSDateFormatter *_yearMonthDayFormatter;
static NSDateFormatter *_yearMonthDayTimeFormatter;

+ (void)initialize
{
    [super initialize];
    
    
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:@"H:mm"];
    
    _monthDayFormatter = [[NSDateFormatter alloc] init];
    [_monthDayFormatter setDateFormat:@"MM.dd"];
    
    _yearMonthDayFormatter = [[NSDateFormatter alloc] init];
    [_yearMonthDayFormatter setDateFormat:@"YYYY-MM-dd"];
    
    _yearMonthDayTimeFormatter = [[NSDateFormatter alloc] init];
    [_yearMonthDayTimeFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
}


+ (NSDate*)beginningOfToday
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    [components setHour:-components.hour];
    [components setMinute:-components.minute];
    [components setSecond:-components.second];
    NSDate *today = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    return today;
}

+ (NSString*)weakdayFromDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    
    switch (dateComponents.weekday) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return nil;
            break;
    }
}


+ (NSString*)postTimeOfInterval:(double)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/ServiceTimeToLocalTimeRate];
    NSTimeInterval intervalSinceNow = [[NSDate date] timeIntervalSinceDate:date];
    
    if (intervalSinceNow < 60)
    {
        return @"刚刚";
    }
    else if (intervalSinceNow < 3600)
    {
        return [NSString stringWithFormat:@"%d分钟前", (int)(intervalSinceNow / 60)];
    }
    else if (intervalSinceNow < 86400)
    {
        return [NSString stringWithFormat:@"%d小时前", (int)(intervalSinceNow / 3600)];
    }
    else
    {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date];
        NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear  fromDate:[NSDate date]];
        
        if ([dateComponents year] == [nowComponents year]) {
            return [_monthDayFormatter stringFromDate:date];
        }
        else
        {
            return [_yearMonthDayFormatter stringFromDate:date];
        }
    }
}

+ (NSString*)yearMonthDayTimeOfInterval:(double)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/ServiceTimeToLocalTimeRate];
    return [_yearMonthDayTimeFormatter stringFromDate:date];
}
+ (NSString*)yearMonthDayOfInterval:(double)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/ServiceTimeToLocalTimeRate];
    return [_yearMonthDayFormatter stringFromDate:date];
}


+ (NSInteger)ageOfBirthTimeInterval:(double)interval
{
    
    NSDate *dateOfBirth = [NSDate dateWithTimeIntervalSince1970:interval/ServiceTimeToLocalTimeRate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        
    } else {
        
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}


+ (NSString*)messageTimeOfInterval:(double)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSTimeInterval intervalSince1970 = [date timeIntervalSince1970];
    NSTimeInterval today = [[self beginningOfToday] timeIntervalSince1970];
    
    if (intervalSince1970 > today)
    {
        return [NSString stringWithFormat:@"%@", [_timeFormatter stringFromDate:date]];
    }
    else if (intervalSince1970 > today - 86400)
    {
        return [NSString stringWithFormat:@"%@ %@", @"昨天", [_timeFormatter stringFromDate:date]];
    }
    else if (intervalSince1970 > today - 86400 * 3)
    {
        return [NSString stringWithFormat:@"%@ %@", [self weakdayFromDate:date], [_timeFormatter stringFromDate:date]];
    }
    else
    {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date];
        NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear  fromDate:[NSDate date]];
        
        if ([dateComponents year] == [nowComponents year]) {
            return [_monthDayFormatter stringFromDate:date];
        }
        else
            return [_yearMonthDayTimeFormatter stringFromDate:date];
    }
}

+ (double)timeFromYearMonthDayString:(NSString *)dateString{
    return [_yearMonthDayFormatter dateFromString:dateString].timeIntervalSince1970;
}

@end
