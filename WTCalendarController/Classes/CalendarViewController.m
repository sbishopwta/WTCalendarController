//
//  CalendarViewController.m
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright (c) 2016 WillowTree. All rights reserved.
//

#import "CalendarViewController.h"
#import "DateHelper.h"

@interface CalendarDate : NSObject
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL isBeforeToday;
@end

@implementation CalendarDate
@end

@interface CalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (strong, nonatomic) IBOutlet CalendarDateRangeView *calendarDateRangeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dateRangeViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *daysOfTheWeekView;
@property (strong, nonatomic) IBOutlet UILabel *sundayLabel;
@property (strong, nonatomic) IBOutlet UILabel *mondayLabel;
@property (strong, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *fridayLabel;
@property (strong, nonatomic) IBOutlet UILabel *saturdayLabel;

@property (strong, nonatomic) NSArray <NSArray <NSDate *> *> *allDates;
@property (strong, nonatomic) NSMutableArray <NSArray <NSString *> *> *allDateStrings;
@property (strong, nonatomic) NSMutableArray <NSArray <NSString *> *> *allDateAccessibilityStrings;
@property (strong, nonatomic) NSArray <NSString *> *allMonthNames;

@property (strong, nonatomic) NSIndexPath *checkInIndexPath;
@property (strong, nonatomic) NSIndexPath *checkOutIndexPath;

@property (strong, nonatomic) NSDate *fillerDate;
@property (strong, nonatomic) NSDate *checkInDate;
@property (strong, nonatomic) NSDate *checkOutDate;
@property (strong, nonatomic) NSDateFormatter *checkInDateFormatter;

@property (weak, nonatomic) id <CalendarDelegate> delegate;

@end

@implementation CalendarViewController

static NSString *const CalendarDayCellReuseIdentifier = @"CalendarDayCell";
static NSString *const CalendarMonthViewReuseIdentifier = @"CalendarMonthView";
const NSInteger numberOfColumns = 7;

+ (instancetype)buildWithDelegate:(id<CalendarDelegate>)delegate
{
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"WTCalendarController" withExtension:@"bundle"];
    NSBundle *bundle = bundleUrl == nil ? [NSBundle mainBundle] : [NSBundle bundleWithURL:bundleUrl];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Calendar" bundle:bundle];
    CalendarViewController *calendarController = [storyboard instantiateInitialViewController];
    calendarController.delegate = delegate;
    calendarController.shouldShowDoneButton = YES;
    calendarController.shouldShowDateRangeFooterView = YES;
    calendarController.dateRangeShouldCoverEmptySpace = YES;
    calendarController.shouldScrollToSelectedStartDate = YES;
    return calendarController;
}

#pragma mark - View Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Select Dates", @"");

    self.checkInDateFormatter = [NSDateFormatter new];
    [self.checkInDateFormatter setDateStyle:NSDateFormatterMediumStyle];

    [self setupDataSource];
    [self setup];
    [self setUpBarButtonItems];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.shouldScrollToSelectedStartDate && self.selectedStartDate && self.checkInIndexPath.section > 0)
    {
        //Scroll to the top of the selectedStartDate's header
        NSIndexPath *beginningOfSectionIndexPath = [NSIndexPath indexPathForItem:0
                                                                       inSection:self.checkInIndexPath.section];
        [self.collectionView scrollToItemAtIndexPath:beginningOfSectionIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:YES];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.collectionView.contentOffset = CGPointMake(0, -self.flowLayout.headerReferenceSize.height);
        } completion:nil];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (! self.shouldShowDateRangeFooterView)
    {
        self.dateRangeViewHeightConstraint.constant = 0;
    }
    
    [self configureCellSize];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.shadowImage = nil;
}

#pragma mark - Private

