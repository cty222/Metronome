//
//  MusicTimePicker.h
//  Groove
//
//  Created by C-ty on 2014/12/19.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "InputSubmitView.h"
#import "OneDigitsValuePicker.h"
#import "TwoDigitsValuePicker.h"
#import "ThreeDigitsValuePicker.h"

@interface MusicTimePicker : InputSubmitView
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *MinuteValuePicker;
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *SecondValuePicker;
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *CentisecondsPicker;

@property (strong, nonatomic) IBOutlet UIButton *SaveButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayButton;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;

@property float MusicEnd;
@property (getter=GetValue, setter=SetValue:) NSTimeInterval Value;

- (NSString *) ReturnCurrentValueString;

@end
