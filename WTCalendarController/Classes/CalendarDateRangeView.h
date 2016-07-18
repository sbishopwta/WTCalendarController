//
//  CalendarDateRangeView.h
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CalendarDateRangeView : UIView

@property (strong, nonatomic) IBOutlet UILabel *startDateHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateHeaderLabel;

- (void)setStartDate:(NSString *)startDateString;
- (void)setEndDate:(NSString *)endDateString;

//hello this is a test

@end
