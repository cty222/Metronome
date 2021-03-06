//
//  MetronomeMainViewControllerIphone.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

// WindowsHook
#import "UIWindowWithHook.h"

// View
#import "MetronmoneTopSubViewIphone.h"
#import "MetronomeBottomView.h"
#import "MetronomeSelectBar.h"

// Tools
#import "NotesTool.h"
#import "AudioPlay.h"

// Control sub class
#import "CellParameterSettingControl.h"
#import "LoopAndPlayViewControl.h"
#import "SystemPageControl.h"
#import "PlayerForSongs.h"

@class LoopAndPlayViewControl;
@class CellParameterSettingControl;
@class SystemPageControl;

typedef enum {
    STOP_PLAYING         = 0,
    SINGLE_PLAYING,
    LIST_PLAYING,
} METRONOME_PLAYING_MODE;

@interface MetronomeMainViewController : UIViewController <NoteProtocol>
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (nonatomic) MetronmoneTopSubViewIphone *TopSubView;
@property (nonatomic) MetronomeBottomView *BottomSubView;

@property NSArray * CurrentCellsDataTable;
@property (nonatomic, strong) BeepBound* CurrentVoice;
@property (nonatomic, strong) NSString* CurrentTimeSignature;
@property (nonatomic, strong) TempoList* CurrentTempoList;

@property TempoCell* CurrentCell;
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;
@property (getter = GetPlayingMode, setter = SetPlayingMode:) METRONOME_PLAYING_MODE PlayingMode;

@property BOOL IsNeededToRestartMetronomeClick;
@property MusicProperties * MusicProperties;

- (void) SyncCurrentTempoListFromModel;
- (void) SyncCurrentTempoCellDatatableWithModel;
- (int) GetFocusCellWithCurrentTempoList;


- (void) ReflashCellListAndFocusCellByCurrentData;


// Sub Controller
@property  CellParameterSettingControl * CellParameterSettingSubController;
@property  LoopAndPlayViewControl * LoopAndPlayViewSubController;
@property  SystemPageControl * SystemPageController;

@end