- (void)setUpBarButtonItems
{
    if (self.shouldShowDoneButton)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }

    if (self.presentingViewController)
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void)cancelButtonTapped
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(didSelectStartDate:andEndDate:)])
    {
        [self.delegate didSelectStartDate:self.checkInDate andEndDate:self.checkOutDate];
    }

    if (self.presentingViewController)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)setup
{
    self.daysOfTheWeekView.backgroundColor = [UINavigationBar appearance].barTintColor;
    self.view.backgroundColor = self.calendarBackgroundColor;
    self.collectionView.backgroundColor = self.calendarBackgroundColor;
    [self.calendarDateRangeView setStartDate:[self.checkInDateFormatter stringFromDate:self.checkInDate]];
    [self.calendarDateRangeView setEndDate:[self.checkInDateFormatter stringFromDate:self.checkOutDate]];

    if (self.daysOfTheWeekFont)
    {
        self.sundayLabel.font = self.daysOfTheWeekFont;
        self.mondayLabel.font = self.daysOfTheWeekFont;
        self.tuesdayLabel.font = self.daysOfTheWeekFont;
        self.wednesdayLabel.font = self.daysOfTheWeekFont;
        self.thursdayLabel.font = self.daysOfTheWeekFont;
        self.fridayLabel.font = self.daysOfTheWeekFont;
        self.saturdayLabel.font = self.daysOfTheWeekFont;
        self.calendarDateRangeView.startDateHeaderLabel.font = self.daysOfTheWeekFont;
        self.calendarDateRangeView.endDateHeaderLabel.font = self.daysOfTheWeekFont;
    }

    if (self.daysOfTheWeekTextColor)
    {
        self.sundayLabel.textColor = self.daysOfTheWeekTextColor;
        self.mondayLabel.textColor = self.daysOfTheWeekTextColor;
        self.tuesdayLabel.textColor = self.daysOfTheWeekTextColor;
        self.wednesdayLabel.textColor = self.daysOfTheWeekTextColor;
        self.thursdayLabel.textColor = self.daysOfTheWeekTextColor;
        self.fridayLabel.textColor = self.daysOfTheWeekTextColor;
        self.saturdayLabel.textColor = self.daysOfTheWeekTextColor;
        self.calendarDateRangeView.startDateHeaderLabel.textColor = self.daysOfTheWeekTextColor;
        self.calendarDateRangeView.endDateHeaderLabel.textColor = self.daysOfTheWeekTextColor;
    }

    if (self.startDateHeaderText)
    {
        self.calendarDateRangeView.startDateHeaderLabel.text = self.startDateHeaderText;
    }

    if (self.endDateHeaderText)
    {
        self.calendarDateRangeView.endDateHeaderLabel.text = self.endDateHeaderText;
    }

    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    if (navigationBarAppearance.barTintColor)
    {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        UIImage *coloredImage = [self imageWithColor:navigationBarAppearance.barTintColor];
        [navigationBar setBackgroundImage:coloredImage
                           forBarPosition:UIBarPositionAny
                               barMetrics:UIBarMetricsDefault];
        //hides 1px view under navigation bar
        [navigationBar setShadowImage:coloredImage];
    }

    self.flowLayout.minimumInteritemSpacing = 0.0f;
    self.flowLayout.minimumLineSpacing = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        self.flowLayout.sectionHeadersPinToVisibleBounds = self.useStickyHeaders;
    }

    self.collectionView.allowsMultipleSelection = YES;

    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"WTCalendarController" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CalendarDayCollectionViewCell class]) bundle:bundle] forCellWithReuseIdentifier:CalendarDayCellReuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CalendarMonthHeaderView class]) bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarMonthViewReuseIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange
{
    [self configureCellSize];
    [self.flowLayout invalidateLayout];
}

- (void)configureCellSize
{
    CGSize screenSize = self.view.frame.size;

    double cellWidth = (screenSize.width / numberOfColumns);
    double padding = screenSize.width - cellWidth * numberOfColumns;

    CGSize cellSize = CGSizeMake(floor(screenSize.width/numberOfColumns) + padding,
                                 floor(screenSize.width/numberOfColumns) + padding);

    double constraintPadding = screenSize.width - (cellSize.width * 7);

    self.leadingConstraint.constant = constraintPadding/2;
    self.trailingConstraint.constant = constraintPadding/2;

    [self.flowLayout setItemSize:cellSize];
}

