//
//  TimeSignaturePickerView.h
//  Groove
//
//  Created by C-ty on 2014/12/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SubPropertySelector.h"
#import "TimeSignatureType.h"
#import "TwoDigitsValuePicker.h"

@interface TimeSignaturePickerView : SubPropertySelector<ValuePickerTemplateProtocol>

+ (UIColor *) TextFontColor;

- (void) DisplayPropertyCell : (NSArray *) FillInData : (UIView *) TriggerButton;

@end
