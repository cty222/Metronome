//
//  MetronomeMainViewControllerIphone.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeMainViewController.h"

// private property
@interface MetronomeMainViewController ()
@property BOOL doesItNeedToChangeToNextCellAfterFinished;

@end

@implementation MetronomeMainViewController
{
    
}

@synthesize globalServices = _globalServices;
@synthesize engine = _engine;
@synthesize currentSelectedCellIndex = _currentSelectedCellIndex;
@synthesize currentPlayingMode = _currentPlayingMode;

- (id) initWithGlobalServices: (GlobalServices *) globalService
{
    self = [super init];
    if (self){
        self.globalServices = globalService;
        self.engine = self.globalServices.engine;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initLocalServices];
    
    [self initializeFlagStatus];
    
    [self initializeLayoutToFitDeviceSize];
    
    // Initalize Sub View
    [self initializeTopSubView];
    
    [self initializeBottomSubView];
    
    // Get Control UI form sub View and initialize default data
    [self initializeSubController];
    
    [self registerNotifications];
    
    [self initializeCustomizeAdPopUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self syncTempoListWithModel];
    
    [self syncTempoCellDatatableWithModel];

    [self reflashCellListAndCurrentCellByCurrentData];
    
    if (self.cellParameterSettingSubController != nil)
    {
        [self.cellParameterSettingSubController MainViewWillAppear];
    }
    
    if (self.loopAndPlayViewSubController != nil)
    {
        [self.loopAndPlayViewSubController MainViewWillAppear];
    }
    
    if (self.systemPageController != nil)
    {
        [self.systemPageController MainViewWillAppear];
    }
    
    // ===================
    // Setup music by model music info
    if (gPlayMusicChannel == nil)
    {
        gPlayMusicChannel = [PlayerForSongs alloc];
    }
    
    if (self.engine.currentTempoList.musicInfo == nil)
    {
        self.engine.currentTempoList.musicInfo = [gMetronomeModel CreateNewMusicInfo];
        [gMetronomeModel Save];
    }
    
    [self SyncMusicInfoFromTempList];

    [self SyncMusicPropertyFromGlobalConfig];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.currentPlayingMode = STOP_PLAYING;
    [gPlayMusicChannel Stop];
}

// ==============================
// initialize and register methods
// ==============================
- (void) initLocalServices
{
}

- (void) initializeFlagStatus
{
    _currentPlayingMode = STOP_PLAYING;
    _currentSelectedCellIndex = -1;
    
    self.doesItNeedToRestartMetronome = NO;
}

- (void) initializeLayoutToFitDeviceSize
{
    // TODO: fixed iPhone 6S layout error
    CGRect FullViewFrame = self.FullView.frame;
    CGRect TopViewFrame = self.TopView.frame;
    CGRect BottomViewFrame = self.BottomView.frame;
    
    
    NSNumber * DeviceType = [GlobalConfig DeviceType];
    switch (DeviceType.intValue) {
        case IPHONE_4S:
            FullViewFrame = CGRectMake(FullViewFrame.origin.x
                                       , FullViewFrame.origin.y
                                       , FullViewFrame.size.width
                                       , IPHONE_4S_HEIGHT
                                       );
            
            TopViewFrame = CGRectMake(TopViewFrame.origin.x
                                      , TopViewFrame.origin.y
                                      , TopViewFrame.size.width
                                      , TopViewFrame.size.height - (IPHONE_5S_HEIGHT - IPHONE_4S_HEIGHT)
                                      );
            BottomViewFrame = CGRectMake(BottomViewFrame.origin.x
                                         , BottomViewFrame.origin.y  - (IPHONE_5S_HEIGHT - IPHONE_4S_HEIGHT)
                                         , BottomViewFrame.size.width
                                         , BottomViewFrame.size.height
                                         );
            break;
        case IPHONE_5S:
            break;
        default:
            break;
    }
    
    self.FullView.frame = FullViewFrame;
    self.TopView.frame = TopViewFrame;
    self.BottomView.frame = BottomViewFrame;
    

}

