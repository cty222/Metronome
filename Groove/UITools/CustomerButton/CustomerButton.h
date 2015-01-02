//
//  CustomerButton.h
//  Groove
//
//  Created by C-ty on 2015/1/3.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@class CustomerButton;

@protocol CustomerButtonProtocol <NSObject>
@required

@optional

- (void) ShortPress: (CustomerButton *) ThisPicker;
@end

@interface CustomerButton : XibViewInterface

@property (strong, nonatomic) IBOutlet UILabel *NameLabel;

@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;
@property (nonatomic, assign) id<CustomerButtonProtocol> delegate;

@end
