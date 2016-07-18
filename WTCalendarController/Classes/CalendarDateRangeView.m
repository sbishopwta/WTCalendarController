//
//  CalendarDateRangeView.m
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import "CalendarDateRangeView.h"
#import "CalendarDayCollectionViewCell.h"

@interface CalendarDateRangeView ()
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeightConstraint;
@end

@implementation CalendarDateRangeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
     {
         self.backgroundColor = [UIColor clearColor];
         NSBundle *bundle = [NSBundle bundleForClass:[CalendarDateRangeView class]];
        CalendarDateRangeView *checkInOutView = [[bundle loadNibNamed:@"CalendarDateRangeView"
                                                                       owner:self
                                                                     options:nil] firstObject];

        checkInOutView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:checkInOutView];

         NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:checkInOutView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:checkInOutView.superview                                                                       attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0.0];

         NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:checkInOutView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:checkInOutView.superview
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0];

         NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:checkInOutView
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:checkInOutView.superview
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:0.0];

         NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:checkInOutView
                                                                             attribute:NSLayoutAttributeTrailing
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:checkInOutView.superview
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1.0
                                                                              constant:0.0];

         [self addConstraints:@[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]];
         CGFloat height = 1 / [[UIScreen mainScreen] scale];
         self.topSeparatorHeightConstraint.constant = height;

        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.startDateLabel.font = [[CalendarDayCollectionViewCell appearance] dateNumberFont];
    self.endDateLabel.font = [[CalendarDayCollectionViewCell appearance] dateNumberFont];
    self.startDateHeaderLabel.textColor = [[CalendarDayCollectionViewCell appearance] dateNumberTextColor];
    self.endDateHeaderLabel.textColor = [[CalendarDayCollectionViewCell appearance] dateNumberTextColor];
}

- (void)setStartDate:(NSString *)startDateString
{
    self.startDateLabel.textColor = [[CalendarDayCollectionViewCell appearance] selectedDateBackgroundColor];
    if (startDateString) {
        self.startDateLabel.text = startDateString;
    }

    self.endDateLabel.text = NSLocalizedString(@"Select a Date", nil);
}

- (void)setEndDate:(NSString *)endDateString
{
    self.endDateLabel.textColor = [[CalendarDayCollectionViewCell appearance] selectedDateBackgroundColor];
    if (endDateString) {
        self.endDateLabel.text = endDateString;
    }
}

@end