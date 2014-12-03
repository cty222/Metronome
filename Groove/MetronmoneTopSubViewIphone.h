//
//  MetronmoneTopSubViewIphone.h
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LargeBPMPicker.h"
#import "SubPropertySelector.h"
#import "LoopCellEditBar.h"

@interface MetronmoneTopSubViewIphone : XibViewInterface <LargeBPMPickerProtocol>

@property (strong, nonatomic) IBOutlet LargeBPMPicker *BPMPicker;

@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *VoiceTypePicker;
@property (strong, nonatomic) IBOutlet UIButton *TimeSigaturePicker;
@property (strong, nonatomic) IBOutlet UIButton *LoopCellEditer;
@property (strong, nonatomic) IBOutlet UIButton *SystemButton;

@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIScrollView *OptionScrollView;
@property (strong, nonatomic) IBOutlet SubPropertySelector *SubPropertySelectorView;
@property (strong, nonatomic) IBOutlet LoopCellEditBar *LoopCellEditBarView;
@property (strong, nonatomic) IBOutlet UIImageView *TapAlertImage;

@end