#pragma mark - CollectionView Delegate & Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCollectionViewCell *calendarDayCell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarDayCellReuseIdentifier forIndexPath:indexPath];

    NSString *dateString = self.allDateStrings[indexPath.section][indexPath.item];
    NSString *accessibilityString = self.allDateAccessibilityStrings[indexPath.section][indexPath.item];
    [calendarDayCell configureWithDayOfWeek:dateString accessibilityString:accessibilityString];

    CalendarDate *calendarDate = (CalendarDate *)self.allDates[indexPath.section][indexPath.item];

    if (calendarDate.isBeforeToday)
    {
        [calendarDayCell applyPastDateState];
    }
    else if (calendarDate.isToday)
    {
        [calendarDayCell applyCurrentDateBackground];
    }

    NSComparisonResult checkInResult = [indexPath compare:self.checkInIndexPath];
    NSComparisonResult checkOutResult = [indexPath compare:self.checkOutIndexPath];

    if (checkInResult == NSOrderedSame || checkOutResult == NSOrderedSame)
    {
        [calendarDayCell applySelectedDateBackground];
    }

    return calendarDayCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.checkInIndexPath && self.checkOutIndexPath)
    {
        NSComparisonResult beforeResult = [indexPath compare:self.checkInIndexPath];
        NSComparisonResult afterResult = [indexPath compare:self.checkOutIndexPath];

        CalendarDayCollectionViewCell *calendarDayCell = (CalendarDayCollectionViewCell *)cell;

        //if indexPath is greater than or equal to before AND less than or equal to after, it should appear selected.
        if (beforeResult == NSOrderedDescending && afterResult == NSOrderedAscending)
        {
            [calendarDayCell applyInbetweenDateBackground:self.dateRangeShouldCoverEmptySpace];
        }

        if (beforeResult == NSOrderedSame || afterResult == NSOrderedSame)
        {
            calendarDayCell.hasCheckInDateSelected = (beforeResult == NSOrderedSame) ? YES : NO;
            calendarDayCell.hasCheckOutDateSelected = (afterResult == NSOrderedSame) ? YES : NO;
            [calendarDayCell applySelectedDateBackground];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CalendarMonthHeaderView *calendarMonthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarMonthViewReuseIdentifier forIndexPath:indexPath];

    [calendarMonthHeader configureWithTitle:[self getSectionTitleForSection:indexPath.section]];
    return calendarMonthHeader;
}

-  (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.allDates[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.allDates.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//TODO: Don't call reloadData every time checkIn and checkOut date changes. Also, why is indexPathForVisibleItems taking longer to render than reloadData?
// [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];

    CalendarDate *calendarDate = (CalendarDate *)self.allDates[indexPath.section][indexPath.row];
    NSDate *selectedDate = calendarDate.date;
    if (self.checkInDate && self.checkInDate == selectedDate) { return; }

    NSComparisonResult result = [selectedDate compare:self.fillerDate];
    if (result == NSOrderedSame)
    {
        return;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didSelectDate:)])
        {
            [self.delegate didSelectDate:selectedDate];
        }

        if (self.checkInDate)
        {
            //if date selected is before or on checkInDate, do nothing
            //otherwise, set the checkOutDate to be the selected date
            NSComparisonResult result = [indexPath compare:self.checkInIndexPath];

            if (self.checkOutDate)
            {
                self.checkInDate = selectedDate;
                self.checkOutDate = nil;
                self.checkInIndexPath = indexPath;
                self.checkOutIndexPath = nil;
                [self.calendarDateRangeView setStartDate:[self.checkInDateFormatter stringFromDate:selectedDate]];
                [self.collectionView reloadData];
                return;
            }

            if (result == NSOrderedDescending || result == NSOrderedSame)
            {
                self.checkOutDate = selectedDate;
                self.checkOutIndexPath = indexPath;
                [self.calendarDateRangeView setEndDate:[self.checkInDateFormatter stringFromDate:selectedDate]];
            }
            else if ((result == NSOrderedAscending || result == NSOrderedSame) && self.checkInDate)
            {
                self.checkInDate = selectedDate;
                self.checkOutDate = nil;
                self.checkInIndexPath = indexPath;
                self.checkOutIndexPath = nil;
                [self.calendarDateRangeView setStartDate:[self.checkInDateFormatter stringFromDate:selectedDate]];
            }
            [self.collectionView reloadData];
            return;
        }

        if (!self.checkInDate)
        {
            self.checkInDate = selectedDate;
            self.checkInIndexPath = indexPath;
            [self.calendarDateRangeView setStartDate:[self.checkInDateFormatter stringFromDate:selectedDate]];
        }
        else if (!self.checkOutDate)
        {
            self.checkOutDate = selectedDate;
            self.checkOutIndexPath = indexPath;
        }

        [self.collectionView reloadData];
    }
}

