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

- (void) SetValue : (ValuePickerTemplate *) ThisPicker;
- (void) ShortPress: (ValuePickerTemplate *) ThisPicker;
@end

@interface ValuePickerTemplate : XibViewInterface


@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *UpArrow;
@property (strong, nonatomic) IBOutlet UIImageView *DownArrow;

@property (getter=GetMaxLimit, setter=SetMaxLimit:) float MaxLimit;
@property (getter=GetMinLimit, setter=SetMinLimit:) float MinLimit;
@property (getter = GetValue, setter = SetValue:) float Value;
@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;
- (void) SetValueWithoutDelegate : (int) NewValue;


@property (nonatomic, assign) id<ValuePickerTemplateProtocol> delegate;
@end
