//
//  WTAppDelegate.m
//  WTCalendarController
//
//  Created by Steven Bishop on 07/18/2016.
//  Copyright (c) 2016 Steven Bishop. All rights reserved.
//

#import "WTAppDelegate.h"
#import "CalendarViewController.h"

@implementation WTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CalendarDayCollectionViewCell appearance] setSelectedDateBackgroundColor:[UIColor blueColor]];
    [[CalendarDayCollectionViewCell appearance] setDateNumberTextColor:[UIColor blackColor]];
    [[CalendarMonthHeaderView appearance] setMonthHeaderTextColor:[UIColor blackColor]];
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.barTintColor = [UIColor whiteColor];
    navigationBarAppearance.translucent = NO;

//    [[CalendarMonthHeaderView appearance] setMonthHeaderFont:[UIFont choicePrimaryBoldFont:[ChoiceTheme preferredSizeForSubhead2]]];
//    [[CalendarDayCollectionViewCell appearance] setDateNumberFont:[UIFont choicePrimaryFont:[ChoiceTheme preferredSizeForSubhead2]]];
    return YES;
}

@end