#pragma mark - Helpers

- (NSString *)getSectionTitleForSection:(NSInteger)section
{
    return self.allMonthNames[section];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Appearance Customization

- (UIColor *)calendarBackgroundColor
{
    if(_calendarBackgroundColor == nil)
    {
        _calendarBackgroundColor = [UIColor whiteColor];
    }

    return _calendarBackgroundColor;
}

#pragma mark - Date Datasource Generation

- (void)setupDataSource
{
    self.fillerDate = [NSDate distantPast];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    if (! self.startDate)
    {
        self.startDate = [calendar startOfDayForDate:[NSDate date]];
    }

    NSDateComponents *beginningOfMonthComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay fromDate:self.startDate];
    beginningOfMonthComponents.day = 1;

    //beginning date
    NSDate *firstDayOfMonth = [calendar dateFromComponents:beginningOfMonthComponents];

    if (! self.endDate)
    {
        NSDate *oneYearFromStartDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:firstDayOfMonth options:NSCalendarWrapComponents];
        self.endDate = oneYearFromStartDate;
    }

    NSDateComponents *differenceInMonthsComponents = [calendar components:NSCalendarUnitMonth fromDate:firstDayOfMonth toDate:self.endDate options:0];

    NSMutableArray *allDates = [[NSMutableArray alloc] initWithCapacity:differenceInMonthsComponents.month];
    NSMutableArray *allMonthNames = [[NSMutableArray alloc] initWithCapacity:differenceInMonthsComponents.month];
    self.allDateAccessibilityStrings = [[NSMutableArray alloc] initWithCapacity:differenceInMonthsComponents.month];
    self.allDateStrings = [[NSMutableArray alloc] initWithCapacity:differenceInMonthsComponents.month];

    for (int i = 0; i < differenceInMonthsComponents.month; i++)
    {
        NSDate *nextMonthStartDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:i toDate:firstDayOfMonth options:NSCalendarMatchStrictly];
        [allMonthNames addObject:[DateHelper date_monthName:nextMonthStartDate]];

        NSArray *nextMonthDateArray = [self augmentedAmountOfDaysInMonth:nextMonthStartDate calendar:calendar];
        [allDates addObject:nextMonthDateArray];
    }

    self.allMonthNames = allMonthNames;
    self.allDates = allDates;
}

