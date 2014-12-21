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

@protocol  MusicTimePickerProtocol <InputSubmitViewProtocol>
@required

@optional

- (IBAction) Liston : (UIButton *) ListonButton;
@end

@interface MusicTimePicker : InputSubmitView
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *MinuteValuePicker;
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *SecondValuePicker;
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *CentisecondsPicker;

@property (strong, nonatomic) IBOutlet UIButton *SaveButton;
@property (strong, nonatomic) IBOutlet UIButton *ListonButton;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;

@property float MusicEnd;
@property (getter=GetValue, setter=SetValue:) NSTimeInterval Value;

- (NSTimeInterval) GetUIValue;
- (NSString *) ReturnCurrentValueString;
@property (nonatomic, assign) id <MusicTimePickerProtocol> delegate;

@end