- (void) initializeSubController
{
    self.cellParameterSettingSubController = [[CellParameterSettingControl alloc] init];
    self.cellParameterSettingSubController.ParrentController = self;
    
    self.loopAndPlayViewSubController = [[LoopAndPlayViewControl alloc] init];
    self.loopAndPlayViewSubController.ParrentController = self;
    
    self.systemPageController = [[SystemPageControl alloc] init];
    self.systemPageController.ParrentController = self;
    
    [self.cellParameterSettingSubController initlizeCellParameterControlItems];
    
    [self.loopAndPlayViewSubController InitlizePlayingItems];
    
    [self.loopAndPlayViewSubController InitializeLoopControlItem];
    
    [self.systemPageController InitializeSystemButton];
}

- (void) initializeTopSubView
{
    if (self.TopSubView == nil)
    {
        CGRect subFrame = self.TopView.frame;
        subFrame.origin = CGPointMake(0, 0);
        self.TopSubView = [[MetronmoneTopSubViewIphone alloc] initWithFrame:subFrame];
    }
    if (self.TopView.subviews.count != 0)
    {
        [[self.TopView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.TopView addSubview:self.TopSubView];
    
}

- (void) initializeBottomSubView
{
    if (self.BottomView.subviews.count != 0)
    {
        [[self.BottomView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 1. volumeBottomSubview
    if (self.volumeBottomSubview == nil)
    {
        CGRect SubFrame = self.BottomView.frame;
        SubFrame.origin = CGPointMake(0, 0);
        
        self.volumeBottomSubview = [[MetronomeBottomView alloc] initWithFrame:SubFrame];
    }
    
    
    // 2. musicSettingBottomSubview
    if (self.musicSettingBottomSubview == nil)
    {
        CGRect SubFrame = self.BottomView.frame;
        SubFrame.origin = CGPointMake(0, 0);
        
        self.musicSettingBottomSubview = [[MusicSettingBottomSubview alloc] initWithFrame:SubFrame];
    }
    
    
    if (self.musicSpeedBottomSubview == nil)
    {
        CGRect SubFrame = self.BottomView.frame;
        SubFrame.origin = CGPointMake(0, 0);
        
        self.musicSpeedBottomSubview = [[MusicSpeedBottomSubview alloc] initWithFrame:SubFrame];
    }
    
    [self.BottomView addSubview:self.volumeBottomSubview];
    [self.BottomView addSubview:self.musicSettingBottomSubview];
    [self.BottomView addSubview:self.musicSpeedBottomSubview];
    
    // 預設開 volumeBottomSubview
    [self bottomSwitchToVolumes: self.volumeBottomSubview];
}

- (void) initializeCustomizeAdPopUp
{
    // initialize web ad
    if (self.webAdSubview == nil)
    {
        CGRect subFrame = self.middleAdView.frame;
        subFrame.origin = CGPointMake(0, 0);
        self.webAdSubview = [[WebAd alloc] initWithFrame:subFrame];
    }
    if (self.middleAdView.subviews.count != 0)
    {
        [[self.middleAdView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.middleAdView addSubview:self.webAdSubview];
    self.webAdSubview.delegate = self;
    self.middleAdView.hidden = YES;
}

- (void) registerNotifications
{
    // Change View Controller
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePageToSystemView:)
                                                 name:kChangeToSystemPageView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePageToMetronomeView:)
                                                 name:kChangeBackToMetronomeView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(VoiceStopByInterrupt:)
                                                 name:kVoiceStopByInterrupt
                                               object:nil];
}

// =============================
// notification callback
// =============================
- (void) ChangePageToSystemView:(NSNotification *)Notification
{
    [self presentViewController:[self.globalServices getUIViewController:SYSTEMSETTING_PAGE] animated:YES completion:nil];
}

- (void) ChangePageToMetronomeView:(NSNotification *)Notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) VoiceStopByInterrupt: (NSNotification *)Notification
{
    self.currentPlayingMode = STOP_PLAYING;
}

// ============
//
// TODO : Model Sync
//

- (void) syncTempoListWithModel
{
    NSNumber *LastTempoListIndexUserSelected = [GlobalConfig GetLastTempoListIndexUserSelected];
    
    self.engine.currentTempoList =  [gMetronomeModel PickTargetTempoListFromDataTable:LastTempoListIndexUserSelected];
   
    if (self.engine.currentTempoList == nil)
    {
        NSLog(@"嚴重錯誤: Last TempoList 同步錯誤 Error!!!");

        self.engine.currentTempoList = [gMetronomeModel PickTargetTempoListFromDataTable:@0];
        if (self.engine.currentTempoList == nil)
        {
            NSLog(@"嚴重錯誤: TempoList 資料庫需要reset");
        }
        else
        {
            [GlobalConfig SetLastTempoListIndexUserSelected:0];
        }
    }
    
    if (self.engine.currentTempoList != nil)
    {
        [self SyncMetronomePrivateProperties];
    }
}

- (void) SyncMetronomePrivateProperties
{
    if (self.engine.currentTempoList == nil)
    {
        NSLog(@"Error: Using Error CurrentList is nil!!");
        [self syncTempoListWithModel];
        return;
    }
    
    if ([self.engine.currentTempoList.privateProperties.doubleValueEnable boolValue])
    {
        self.cellParameterSettingSubController.BPMPicker.Mode = BPM_PICKER_DOUBLE_MODE;
    }
    else
    {
        self.cellParameterSettingSubController.BPMPicker.Mode = BPM_PICKER_INT_MODE;
    }
}

- (void) SyncMusicPropertyFromGlobalConfig
{
    self.MusicProperties = [GlobalConfig GetMusicProperties];
    if (self.MusicProperties.MusicFunctionEnable)
    {
        self.loopAndPlayViewSubController.PlayMusicButton.hidden = NO;
        self.loopAndPlayViewSubController.PlayCellListButton.hidden = YES;
        
        // Sync music property
        if (self.MusicProperties.MusicHalfRateEnable)
        {
            [gPlayMusicChannel SetPlayRateToHalf];
        }
        else
        {
            [gPlayMusicChannel SetPlayRateToNormal];
        }
        
        [gPlayMusicChannel SetPlayMusicLoopingEnable: self.MusicProperties.PlayMusicLoopingEnable];
        
    }
    else
    {
        self.loopAndPlayViewSubController.PlayMusicButton.hidden = YES;
        self.loopAndPlayViewSubController.PlayCellListButton.hidden = NO;
    }
}

- (void) SyncMusicInfoFromTempList
{
    if (self.engine.currentTempoList.musicInfo.persistentID != nil)
    {
        MPMediaItem *Item =  [gPlayMusicChannel GetFirstMPMediaItemFromPersistentID : self.engine.currentTempoList.musicInfo.persistentID ];
        if (![gPlayMusicChannel isPlaying])
        {
            [gPlayMusicChannel PrepareMusicToplay:Item];
        }
        gPlayMusicChannel.StartTime = [self.engine.currentTempoList.musicInfo.startTime floatValue];
        gPlayMusicChannel.StopTime = [self.engine.currentTempoList.musicInfo.endTime floatValue];
        gPlayMusicChannel.Volume = [self.engine.currentTempoList.musicInfo.volume floatValue];
    }
}

- (void) syncTempoCellDatatableWithModel
{
    if (self.engine.currentTempoList == nil)
    {
        NSLog(@"錯誤: SyncCurrentFocusCellFromCurrentTempoList CurrentTempoList == nil");
        return;
    }

    self.engine.tempoCells = [gMetronomeModel FetchTempoCellFromTempoListWithSort:self.engine.currentTempoList];
    if (self.engine.tempoCells == nil)
    {
        self.engine.tempoCells = gMetronomeModel.TempoListDataTable[0];
    }
    
#if TOOD
    NSLog(@"%@", self.tempoCells);
#endif
}

- (int) getCurrentCellFromTempoList
{
    if (self.engine.currentTempoList == nil)
    {
        NSLog(@"錯誤: SyncCurrentFocusCellFromCurrentTempoList CurrentTempoList == nil");
        return 0;
    }
    
    NSNumber *lastFocusCellIndex = self.engine.currentTempoList.focusCellIndex;

    if (self.engine.tempoCells.count > [lastFocusCellIndex intValue])
    {
        return [lastFocusCellIndex intValue];
    }
    else
    {
        return 0;
    }
}

- (void) reflashCellListAndCurrentCellByCurrentData
{
    [self.loopAndPlayViewSubController CopyCellListToSelectBar : self.engine.tempoCells];
}


//
// ============

//  =========================
//  property
//
- (int) getCurrentSelectedCellIndex
{
    if (_currentSelectedCellIndex >= self.engine.tempoCells.count)
    {
        NSLog(@"Bug !! Controller _currentSelectedCellIndex over count error" );
        _currentSelectedCellIndex = (int)(self.engine.tempoCells.count -1);
    }
    else if (_currentSelectedCellIndex < 0)
    {
        NSLog(@"Bug !! Controller _currentSelectedCellIndex lower 0 error");
        _currentSelectedCellIndex = 0;
        
    }
    return _currentSelectedCellIndex;
}

// won't set in Bottom View UI
- (void) setCurrentSelectedCellIndex:(int) newValue
{
    if (newValue < 0
        || newValue >= self.engine.tempoCells.count
        || (self.currentPlayingMode == LIST_PLAYING && newValue == _currentSelectedCellIndex && !self.engine.listChangeFocusFlag)
        )
    {
      return;
    }
    else if (self.engine.listChangeFocusFlag)
    {
        self.engine.listChangeFocusFlag = NO;
    }
    
    _currentSelectedCellIndex = newValue;
    
    // sync to Model
    self.engine.currentTempoList.focusCellIndex = [NSNumber numberWithInt:_currentSelectedCellIndex];
    [gMetronomeModel Save];
    
    self.engine.currentCell = self.engine.tempoCells[_currentSelectedCellIndex];
    
    // Set BPM
    self.TopSubView.BPMPicker.Value = [self.engine.currentCell.bpmValue floatValue];
    
    // Set Volume Set
    [self.cellParameterSettingSubController.VolumeSetsControl SetVolumeBarVolume:self.engine.currentCell];
    
    // Set Voice
    self.engine.currentVoice = [self.globalServices.engine.clickVoiceList objectAtIndex:[self.engine.currentCell.voiceType.sortIndex intValue]];
    [self.cellParameterSettingSubController ChangeVoiceTypePickerImage:[self.engine.currentCell.voiceType.sortIndex intValue]];
    
    // Set TimeSignature
    self.engine.currentTimeSignature = self.engine.currentCell.timeSignatureType.timeSignature;
    [self.cellParameterSettingSubController.TimeSigaturePicker setTitle:self.engine.currentTimeSignature forState:UIControlStateNormal];

    // Set LoopCount
    [self.cellParameterSettingSubController.LoopCellEditerView.ValueScrollView SetValueWithoutDelegate:[self.engine.currentCell.loopCount intValue]];

    
    [self resetCounter];
}

- (METRONOME_PLAYING_MODE) getCurrentPlayingMode
{
    return _currentPlayingMode;
}

- (void) setCurrentPlayingMode : (METRONOME_PLAYING_MODE) newValue
{
    if (newValue == _currentPlayingMode)
    {
        return;
    }
    
    _currentPlayingMode = newValue;
    
    switch (_currentPlayingMode) {
        case STOP_PLAYING:
            [self stopClick];
            [self resetCounter];

            if (self.MusicProperties.MusicFunctionEnable && self.MusicProperties.PlaySingleCellWithMusicEnable)
            {
                if (gPlayMusicChannel.isPlaying)
                {
                    [gPlayMusicChannel Stop];
                }
            }
            
            self.bottomSubviewSwitcher.hidden = NO;
            self.adView.hidden = YES;
            break;
        case SINGLE_PLAYING:
            [self startClick];
            if (self.MusicProperties.MusicFunctionEnable && self.MusicProperties.PlaySingleCellWithMusicEnable)
            {
                if (gPlayMusicChannel.isPlaying)
                {
                    [gPlayMusicChannel Stop];
                }
                [gPlayMusicChannel Play];
            }
            
            self.bottomSubviewSwitcher.hidden = YES;
            self.adView.hidden = NO;
            break;
        case LIST_PLAYING:
            [self startClick];
            self.bottomSubviewSwitcher.hidden = YES;
            self.adView.hidden = NO;
            break;
        default:
            self.currentPlayingMode = STOP_PLAYING;
            break;
    }
    
    [self.loopAndPlayViewSubController ChangeButtonDisplayByPlayMode];

}
//
//  =========================




- (IBAction) closeWebAdEvent: (id) sender
{
    self.middleAdView.hidden = YES;
}
//
//  =========================

//  =========================
//  Play Function
//

- (void) ChangeToNextLoopCell
{
    // Change to next
    if (self.currentPlayingMode == LIST_PLAYING)
    {
        int NewIndex = self.currentSelectedCellIndex + 1;
        
        if (NewIndex >= self.engine.tempoCells.count)
        {
            if ([self.engine.currentTempoList.privateProperties.tempoListLoopingEnable boolValue])
            {
                NewIndex = 0;
                self.engine.listChangeFocusFlag = YES;
            }
            else
            {
                self.currentPlayingMode = STOP_PLAYING;
                return;
            }
        }

        [self stopClick];
        self.currentSelectedCellIndex = NewIndex;
        
        // jump to next cell when counter is 0.
        if ([self.engine.currentCell.loopCount intValue] == 0)
        {
            [self ChangeToNextLoopCell];
            return;
        }
        
        [self.loopAndPlayViewSubController ChangeSelectBarForcusIndex: NewIndex];
        
        [self startClick];
    }
}

- (void) resetCounter
{
    self.doesItNeedToChangeToNextCellAfterFinished = NO;
    self.engine.timeSignatureCounter = 0;
    self.engine.accentCounter = 0;
    self.engine.loopCountCounter = 0;

    self.engine.currentPlayingNoteCounter = NONE_CLICK;
}

- (void) stopClick
{
    if (self.engine.clickTimer != nil)
    {
        [self.engine.clickTimer invalidate];
        self.engine.clickTimer = nil;
    }
}

- (void) startClick
{
    // important!! when any values have been changed,
    // self.doesItNeedToRestartMetronome will be change to YES.
    self.doesItNeedToRestartMetronome = NO;

    if (self.engine.clickTimer != nil) {
        [self stopClick];
        [self resetCounter];
    }
    
    if (self.currentPlayingMode == LIST_PLAYING)
    {
        if (self.engine.loopCountCounter >= [self.engine.currentCell.loopCount intValue])
        {
            [self ChangeToNextLoopCell];
            // there will be no sound in last click period.
            return;
        }
    }
    
    if (self.engine.currentPlayingNoteCounter == NONE_CLICK)
    {
        self.engine.currentPlayingNoteCounter = FIRST_CLICK;
    }
    
    // This engine is using timer, and timer will wait untill time up then trigger it.
    // So here we need to play sound once before timer start.
    [self metronomeTicker: nil];
    
    float currentBPMValue = [self.engine.currentCell.bpmValue floatValue];
    
    if (self.cellParameterSettingSubController.BPMPicker.Mode == BPM_PICKER_INT_MODE)
    {
        self.engine.clickTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE(
                                                                ROUND_NO_DECOMAL_FROM_DOUBLE(currentBPMValue))
                                                          target:self
                                                        selector:@selector(metronomeTicker:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    else
    {
        self.engine.clickTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE(ROUND_ONE_DECOMAL_FROM_DOUBLE(currentBPMValue))
                                                          target:self
                                                        selector:@selector(metronomeTicker:)
                                                        userInfo:nil
                                                         repeats:YES];
    }

}

- (void) metronomeTicker: (NSTimer *) thisTimer
{
    if (self.currentPlayingMode == STOP_PLAYING)
    {
        [self resetCounter];
        [self stopClick];
        [thisTimer invalidate];
        return;
    }

    // 必須要完整的delay
    // 所以是最後一次跑完, 再進來才換.
    if(self.doesItNeedToChangeToNextCellAfterFinished)
    {
        self.doesItNeedToChangeToNextCellAfterFinished = NO;
        [self ChangeToNextLoopCell];
        [thisTimer invalidate];
        return;
    }
    
    // Play function
    [self.engine triggerMetronomeSounds];
    
    [self addMetronomeCounter];
    
    if ([self isLoopCounterIsLargerThenSetupValue])
    {
        self.doesItNeedToChangeToNextCellAfterFinished = YES;
    }
    
    [self restartClickIfBPMValueBeSetWhenPlaying];
}

- (void) addMetronomeCounter
{
    // Count script
    self.engine.currentPlayingNoteCounter++;
    
    if (self.engine.currentPlayingNoteCounter >= RESET_CLICK)
    {
        self.engine.currentPlayingNoteCounter = FIRST_CLICK;
        
        self.engine.timeSignatureCounter++;
        if (self.engine.timeSignatureCounter >= [self.globalServices.engine decodeTimeSignatureToValue: self.engine.currentTimeSignature])
        {
            self.engine.timeSignatureCounter = 0;
            if (self.currentPlayingMode >= LIST_PLAYING)
            {
                self.engine.loopCountCounter++;
            }
        }
    }
}

- (BOOL) isLoopCounterIsLargerThenSetupValue
{
    if (self.currentPlayingMode == LIST_PLAYING)
    {
        if (self.engine.loopCountCounter >= [self.engine.currentCell.loopCount intValue])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void) restartClickIfBPMValueBeSetWhenPlaying
{
    if(self.doesItNeedToRestartMetronome && self.currentPlayingMode != STOP_PLAYING)
    {
        [self stopClick];
        [self startClick];
    }
}

// ==============================
// controller property setting
// ==============================
- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

// UIInterfaceOrientationMask
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

// 一开始的屏幕旋转方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

// ======================
// bottom subview switch
// ======================

- (IBAction)bottomSwitchToVolumes:(id)sender {
    self.volumeBottomSubview.hidden = NO;
    self.musicSettingBottomSubview.hidden = YES;
    self.musicSpeedBottomSubview.hidden = YES;
}

- (IBAction)bottomSwitchToMusic:(id)sender {
    self.volumeBottomSubview.hidden = YES;
    self.musicSettingBottomSubview.hidden = NO;
    self.musicSpeedBottomSubview.hidden = YES;
}

- (IBAction)bottomSwitchToMusicSpeed:(id)sender {
    self.volumeBottomSubview.hidden = YES;
    self.musicSettingBottomSubview.hidden = YES;
    self.musicSpeedBottomSubview.hidden = NO;
}

// ======================
// Network function
// ======================
-(void) showWebAd {
    self.middleAdView.hidden = NO;
    [self.view bringSubviewToFront:self.middleAdView];
    self.webAdSubview.adImageView.image = [UIImage imageNamed:@"MusicListen"];
};

- (id) requirePostWebJson: (NSString *) url {
    __block id response = nil;
    
    if (self.networkManager == nil){
        return nil;
    }
    
    [self.networkManager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        response = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO : Error handler
        NSLog(@"requirePostWebJson failed");
    }];
    
    return response;
}

@end
