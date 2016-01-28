//
//  TopPartOfMetronomeViewController.h
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BPMPickerViewController.h"
#import "SubPropertySelector.h"
#import "TimeSignaturePickerView.h"
#import "VoiceTypePickerView.h"
#import "LoopCellEditerView.h"
#import "TapAnimationImage.h"

@interface TopPartOfMetronomeViewController : UIViewController <LargeBPMPickerProtocol>

@property (strong, nonatomic) IBOutlet UIView *BPMPicker;
@property (strong, nonatomic) BPMPickerViewController *bPMPickerViewController;





@property (strong, nonatomic) IBOutlet TimeSignaturePickerView *TimeSignaturePickerView;
@property (strong, nonatomic) IBOutlet VoiceTypePickerView *VoiceTypePickerView;
@property (strong, nonatomic) IBOutlet LoopCellEditerView *LoopCellEditerView;
@property (strong, nonatomic) IBOutlet UIScrollView *OptionScrollView;
@property (strong, nonatomic) IBOutlet UIButton *TimeSigaturePicker;
@property (strong, nonatomic) IBOutlet UIButton *VoiceTypePicker;
@property (strong, nonatomic) IBOutlet UIButton *LoopCellEditer;
@property (strong, nonatomic) IBOutlet TapAnimationImage *TapAnimationImage;
@property (strong, nonatomic) IBOutlet UIButton *PlayCellListButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayMusicButton;
@property (strong, nonatomic) IBOutlet UIButton *SystemButton;

@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;



@end
