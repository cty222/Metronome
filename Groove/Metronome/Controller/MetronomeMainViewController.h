//
//  MetronomeMainViewControllerIphone.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

// ========================
// Global services
#import "GlobalServices.h"

// 
// ========================

// iAd
#import "iAd/iAd.h"
#import "WebAd.h"

// WindowsHook
#import "UIWindowWithHook.h"

// New top view
#import "TopPartOfMetronome4SVersionViewController.h"
#import "TopPartOfMetronomeViewController.h"

// View bottom
#import "MetronomeBottomView.h"
#import "MusicSettingBottomSubview.h"
#import "MusicSpeedBottomSubview.h"

#import "MetronomeSelectBar.h"

// Tools
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

// ====================
// TODO: make it readable
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIView *middleAdView;

@property (nonatomic) MetronomeBottomView *volumeBottomSubview;
@property (nonatomic) MusicSettingBottomSubview *musicSettingBottomSubview;
@property (nonatomic) MusicSpeedBottomSubview *musicSpeedBottomSubview;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomSubviewSwitcher;

// new
@property (strong, nonatomic) TopPartOfMetronomeViewController *topPartOfMetronomeViewController;

//
// ====================


// GlobalServices
@property GlobalServices *globalServices;
@property MetronomeEngine * engine;

// Ad view
@property(nonatomic,retain)IBOutlet ADBannerView *adView;

// webAd and Network Manager
// TODO: move to class
@property (strong, nonatomic) IBOutlet WebAd *webAdSubview;
@property (strong, nonatomic) IBOutlet UIButton *closeWebAdSubviewbtn;
@property AFHTTPRequestOperationManager *networkManager;


@property (setter=setCurrentSelectedCellIndex:, getter=getCurrentSelectedCellIndex)int currentSelectedCellIndex;
@property (setter=setCurrentPlayingMode:, getter=getCurrentPlayingMode)METRONOME_PLAYING_MODE currentPlayingMode;

@property BOOL doesItNeedToRestartMetronome;
@property MusicProperties * MusicProperties;


- (id) initWithGlobalServices: (GlobalServices *) globalService;

// TODO: move to private 
- (void) syncTempoListWithModel;
- (void) syncTempoCellDatatableWithModel;
- (int) getCurrentCellFromTempoList;
- (void) reflashCellListAndCurrentCellByCurrentData;

// Sub Controller
@property  CellParameterSettingControl * cellParameterSettingSubController;
@property  LoopAndPlayViewControl * loopAndPlayViewSubController;
@property  SystemPageControl * systemPageController;

@end
