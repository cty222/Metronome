//
//  MusicTimePicker.h
//  Groove
//
//  Created by C-ty on 2014/12/19.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "InputSubmitView.h"
#import "GlobalConfig.h"
#import "OneDigitsValuePicker.h"
#import "TwoDigitsValuePicker.h"
#import "ThreeDigitsValuePicker.h"

// 0.01f use 28% cpu
// 0.02f use 16% cpu
// 0.04f use 8%  cpu
#define SCROLL_LABEL_UPDATE_RATE (0.04f)

@protocol  MusicTimePickerProtocol <InputSubmitViewProtocol>
@required

@optional

- (IBAction) Listen : (UIButton *) ListonButton;
@end

@interface MusicTimePicker : InputSubmitView
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *MinuteValuePicker;
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *SecondValuePicker;
@property (strong, nonatomic) IBOutlet TwoDigitsValuePicker *CentisecondsPicker;

@property (strong, nonatomic) IBOutlet UIButton *SaveButton;
@property (strong, nonatomic) IBOutlet UIButton *ListenButton;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;
@property (strong, nonatomic) IBOutlet UILabel *DurationTime;

@property (getter=GetMusicDuration, setter=SetMusicDuration:) NSTimeInterval MusicDuration;
@property (getter=GetValue, setter=SetValue:) NSTimeInterval Value;

- (NSTimeInterval) GetUIValue;
- (NSString *) ReturnCurrentValueString;
@property (nonatomic, assign) id <MusicTimePickerProtocol> delegate;

@property (strong, nonatomic) IBOutlet UIButton *SyncScrollValueToDigitsButton;
@property (strong, nonatomic) IBOutlet UILabel *ScrollTimeLabel;
@property (strong, nonatomic) IBOutlet UISlider *TimeScrollBar;
@end
