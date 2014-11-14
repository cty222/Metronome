//
//  MetronomeMainViewControllerIphone.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

// View
#import "MetronmoneTopSubViewIphone.h"
#import "MetronomeBottomSubViewIphone.h"
#import "MetronomeSelectBar.h"

// Tools
#import "NotesTool.h"
#import "AudioPlay.h"

// Control sub class
#import "CellParameterSettingControl.h"


typedef enum {
    STOP_PLAYING         = 0,
    SINGLE_PLAYING,
    LOOP_PLAYING,
} METRONOME_PLAYING_MODE;

@interface MetronomeMainViewControllerIphone : UIViewController <NoteProtocol, SelectBarProtocol, MetronomeBottomViewProtocol,LargeBPMPickerProtocol, CircleButtonProtocol, ADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (nonatomic) MetronmoneTopSubViewIphone *TopSubView;
@property (nonatomic) MetronomeBottomSubViewIphone *BottomSubView;


@property (nonatomic, strong) BeepBound* CurrentVoice;
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;
@property (getter = GetPlayingMode, setter = SetPlayingMode:) METRONOME_PLAYING_MODE PlayingMode;


// Control point View

// (1) Volume sets
@property (strong, nonatomic) IBOutlet CircleButton *AccentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *QuarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *EighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *SixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *TrippleNoteCircleVolumeButton;

// (2) Cell parameter control item
@property (strong, nonatomic) IBOutlet LargeBPMPicker *BPMPicker;
@property (strong, nonatomic) IBOutlet CircleButton *VoiceTypeCircleButton;
@property (strong, nonatomic) IBOutlet UIButton *TimeSigaturePicker;
@property (strong, nonatomic) IBOutlet UIButton *TapButton;

// (3) Playing Cell functon item
@property (strong, nonatomic) IBOutlet UIButton *PlayCurrentCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;

// (4) Loop Control function button
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;

// (5) System Button
@property (strong, nonatomic) IBOutlet UIButton *SystemButton;
@property(nonatomic,retain)IBOutlet ADBannerView *adView;

@end
