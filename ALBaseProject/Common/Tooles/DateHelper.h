//
//  DateHelper.h
//  kuxing
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSString*)postTimeOfInterval:(double)interval;
+ (NSString*)yearMonthDayTimeOfInterval:(double)interval;
+ (NSInteger)ageOfBirthTimeInterval:(double)interval;

+ (NSString*)messageTimeOfInterval:(double)interval;
+ (NSString*)yearMonthDayOfInterval:(double)interval;
+ (double)timeFromYearMonthDayString:(NSString*)dateString;

@end
