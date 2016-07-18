//
//  DateHelper.h
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
+ (NSString *)date_dayOfMonth:(NSDate *)date;
+ (NSString *)date_monthName:(NSDate *)date;
+ (NSString *)date_dayOfTheWeek:(NSDate *)date;
+ (NSString *)date_dayMonthAndYear:(NSDate *)date;


@end