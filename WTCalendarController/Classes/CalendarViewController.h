//
//  CalendarViewController.h
//  Copyright (c) 2016 WillowTree, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "CalendarDayCollectionViewCell.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDateRangeView.h"

@protocol CalendarDelegate <NSObject>

@optional

/***
 * Called when a user selects a date.
 */
- (void)didSelectDate:(NSDate *)date;

/***
 * Returns the selected start and end date when the calendar is dismissed.
 */
- (void)didSelectStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end


@interface CalendarViewController : UIViewController

+ (instancetype)buildWithDelegate:(id<CalendarDelegate>)delegate;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

/***
 * Defaults to beginning of the current month.
 */
@property (strong, nonatomic) NSDate *startDate;

/***
 * Defaults to 1 year after the start date.
 */
@property (strong, nonatomic) NSDate *endDate;

/***
 * Preselect a start date.
 */
@property (strong, nonatomic) NSDate *selectedStartDate;

/***
 * Preselect an end date.
 */
@property (strong, nonatomic) NSDate *selectedEndDate;

/***
 * Defaults to system size of 15.
 */
@property (strong, nonatomic) UIFont *daysOfTheWeekFont;

/***
 * Defaults to [UIColor blackColor].
 */
@property (strong, nonatomic) UIColor *daysOfTheWeekTextColor;

/***
 * Background color of the calendar collection view and it's superview. Defaults to [UIColor whiteColor].
 */
@property (strong, nonatomic) UIColor *calendarBackgroundColor;

/***
 * Defaults to NO.
 */
@property (nonatomic) BOOL useStickyHeaders NS_AVAILABLE_IOS(9_0);

/***
 * Shows the custom date range sticky footer view. Defaults to YES;
 */
@property (nonatomic) BOOL shouldShowDateRangeFooterView;

/***
 * Shows the done button as the top right bar button item. Defaults to YES.
 */
@property (nonatomic) BOOL shouldShowDoneButton;

/***
 * Whether date range selection should cover empty space. Defaults to YES.
 */
@property (nonatomic) BOOL dateRangeShouldCoverEmptySpace;

/***
 * Scrolls to the top of selectedStartDate's header. Defaults to YES.
 */
@property (nonatomic) BOOL shouldScrollToSelectedStartDate;

/***
 * Header text for the date range footer view's start date.
 */
@property (strong, nonatomic) NSString *startDateHeaderText;

/***
 * Header text for the date range footer view's end date.
 */
@property (strong, nonatomic) NSString *endDateHeaderText;

@end