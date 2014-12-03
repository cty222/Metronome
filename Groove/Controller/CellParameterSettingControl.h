//
//  CellParameterSettingControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeMainViewControllerIphone.h"

#define TAP_CLEAR_DELAY 3

typedef enum{
    ACCENT_VOLUME_BUTTON = 101,
    QUARTER_VOLUME_BUTTON,
    EIGHTH_NOTE_VOLUME_BUTTON,
    SIXTEENTH_NOTE_VOLUME_BUTTON,
    TRIPPLET_NOTE_VOLUME_BUTTON
} VOLUME_BUTTON_TAG;

typedef enum{
    VOICE_TYPE_BUTTON = 201,
} PARAMETER_BUTTON_TAG;

@interface CellParameterSettingControl : NSObject <CircleButtonProtocol, LargeBPMPickerProtocol>

// (1) Volume sets
@property (strong, nonatomic) IBOutlet CircleButton *AccentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *QuarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *EighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *SixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *TrippleNoteCircleVolumeButton;

// (2) Cell parameter control item
@property (strong, nonatomic) IBOutlet LargeBPMPicker *BPMPicker;
@property (strong, nonatomic) IBOutlet UIButton *VoiceTypePicker;
@property (strong, nonatomic) IBOutlet UIButton *TimeSigaturePicker;
@property (strong, nonatomic) IBOutlet UIButton *LoopCellEditer;
@property (strong, nonatomic) IBOutlet SubPropertySelector *SubPropertySelectorView;
@property (strong, nonatomic) IBOutlet LoopCellEditBar *LoopCellEditBarView;
@property (strong, nonatomic) IBOutlet UIScrollView *OptionScrollView;

// (3) AlertImage
@property (strong, nonatomic) IBOutlet UIImageView *TapAlertImage;

@property UIViewController *ParrentController;


- (void) InitializeVolumeSets;
- (void) InitlizeCellParameterControlItems;
- (void) SetVolumeBarVolume : (TempoCell *)Cell;
- (int) DecodeTimeSignatureToValue : (NSString *)TimeSignatureString;

@end
