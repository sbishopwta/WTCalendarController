//
//  CalendarMonthHeaderView.m
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import "CalendarMonthHeaderView.h"

@interface CalendarMonthHeaderView ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation CalendarMonthHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = self.monthHeaderBackgroundColor;
    self.titleLabel.backgroundColor = self.monthHeaderBackgroundColor;
    self.titleLabel.font = self.monthHeaderFont;
}

- (void)configureWithTitle:(NSString *)titleText
{
    self.titleLabel.text = titleText;
    self.titleLabel.textColor = self.monthHeaderTextColor;
    self.accessibilityIdentifier = titleText;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.text = nil;
}

#pragma mark - Appearance Customization

- (UIColor *)monthHeaderTextColor
{
    if(_monthHeaderTextColor == nil) {
        _monthHeaderTextColor = [[[self class] appearance] monthHeaderTextColor];
    }

    if(_monthHeaderTextColor != nil) {
        return _monthHeaderTextColor;
    }

    return [UIColor blackColor];
}

- (UIColor *)monthHeaderBackgroundColor
{
    if(_monthHeaderBackgroundColor == nil) {
        _monthHeaderBackgroundColor = [[[self class] appearance] monthHeaderBackgroundColor];
    }

    if(_monthHeaderBackgroundColor != nil) {
        return _monthHeaderBackgroundColor;
    }

    return [UIColor whiteColor];
}

#pragma mark - Font Customization

- (UIFont *)monthHeaderFont
{
    if (_monthHeaderFont == nil)
    {
        _monthHeaderFont = [[[self class] appearance] monthHeaderFont];
    }

    if (_monthHeaderFont != nil)
    {
        return _monthHeaderFont;
    }

    return [UIFont systemFontOfSize:17.0];
}

@end