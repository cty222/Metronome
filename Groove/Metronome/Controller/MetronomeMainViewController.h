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

// New view
#import "TopPartOfMetronome4SVersionViewController.h"
#import "TopPartOfMetronomeViewController.h"
#import "BottomPartOfVolumeViewController.h"
#import "BottomPartOfMusicControlPanelViewController.h"
#import "BottomPartOfMusicSpeedViewController.h"
//
// ========================

// iAd
#import "iAd/iAd.h"
#import "WebAd.h"

// WindowsHook
#import "UIWindowWithHook.h"


// View bottom
#import "MetronomeSelectBar.h"

// Tools
#import "AudioPlay.h"

// Control sub class
#import "PlayerForSongs.h"


// AFNetworking
#import "AFHTTPRequestOperationManager.h"


typedef enum {
    STOP_PLAYING         = 0,
    SINGLE_PLAYING,
    LIST_PLAYING,
} METRONOME_PLAYING_MODE;


@interface MetronomeMainViewController : UIViewController <NoteProtocol, WebAdProtocol, ADBannerViewDelegate>

// ====================
// TODO: make it readable
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *middleAdView;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomSubviewSwitcher;

// new
@property (strong, nonatomic) TopPartOfMetronomeViewController *topPartOfMetronomeViewController;
@property (strong, nonatomic) BottomPartOfVolumeViewController *bottomPartOfVolumeViewController;
@property (strong, nonatomic) BottomPartOfMusicControlPanelViewController *bottomPartOfMusicControlPanelViewController;
@property (strong, nonatomic) BottomPartOfMusicSpeedViewController *bottomPartOfMusicSpeedViewController;

//
// ====================


// GlobalServices
@property GlobalServices *globalServices;
@property MetronomeEngine * engine;

// Ad view
@property(nonatomic,retain)IBOutlet ADBannerView *adView;


@property (setter=setCurrentSelectedCellIndex:, getter=getCurrentSelectedCellIndex)int currentSelectedCellIndex;
@property (setter=setCurrentPlayingMode:, getter=getCurrentPlayingMode)METRONOME_PLAYING_MODE currentPlayingMode;

@property BOOL doesItNeedToRestartMetronome;
@property MusicProperties * MusicProperties;

- (id) initWithGlobalServices: (GlobalServices *) globalService;

// webAd and Network Manager
// TODO: move to class
@property (strong, nonatomic) IBOutlet WebAd *webAdSubview;
@property (strong, nonatomic) IBOutlet UIButton *closeWebAdSubviewbtn;
@property AFHTTPRequestOperationManager *networkManager;
@end
