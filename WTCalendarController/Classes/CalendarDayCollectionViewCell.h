//
//  CalendarDayCollectionViewCell.h
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CalendarDayCollectionViewCell : UICollectionViewCell

- (void)configureWithDayOfWeek:(NSString *)dayOfWeek accessibilityString:(NSString *)accessibilityString;
- (void)applyInbetweenDateBackground:(BOOL)dateRangeShouldCoverEmptySpace;
- (void)applySelectedDateBackground;
- (void)applyCurrentDateBackground;
- (void)applyPastDateState;

@property (nonatomic) BOOL hasCheckInDateSelected;
@property (nonatomic) BOOL hasCheckOutDateSelected;

@property (strong, nonatomic) UIFont *dateNumberFont UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *dateNumberTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *selectedDateTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *selectedDateBackgroundColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *currentDateBackgroundColor UI_APPEARANCE_SELECTOR;
@end