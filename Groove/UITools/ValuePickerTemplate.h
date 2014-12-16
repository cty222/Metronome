//
//  ValuePickerTemplate.h
//  Groove
//
//  Created by C-ty on 2014/12/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@class ValuePickerTemplate;

@protocol ValuePickerTemplateProtocol <NSObject>
@required

@optional

- (void) SetValue : (int) NewValue;
- (void) ShortPress: (ValuePickerTemplate *) ThisPicker;
@end

@interface ValuePickerTemplate : XibViewInterface


@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *UpArrow;
@property (strong, nonatomic) IBOutlet UIImageView *DownArrow;

@property (getter=GetMaxLimit, setter=SetMaxLimit:) int MaxLimit;
@property (getter=GetMinLimit, setter=SetMinLimit:) int MinLimit;
@property (getter = GetValue, setter = SetValue:) int Value;
@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;
- (void) SetValueWithoutDelegate : (int) NewValue;


@property (nonatomic, assign) id<ValuePickerTemplateProtocol> delegate;
@end
