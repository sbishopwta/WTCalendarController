//
//  DateHelper.m
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString *)date_dayOfMonth:(NSDate *)date
{
    static NSDateFormatter* formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"d";
    });

    return [formatter stringFromDate:date];
}

+ (NSString *)date_monthName:(NSDate *)date
{
    static NSDateFormatter* formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMMM yyyy";
    });

    return [formatter stringFromDate:date];
}

+ (NSString *)date_dayOfTheWeek:(NSDate *)date
{
    static NSDateFormatter* formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE";
    });

    return [formatter stringFromDate:date];
}

+ (NSString *)date_dayMonthAndYear:(NSDate *)date
{
    static NSDateFormatter* formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE d MMMM yyyy";
    });

    return [formatter stringFromDate:date];
}

@end