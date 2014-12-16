//
//  MetronmoneTopSubViewIphone.h
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LargeBPMPicker.h"
#import "SubPropertySelector.h"
#import "TimeSignaturePickerView.h"
#import "VoiceTypePickerView.h"
#import "LoopCellEditerView.h"
#import "TapAnimationImage.h"

@interface MetronmoneTopSubViewIphone : XibViewInterface <LargeBPMPickerProtocol>

@property (strong, nonatomic) IBOutlet LargeBPMPicker *BPMPicker;
@property (strong, nonatomic) IBOutlet UIButton *PlayMusicButton;

@property (strong, nonatomic) IBOutlet UIButton *PlayCellListButton;
@property (strong, nonatomic) IBOutlet UIButton *VoiceTypePicker;
@property (strong, nonatomic) IBOutlet UIButton *TimeSigaturePicker;
@property (strong, nonatomic) IBOutlet UIButton *LoopCellEditer;
@property (strong, nonatomic) IBOutlet UIButton *SystemButton;

@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIScrollView *OptionScrollView;
@property (strong, nonatomic) IBOutlet TimeSignaturePickerView *TimeSignaturePickerView;
@property (strong, nonatomic) IBOutlet VoiceTypePickerView *VoiceTypePickerView;
@property (strong, nonatomic) IBOutlet LoopCellEditerView *LoopCellEditerView;
@property (strong, nonatomic) IBOutlet TapAnimationImage *TapAnimationImage;

@end
