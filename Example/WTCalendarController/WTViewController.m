//
//  WTViewController.m
//  WTCalendarController
//
//  Created by Steven Bishop on 07/18/2016.
//  Copyright (c) 2016 Steven Bishop. All rights reserved.
//

#import "WTViewController.h"
#import <WTCalendarController/CalendarViewController.h>
//#import <WTCalendarController/CalendarController.h>

@interface WTViewController () <CalendarDelegate>
@end

@implementation WTViewController

- (IBAction)presentCalendarTapped:(id)sender
{
    [UIBarButtonItem appearance].tintColor = [UIColor redColor];
    [[CalendarDayCollectionViewCell appearance] setSelectedDateBackgroundColor:[UIColor redColor]];

    CalendarViewController *calendarController = [CalendarViewController buildWithDelegate:self];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:2 toDate:[NSDate date] options:NSCalendarWrapComponents];
    calendarController.endDate = endDate;

    NSDate *selectedStartDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:NSCalendarMatchStrictly];
    NSDate *selectedEndDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:selectedStartDate options:NSCalendarMatchStrictly];
    calendarController.selectedStartDate = selectedStartDate;
    calendarController.selectedEndDate = selectedEndDate;

    calendarController.useStickyHeaders = YES;
    calendarController.shouldShowDoneButton = YES;
    calendarController.dateRangeShouldCoverEmptySpace = NO;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calendarController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }

    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)pushCalendarTapped:(id)sender
{
    [[UIBarButtonItem appearance] setTintColor:[UIColor blueColor]];
    [[CalendarDayCollectionViewCell appearance] setSelectedDateBackgroundColor:[UIColor blueColor]];

    CalendarViewController *calendarController = [CalendarViewController buildWithDelegate:self];
    calendarController.shouldShowDateRangeFooterView = NO;
    [self.navigationController pushViewController:calendarController animated:YES];
}


@end
