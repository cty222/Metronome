//
//  MetronomeMainViewControllerIphone.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

// iAd
#import "iAd/iAd.h"
#import "WebAd.h"

// WindowsHook
#import "UIWindowWithHook.h"

// View top
#import "MetronmoneTopSubViewIphone.h"

// View bottom
#import "MetronomeBottomView.h"
#import "MusicSettingBottomSubview.h"
#import "MusicSpeedBottomSubview.h"

#import "MetronomeSelectBar.h"

// Tools
#import "NotesTool.h"
#import "AudioPlay.h"

// Control sub class
#import "CellParameterSettingControl.h"
#import "LoopAndPlayViewControl.h"
#import "SystemPageControl.h"
#import "PlayerForSongs.h"


// AFNetworking
#import "AFHTTPRequestOperationManager.h"

@class LoopAndPlayViewControl;
@class CellParameterSettingControl;
@class SystemPageControl;

typedef enum {
    STOP_PLAYING         = 0,
    SINGLE_PLAYING,
    LIST_PLAYING,
} METRONOME_PLAYING_MODE;

@interface MetronomeMainViewController : UIViewController <NoteProtocol, WebAdProtocol>
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIView *middleAdView;

@property (nonatomic) MetronmoneTopSubViewIphone *TopSubView;
@property (nonatomic) MetronomeBottomView *volumeBottomSubview;
@property (nonatomic) MusicSettingBottomSubview *musicSettingBottomSubview;
@property (nonatomic) MusicSpeedBottomSubview *musicSpeedBottomSubview;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomSubviewSwitcher;

// Ad view
@property(nonatomic,retain)IBOutlet ADBannerView *adView;

// webAd
// TODO: move to class
@property (strong, nonatomic) IBOutlet WebAd *webAdSubview;
@property (strong, nonatomic) IBOutlet UIButton *closeWebAdSubviewbtn;

// Network Manager
@property AFHTTPRequestOperationManager *networkManager;

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
