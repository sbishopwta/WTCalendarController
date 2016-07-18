//
//  CalendarDayCollectionViewCell.m
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import "CalendarDayCollectionViewCell.h"
#import "DateHelper.h"

@interface CalendarDayCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *dateNumberLabel;
@property (strong, nonatomic) IBOutlet UIView *circleView;
@property (strong, nonatomic) IBOutlet UIView *leftHighlightView;
@property (strong, nonatomic) IBOutlet UIView *rightHighlightView;
@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) NSString *accessibilityString;
@end

@implementation CalendarDayCollectionViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateNumberLabel.textColor = self.dateNumberTextColor;
    self.grayView.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circleView.layer.cornerRadius = CGRectGetHeight(self.circleView.frame) / 2;
    CGFloat height = 1 / [[UIScreen mainScreen] scale];
    [self.grayView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), height)];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self applyUnselectedBackground];
    [self setUserInteractionEnabled:YES];
    self.dateNumberLabel.textColor = self.dateNumberTextColor;
    self.dateNumberLabel.text = nil;
    self.dateNumberLabel.alpha = 1.0;
    self.circleView.alpha = 1.0;
    self.leftHighlightView.backgroundColor = [UIColor clearColor];
    self.rightHighlightView.backgroundColor = [UIColor clearColor];
    self.grayView.backgroundColor = [UIColor clearColor];
    self.hasCheckOutDateSelected = NO;
    self.hasCheckInDateSelected = NO;
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"";
}

#pragma mark - Public Methods

- (void)configureWithDayOfWeek:(NSString *)dayOfWeek accessibilityString:(NSString *)accessibilityString
{
    self.accessibilityString = accessibilityString;
    self.isAccessibilityElement = YES; 
    self.dateNumberLabel.text = dayOfWeek;
    if (! [dayOfWeek isEqualToString:@""]) {
        self.grayView.backgroundColor = [UIColor lightGrayColor];
    }
    [self configureAccessibility];
}

- (void)applyCurrentDateBackground
{
    self.circleView.layer.backgroundColor = [self.currentDateBackgroundColor CGColor];
    self.circleView.alpha = 1.0;
}

- (BOOL)isASelectedDate
{
    return self.circleView.layer.backgroundColor == [self.selectedDateBackgroundColor CGColor];
}

- (void)applySelectedDateBackground
{
    self.circleView.layer.backgroundColor = [self.selectedDateBackgroundColor CGColor];
    self.circleView.alpha = 1.0;
    self.dateNumberLabel.textColor = self.selectedDateTextColor;

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.hasCheckInDateSelected)
        {
            self.rightHighlightView.backgroundColor = self.selectedDateBackgroundColor;
        }
        if (self.hasCheckOutDateSelected)
        {
            self.leftHighlightView.backgroundColor = self.selectedDateBackgroundColor;
        }
    } completion:nil];

    [self configureAccessibility];
}

- (void)applyInbetweenDateBackground:(BOOL)dateRangeShouldCoverEmptySpace
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dateNumberLabel.textColor = self.dateNumberTextColor;
        self.circleView.alpha = 0.0;

        if (dateRangeShouldCoverEmptySpace == NO && [self.dateNumberLabel.text isEqualToString:@""])
        {
            self.leftHighlightView.backgroundColor = [UIColor clearColor];
            self.rightHighlightView.backgroundColor = [UIColor clearColor];
        }
        else
        {
            self.leftHighlightView.backgroundColor = self.selectedDateBackgroundColor;
            self.rightHighlightView.backgroundColor = self.selectedDateBackgroundColor;
        }

    } completion:nil];
}

- (void)applyPastDateState
{
    [self setUserInteractionEnabled:NO];
    self.isAccessibilityElement = NO;
    self.dateNumberLabel.alpha = 0.3;
}

- (void)applyUnselectedBackground
{
    self.dateNumberLabel.textColor = self.dateNumberTextColor;
    self.circleView.layer.backgroundColor = [[UIColor clearColor] CGColor];
}

#pragma mark - Accessibility

- (void)configureAccessibility
{
    if ([self.accessibilityString isEqualToString:@""])
    {
        self.isAccessibilityElement = NO;
        return;
    }

    NSString *isSelectedString = [self isASelectedDate] ? @"Selected" : @"Unselected";
    NSString *accessibilityString = [NSString stringWithFormat:@"%@, %@", self.accessibilityString, isSelectedString];

    NSString *hintString = @"Double tap to select";
    self.accessibilityLabel = accessibilityString;
    self.accessibilityHint = hintString;
    self.accessibilityIdentifier = self.accessibilityString;
}

#pragma mark - Appearance Customization

- (UIColor *)dateNumberTextColor
{
    if (_dateNumberTextColor == nil)
    {
        _dateNumberTextColor = [[[self class] appearance] dateNumberTextColor];
    }

    if (_dateNumberTextColor != nil)
    {
        return _dateNumberTextColor;
    }

    return [UIColor blackColor];
}

- (UIColor *)selectedDateTextColor
{
    if (_selectedDateTextColor == nil)
    {
        _selectedDateTextColor = [[[self class] appearance] selectedDateTextColor];
    }

    if (_selectedDateTextColor != nil)
    {
        return _selectedDateTextColor;
    }

    return [UIColor whiteColor];
}

- (UIColor *)selectedDateBackgroundColor
{
    if (_selectedDateBackgroundColor == nil)
    {
        _selectedDateBackgroundColor = [[[self class] appearance] selectedDateBackgroundColor];
    }

    if (_selectedDateBackgroundColor != nil)
    {
        return _selectedDateBackgroundColor;
    }

    return [UIColor redColor];
}

- (UIColor *)currentDateBackgroundColor
{
    if (_currentDateBackgroundColor == nil)
    {
        _currentDateBackgroundColor = [[[self class] appearance] currentDateBackgroundColor];
    }

    if (_currentDateBackgroundColor != nil)
    {
        return _currentDateBackgroundColor;
    }

    return [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
}

#pragma mark - Font Customization

- (UIFont *)dateNumberFont
{
    if (_dateNumberFont == nil)
    {
        _dateNumberFont = [[[self class] appearance] dateNumberFont];
    }

    if (_dateNumberFont != nil)
    {
        return _dateNumberFont;
    }

    return [UIFont systemFontOfSize:17.0];
}


@end