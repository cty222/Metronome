//
//  CellParameterSettingControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeMainViewController.h"
#import "TapFunction.h"
#import "VolumeSetsControl.h"



typedef enum{
    VOICE_TYPE_BUTTON = 201,
} PARAMETER_BUTTON_TAG;

@interface CellParameterSettingControl : NSObject <LargeBPMPickerProtocol, SubPropertySelectorProtocol>

// (2) Cell parameter control item
@property (strong, nonatomic) IBOutlet LargeBPMPicker *BPMPicker;
@property (strong, nonatomic) IBOutlet UIButton *VoiceTypePicker;
@property (strong, nonatomic) IBOutlet UIButton *TimeSigaturePicker;
@property (strong, nonatomic) IBOutlet UIButton *LoopCellEditer;
@property (strong, nonatomic) IBOutlet TimeSignaturePickerView *TimeSignaturePickerView;
@property (strong, nonatomic) IBOutlet VoiceTypePickerView *VoiceTypePickerView;
@property (strong, nonatomic) IBOutlet LoopCellEditerView *LoopCellEditerView;
@property (strong, nonatomic) IBOutlet UIScrollView *OptionScrollView;

// (3) AlertImage
@property (strong, nonatomic) IBOutlet TapAnimationImage *TapAlertImage;

@property UIViewController *ParrentController;

// Tmp volumeset
@property VolumeSetsControl * VolumeSetsControl;


- (void) MainViewWillAppear;
- (void) InitlizeCellParameterControlItems;
- (int) DecodeTimeSignatureToValue : (NSString *)TimeSignatureString;


- (void) ChangeVoiceTypePickerImage: (int) TagNumber;

@end
