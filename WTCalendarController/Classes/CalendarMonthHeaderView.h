//
//  CalendarMonthReusableView.h
//  WillowTree
//
//  Created by Steven Bishop on 5/26/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarMonthHeaderView : UICollectionReusableView
@property (strong, nonatomic) UIFont *monthHeaderFont UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *monthHeaderTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *monthHeaderBackgroundColor UI_APPEARANCE_SELECTOR;

- (void)configureWithTitle:(NSString *)titleText;

@end