- (NSArray *)augmentedAmountOfDaysInMonth:(NSDate *)startDate calendar:(NSCalendar *)calendar
{
    NSRange numberOfDaysRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:startDate];
    NSMutableArray *datesInMonth = [[NSMutableArray alloc] initWithCapacity:numberOfDaysRange.length];
    NSMutableArray *daysOfWeek = [[NSMutableArray alloc] initWithCapacity:numberOfDaysRange.length];
    NSMutableArray *accessibilityStrings = [[NSMutableArray alloc] initWithCapacity:numberOfDaysRange.length];
    NSInteger numberOfCellsBeforeStartOfMonth = [self numberOfCellsBeforeStartOfMonth:startDate];

    for (int i = 0; i < numberOfCellsBeforeStartOfMonth; i++)
    {
        CalendarDate *calendarDate = [CalendarDate new];
        calendarDate.date = self.fillerDate;
        [daysOfWeek addObject:@""];
        [accessibilityStrings addObject:@""];
        [datesInMonth addObject:calendarDate];
    }

    for (int i = 0; i < numberOfDaysRange.length; i++)
    {
        CalendarDate *calendarDate = [CalendarDate new];
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:startDate options:NSCalendarWrapComponents];
        BOOL isDateToday = [calendar isDateInToday:date];
        calendarDate.isToday = isDateToday;

        if (self.selectedStartDate)
        {
            BOOL isDateSelectedStartDate = [calendar isDate:date inSameDayAsDate:self.selectedStartDate];
            if (isDateSelectedStartDate)
            {
                self.checkInDate = date;

                NSDateComponents *checkInComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.checkInDate];
                NSDateComponents *startDateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.startDate];
                BOOL hasSameMonth = startDateComponents.month == checkInComponents.month;
                BOOL hasSameYear = startDateComponents.year == checkInComponents.year;
                BOOL isCheckInDateAndStartDateInSameMonth = hasSameYear && hasSameMonth;
                NSInteger numberOfSectionsToAdd;

                if (isCheckInDateAndStartDateInSameMonth)
                {
                    numberOfSectionsToAdd = 0;
                }
                else
                {
                    NSDateComponents *beginningOfMonthComponents = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth)
                                                                               fromDate:self.startDate];

                    beginningOfMonthComponents.day = 1;
                    NSDate *firstDayOfTheMonth = [calendar dateFromComponents:beginningOfMonthComponents];


                    NSDateComponents *differenceInMonthsComponents = [calendar components:NSCalendarUnitMonth
                                                                                 fromDate:firstDayOfTheMonth
                                                                                   toDate:self.checkInDate
                                                                                  options:0];
                    numberOfSectionsToAdd = differenceInMonthsComponents.month;
                }

                self.checkInIndexPath = [NSIndexPath indexPathForItem:numberOfCellsBeforeStartOfMonth + i inSection:numberOfSectionsToAdd];
            }
        }

        if (self.selectedEndDate)
        {
            BOOL isDateSelectedEndDate = [calendar isDate:date inSameDayAsDate:self.selectedEndDate];
            if (isDateSelectedEndDate)
            {
                self.checkOutDate = date;
                NSInteger numberOfSectionsToAdd;

                NSDateComponents *checkInComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.checkInDate];
                NSDateComponents *checkOutComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.checkOutDate];
                BOOL hasSameMonth = checkInComponents.month == checkOutComponents.month;
                BOOL hasSameYear = checkInComponents.year == checkOutComponents.year;
                BOOL isSelectedStartAndEndDateInSameMonth = hasSameYear && hasSameMonth;

                if (isSelectedStartAndEndDateInSameMonth)
                {
                    numberOfSectionsToAdd = 0;
                }
                else
                {
                    NSDateComponents *differenceInMonthsComponents = [calendar components:NSCalendarUnitMonth
                                                                                 fromDate:self.selectedStartDate
                                                                                   toDate:self.selectedEndDate
                                                                                  options:0];
                    numberOfSectionsToAdd = differenceInMonthsComponents.month == 0 ? 1 : differenceInMonthsComponents.month;
                }

                self.checkOutIndexPath = [NSIndexPath indexPathForItem:numberOfCellsBeforeStartOfMonth + i inSection:self.checkInIndexPath.section + numberOfSectionsToAdd];
            }
        }

        calendarDate.date = date;
        NSComparisonResult result = [calendar compareDate:date toDate:[NSDate date] toUnitGranularity:NSCalendarUnitDay];

        if (result == NSOrderedAscending) { calendarDate.isBeforeToday = YES; }
        [daysOfWeek addObject:[DateHelper date_dayOfMonth:calendarDate.date]];
        [accessibilityStrings addObject:[DateHelper date_dayMonthAndYear:calendarDate.date]];
        [datesInMonth addObject:calendarDate];
    }

    //7 days in a week, so 7 columns - the goal here is to make sure we have a number divisible by 7 so our rows are even
    if (datesInMonth.count % numberOfColumns)
    {
        NSInteger numberOfCellsAfterEndOfMonth = numberOfColumns - datesInMonth.count % numberOfColumns;

        for (int i = 0; i < numberOfCellsAfterEndOfMonth; i++)
        {
            CalendarDate *calendarDate = [CalendarDate new];
            calendarDate.date = self.fillerDate;
            [daysOfWeek addObject:@""];
            [accessibilityStrings addObject:@""];
            [datesInMonth addObject:calendarDate];
        }
    }
    
    [self.allDateAccessibilityStrings addObject:accessibilityStrings];
    [self.allDateStrings addObject:daysOfWeek];
    return datesInMonth;
}

- (NSInteger)numberOfCellsBeforeStartOfMonth:(NSDate *)startDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSArray *weekDaySymbols = [calendar weekdaySymbols];

    NSString *dateString = [[DateHelper date_dayOfTheWeek:startDate] capitalizedString];

    for (int i = 0; i < weekDaySymbols.count; i++)
    {
        if ([dateString isEqualToString:weekDaySymbols[i]])
        {
            return i;
        }
    }
    
    return 0;
}

@end