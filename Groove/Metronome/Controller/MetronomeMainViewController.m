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
@property (readonly, getter=getCurrentCellFromTempoList) NSNumber *currentCellFromTempoList;
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
    
    // TODO: empty now
    //[self initLocalServices];
    
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
    
    // ===================
    // Setup music by model music info
    if (gPlayMusicChannel == nil){
        gPlayMusicChannel = [PlayerForSongs alloc];
    }
    
    if (self.engine.currentTempoList.musicInfo == nil){
        self.engine.currentTempoList.musicInfo = [gMetronomeModel CreateNewMusicInfo];
        [gMetronomeModel Save];
    }
    
    [self syncMusicInfoFromTempList];

    [self syncMusicPropertyFromGlobalConfig];
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
    CGRect fullViewFrame = self.view.frame;
    CGRect topViewFrame = self.topView.frame;
    CGRect bottomViewFrame = self.bottomView.frame;
    
    
    NSNumber * DeviceType = [GlobalConfig DeviceType];
    switch (DeviceType.intValue) {
        case IPHONE_4S:
            fullViewFrame = CGRectMake(fullViewFrame.origin.x
                                       , fullViewFrame.origin.y
                                       , fullViewFrame.size.width
                                       , IPHONE_4S_HEIGHT
                                       );
            
            topViewFrame = CGRectMake(topViewFrame.origin.x
                                      , topViewFrame.origin.y
                                      , topViewFrame.size.width
                                      , topViewFrame.size.height - (IPHONE_5S_HEIGHT - IPHONE_4S_HEIGHT)
                                      );
            bottomViewFrame = CGRectMake(bottomViewFrame.origin.x
                                         , bottomViewFrame.origin.y  - (IPHONE_5S_HEIGHT - IPHONE_4S_HEIGHT)
                                         , bottomViewFrame.size.width
                                         , bottomViewFrame.size.height
                                         );
            break;
        case IPHONE_5S:
            break;
        default:
            break;
    }
    
    self.view.frame = fullViewFrame;
    self.topView.frame = topViewFrame;
    self.bottomView.frame = bottomViewFrame;
}

- (void) initializeSubController
{
    self.adView.delegate = self;
    self.adView.hidden = YES;
}

- (void) initializeTopSubView
{
    if (self.topPartOfMetronomeViewController == nil){
        NSNumber * DeviceType = [GlobalConfig DeviceType];
        if (DeviceType.intValue == IPHONE_4S){
            self.topPartOfMetronomeViewController = [[TopPartOfMetronome4SVersionViewController alloc] initWithGlobalServices: self.globalServices];
        }else{
           self.topPartOfMetronomeViewController = [[TopPartOfMetronomeViewController alloc] initWithGlobalServices: self.globalServices];
        }
    }
    [self.topView addSubview:self.topPartOfMetronomeViewController.view];
    
}

- (void) initializeBottomSubView
{
    if (self.bottomPartOfVolumeViewController == nil){
        self.bottomPartOfVolumeViewController = [[BottomPartOfVolumeViewController alloc] initWithGlobalServices: self.globalServices];
    }
    [self.bottomView addSubview:self.bottomPartOfVolumeViewController.view];
    
    
    if (self.bottomPartOfMusicControlPanelViewController == nil){
        self.bottomPartOfMusicControlPanelViewController = [[BottomPartOfMusicControlPanelViewController alloc] init];
    }
    [self.bottomView addSubview:self.bottomPartOfMusicControlPanelViewController.view];
    
    if (self.bottomPartOfMusicSpeedViewController == nil){
        self.bottomPartOfMusicSpeedViewController = [[BottomPartOfMusicSpeedViewController alloc] init];
    }
    [self.bottomView addSubview:self.bottomPartOfMusicSpeedViewController.view];
    
    // 預設開 volumeBottomSubview
    [self chanegBottomPartOfPanel:BottomPartOfVolumePanel];
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
                                             selector:@selector(changePageToSystemView:)
                                                 name:kChangeToSystemPageView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changePageToMetronomeView:)
                                                 name:kChangeBackToMetronomeView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(voiceStopByInterrupt:)
                                                 name:kVoiceStopByInterrupt
                                               object:nil];
    
    // New
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setBPMValueCallback:)
                                                 name:kSetBPMValueNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCurrentCell:)
                                                 name:kChangeCurrentCell
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCellCounter:)
                                                 name:kChangeCellCounter
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteTargetIndexCell:)
                                                 name:kDeleteTargetIndexCell
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playCellListButtonClick:)
                                                 name:kPlayCellListButtonClick
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playCuttentCellButtonClick:)
                                                 name:kPlayCurrentCellButtonClick
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addLoopCellButtonClick:)
                                                 name:kAddLoopCellButtonClick
                                               object:nil];
}

// =============================
// notification callback
//
- (void) changePageToSystemView:(NSNotification *)Notification
{
    [self presentViewController:[self.globalServices getUIViewController:SYSTEMSETTING_PAGE] animated:YES completion:nil];
}

- (void) changePageToMetronomeView:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) voiceStopByInterrupt: (NSNotification *)notification
{
    self.currentPlayingMode = STOP_PLAYING;
}

- (void) setBPMValueCallback: (NSNotification *)notification
{
    if (self.currentPlayingMode != STOP_PLAYING){
        self.doesItNeedToRestartMetronome = YES;
    }
}

- (void) changeCurrentCell: (NSNotification *)notification
{
    int value = [((NSNumber *)notification.object) intValue];
    self.currentSelectedCellIndex = value;
}

- (void) changeCellCounter: (NSNotification *)notification{
    float value = [((NSNumber *)notification.object) floatValue];

    [self setTargetCellLoopCountAdd: self.currentSelectedCellIndex
                                                             Value: value];
}

-(void) deleteTargetIndexCell: (NSNotification *)notification
{
    [self DeleteTargetIndexCell:self.currentSelectedCellIndex];
}

- (void) playCellListButtonClick: (NSNotification *)notification
{
    if (self.currentPlayingMode == SINGLE_PLAYING){
        self.currentPlayingMode = STOP_PLAYING;
    }
    if (self.currentPlayingMode == STOP_PLAYING){
        self.currentPlayingMode = LIST_PLAYING;
    }
    else if(self.currentPlayingMode == LIST_PLAYING){
        self.currentPlayingMode = STOP_PLAYING;
    }
}

- (void) playCuttentCellButtonClick: (NSNotification *)notification
{
    
    if (self.currentPlayingMode == STOP_PLAYING){
        self.currentPlayingMode = SINGLE_PLAYING;
    }else if (self.currentPlayingMode == SINGLE_PLAYING)
    {
        self.currentPlayingMode = STOP_PLAYING;
    }
}

-(void) addLoopCellButtonClick: (NSNotification *)notification{
    // 新增一筆進資料庫
    [gMetronomeModel AddNewTempoCell: self.globalServices.engine.currentTempoList];
    
    // 重新顯示
    [self syncTempoListWithModel];
    
    [self syncTempoCellDatatableWithModel];
    
    TempoList * CurrentListCell = self.globalServices.engine.currentTempoList;
    
    // TODO : 嚴重 同步問題！！！
    CurrentListCell.focusCellIndex = [NSNumber numberWithInt:(int)(self.globalServices.engine.tempoCells.count - 1)];
    [gMetronomeModel Save];
    
    
    [self reflashCellListAndCurrentCellByCurrentData];
}

//
// =============================

// ============
//
// TODO : Model Sync
//

- (void) syncTempoListWithModel
{
    NSNumber *LastTempoListIndexUserSelected = [GlobalConfig GetLastTempoListIndexUserSelected];
    
    self.engine.currentTempoList =  [gMetronomeModel PickTargetTempoListFromDataTable:LastTempoListIndexUserSelected];
   
    if (self.engine.currentTempoList == nil){
        NSLog(@"嚴重錯誤: Last TempoList 同步錯誤 Error!!!");

        self.engine.currentTempoList = [gMetronomeModel PickTargetTempoListFromDataTable:@0];
        if (self.engine.currentTempoList == nil){
            NSLog(@"嚴重錯誤: TempoList 資料庫需要reset");
        }else{
            [GlobalConfig SetLastTempoListIndexUserSelected:0];
        }
    }
    
    if (self.engine.currentTempoList != nil){
        [self syncMetronomePrivateProperties];
    }
}

- (void) syncMetronomePrivateProperties
{
    if (self.engine.currentTempoList == nil){
        NSLog(@"Error: Using Error CurrentList is nil!!");
        [self syncTempoListWithModel];
        return;
    }
    
    if ([self.engine.currentTempoList.privateProperties.doubleValueEnable boolValue]) {
        self.topPartOfMetronomeViewController.bpmPickerViewController.Mode = BPM_PICKER_DOUBLE_MODE;
    }
    else {
        self.topPartOfMetronomeViewController.bpmPickerViewController.Mode = BPM_PICKER_INT_MODE;
    }
}

- (void) syncMusicPropertyFromGlobalConfig
{
    self.MusicProperties = [GlobalConfig GetMusicProperties];
    if (self.MusicProperties.MusicFunctionEnable) {
        self.topPartOfMetronomeViewController.playMusicButton.hidden = NO;
        self.topPartOfMetronomeViewController.playCellListButton.hidden = YES;
        
        // Sync music property
        if (self.MusicProperties.MusicHalfRateEnable){
            [gPlayMusicChannel SetPlayRateToHalf];
        }else{
            [gPlayMusicChannel SetPlayRateToNormal];
        }
        
        [gPlayMusicChannel SetPlayMusicLoopingEnable: self.MusicProperties.PlayMusicLoopingEnable];
    } else {
        self.topPartOfMetronomeViewController.playMusicButton.hidden = YES;
        self.topPartOfMetronomeViewController.playCellListButton.hidden = NO;
    }
}

- (void) syncMusicInfoFromTempList
{
    if (self.engine.currentTempoList.musicInfo.persistentID != nil){
        MPMediaItem *Item =  [gPlayMusicChannel GetFirstMPMediaItemFromPersistentID : self.engine.currentTempoList.musicInfo.persistentID ];
        if (![gPlayMusicChannel isPlaying]){
            [gPlayMusicChannel PrepareMusicToplay:Item];
        }
        gPlayMusicChannel.StartTime = [self.engine.currentTempoList.musicInfo.startTime floatValue];
        gPlayMusicChannel.StopTime = [self.engine.currentTempoList.musicInfo.endTime floatValue];
        gPlayMusicChannel.Volume = [self.engine.currentTempoList.musicInfo.volume floatValue];
    }
}

- (void) syncTempoCellDatatableWithModel
{
    if (self.engine.currentTempoList == nil){
        NSLog(@"錯誤: SyncCurrentFocusCellFromCurrentTempoList CurrentTempoList == nil");
        return;
    }

    self.engine.tempoCells = [gMetronomeModel FetchTempoCellFromTempoListWithSort:self.engine.currentTempoList];
    if (self.engine.tempoCells == nil){
        self.engine.tempoCells = gMetronomeModel.TempoListDataTable[0];
    }
}

- (NSNumber *) getCurrentCellFromTempoList
{
    if (self.engine.currentTempoList == nil){
        NSLog(@"錯誤: SyncCurrentFocusCellFromCurrentTempoList CurrentTempoList == nil");
        return @0;
    }
    
    NSNumber *lastFocusCellIndex = self.engine.currentTempoList.focusCellIndex;

    if (self.engine.tempoCells.count > [lastFocusCellIndex intValue]){
        return lastFocusCellIndex;
    }else{
        return @0;
    }
}

- (void) reflashCellListAndCurrentCellByCurrentData
{
    NSMutableArray *cellValueToStringList = [[NSMutableArray alloc]init];
    for (TempoCell *cell in self.engine.tempoCells) {
        [cellValueToStringList addObject:[NSString stringWithFormat:@"%d", [cell.loopCount intValue]]];
    }
    
    self.bottomPartOfVolumeViewController.grooveCellsSelector.GrooveCellValueStringList = cellValueToStringList;
    
    [self.bottomPartOfVolumeViewController.grooveCellsSelector displayUICellList: [self.currentCellFromTempoList intValue]];
}

//
// ============

// =========================
// property
//
- (int) getCurrentSelectedCellIndex
{
    if (_currentSelectedCellIndex >= self.engine.tempoCells.count){
        NSLog(@"Bug !! Controller _currentSelectedCellIndex over count error" );
        _currentSelectedCellIndex = (int)(self.engine.tempoCells.count -1);
    }else if (_currentSelectedCellIndex < 0){
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
        ){
      return;
    }else if (self.engine.listChangeFocusFlag){
        self.engine.listChangeFocusFlag = NO;
    }
    
    _currentSelectedCellIndex = newValue;
    
    // sync to Model
    self.engine.currentTempoList.focusCellIndex = [NSNumber numberWithInt:_currentSelectedCellIndex];
    [gMetronomeModel Save];
    
    self.engine.currentCell = self.engine.tempoCells[_currentSelectedCellIndex];
    
    // Set Volume Set
    [self.bottomPartOfVolumeViewController setVolumeBarVolume: self.engine.currentCell];
    
    // Set Voice
    self.engine.currentVoice = [self.globalServices.engine.clickVoiceList objectAtIndex:[self.engine.currentCell.voiceType.sortIndex intValue]];
    [self.topPartOfMetronomeViewController changeVoiceTypePickerImage:[self.engine.currentCell.voiceType.sortIndex intValue]];
    
    // Set TimeSignature
    self.engine.currentTimeSignature = self.engine.currentCell.timeSignatureType.timeSignature;
    [self.topPartOfMetronomeViewController.timeSigatureDisplayPickerButton setTitle:self.engine.currentTimeSignature forState:UIControlStateNormal];

    // Set LoopCount
    [self.topPartOfMetronomeViewController.loopCellEditorView.ValueScrollView SetValueWithoutDelegate:[self.engine.currentCell.loopCount intValue]];

    [self resetCounter];
}

- (METRONOME_PLAYING_MODE) getCurrentPlayingMode
{
    return _currentPlayingMode;
}

- (void) setCurrentPlayingMode : (METRONOME_PLAYING_MODE) newValue
{
    if (newValue == _currentPlayingMode){
        return;
    }
    
    _currentPlayingMode = newValue;
    
    switch (_currentPlayingMode) {
        case STOP_PLAYING:
            [self stopClick];
            [self resetCounter];

            if (self.MusicProperties.MusicFunctionEnable && self.MusicProperties.PlaySingleCellWithMusicEnable){
                if (gPlayMusicChannel.isPlaying){
                    [gPlayMusicChannel Stop];
                }
            }
            
            self.bottomSubviewSwitcher.hidden = NO;
            self.adView.hidden = YES;
            break;
        case SINGLE_PLAYING:
            [self startClick];
            if (self.MusicProperties.MusicFunctionEnable && self.MusicProperties.PlaySingleCellWithMusicEnable){
                if (gPlayMusicChannel.isPlaying){
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
    
    [self changeButtonDisplayByPlayMode];
}

- (void) changeButtonDisplayByPlayMode
{
    switch (self.currentPlayingMode) {
        case STOP_PLAYING:
            [self.bottomPartOfVolumeViewController.playCurrentCellButton setBackgroundImage:[UIImage imageNamed:@"PlayBlack"] forState:UIControlStateNormal];
            [self.topPartOfMetronomeViewController.playCellListButton setBackgroundImage:[UIImage imageNamed:@"PlayList"] forState:UIControlStateNormal];
            break;
        case SINGLE_PLAYING:
            [self.bottomPartOfVolumeViewController.playCurrentCellButton setBackgroundImage:[UIImage imageNamed:@"PlayRed"] forState:UIControlStateNormal];
            break;
        case LIST_PLAYING:
            // TODO : 要改成Stop圖
            [self.bottomPartOfVolumeViewController.playCurrentCellButton setBackgroundImage:[UIImage imageNamed:@"PlayRed"] forState:UIControlStateNormal];
            [self.topPartOfMetronomeViewController.playCellListButton setBackgroundImage:[UIImage imageNamed:@"PlayList_Red"] forState:UIControlStateNormal];
            break;
    }
}
//
//  =========================

//  =========================
//
//

- (IBAction) chanegBottomPartOfPanelAction: (UIBarButtonItem *)sender
{
    [self chanegBottomPartOfPanel: (__BottomPartOfMetronomePanel)sender.tag];
}

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
    if (self.currentPlayingMode == LIST_PLAYING){
        int newIndex = self.currentSelectedCellIndex + 1;
        
        if (newIndex >= self.engine.tempoCells.count){
            if ([self.engine.currentTempoList.privateProperties.tempoListLoopingEnable boolValue]){
                newIndex = 0;
                self.engine.listChangeFocusFlag = YES;
            }else{
                self.currentPlayingMode = STOP_PLAYING;
                return;
            }
        }

        [self stopClick];
        self.currentSelectedCellIndex = newIndex;
        
        // jump to next cell when counter is 0.
        if ([self.engine.currentCell.loopCount intValue] == 0){
            [self ChangeToNextLoopCell];
            return;
        }
        
        [self.bottomPartOfVolumeViewController.grooveCellsSelector ChangeFocusIndexWithUIMoving:newIndex];
        
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
    if (self.engine.clickTimer != nil){
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
    
    if (self.currentPlayingMode == LIST_PLAYING){
        if (self.engine.loopCountCounter >= [self.engine.currentCell.loopCount intValue]){
            [self ChangeToNextLoopCell];
            // there will be no sound in last click period.
            return;
        }
    }
    
    if (self.engine.currentPlayingNoteCounter == NONE_CLICK){
        self.engine.currentPlayingNoteCounter = FIRST_CLICK;
    }
    
    // This engine is using timer, and timer will wait untill time up then trigger it.
    // So here we need to play sound once before timer start.
    [self metronomeTicker: nil];
    
    float currentBPMValue = [self.engine.currentCell.bpmValue floatValue];
    
    if (self.topPartOfMetronomeViewController.bpmPickerViewController.Mode == BPM_PICKER_INT_MODE){
        self.engine.clickTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE(
                                                                ROUND_NO_DECOMAL_FROM_DOUBLE(currentBPMValue))
                                                          target:self
                                                        selector:@selector(metronomeTicker:)
                                                        userInfo:nil
                                                         repeats:YES];
    }else{
        self.engine.clickTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE(ROUND_ONE_DECOMAL_FROM_DOUBLE(currentBPMValue))
                                                          target:self
                                                        selector:@selector(metronomeTicker:)
                                                        userInfo:nil
                                                         repeats:YES];
    }

}

- (void) metronomeTicker: (NSTimer *) thisTimer
{
    if (self.currentPlayingMode == STOP_PLAYING){
        [self resetCounter];
        [self stopClick];
        [thisTimer invalidate];
        return;
    }

    // 必須要完整的delay
    // 所以是最後一次跑完, 再進來才換.
    if(self.doesItNeedToChangeToNextCellAfterFinished){
        self.doesItNeedToChangeToNextCellAfterFinished = NO;
        [self ChangeToNextLoopCell];
        [thisTimer invalidate];
        return;
    }
    
    // Play function
    [self.engine triggerMetronomeSounds];
    
    [self addMetronomeCounter];
    
    if ([self isLoopCounterIsLargerThenSetupValue]){
        self.doesItNeedToChangeToNextCellAfterFinished = YES;
    }
    
    [self restartClickIfBPMValueBeSetWhenPlaying];
}

- (void) addMetronomeCounter
{
    // Count script
    self.engine.currentPlayingNoteCounter++;
    
    if (self.engine.currentPlayingNoteCounter >= RESET_CLICK){
        self.engine.currentPlayingNoteCounter = FIRST_CLICK;
        
        self.engine.timeSignatureCounter++;
        if (self.engine.timeSignatureCounter >= [self.globalServices.engine decodeTimeSignatureToValue: self.engine.currentTimeSignature]){
            self.engine.timeSignatureCounter = 0;
            if (self.currentPlayingMode >= LIST_PLAYING){
                self.engine.loopCountCounter++;
            }
        }
    }
}

- (BOOL) isLoopCounterIsLargerThenSetupValue
{
    if (self.currentPlayingMode == LIST_PLAYING){
        if (self.engine.loopCountCounter >= [self.engine.currentCell.loopCount intValue]){
            return YES;
        }
    }
    
    return NO;
}

- (void) restartClickIfBPMValueBeSetWhenPlaying
{
    if(self.doesItNeedToRestartMetronome && self.currentPlayingMode != STOP_PLAYING){
        [self stopClick];
        [self startClick];
    }
}

// ==============================
// private methods
//
- (void) chanegBottomPartOfPanel: (__BottomPartOfMetronomePanel)pageNumber{
    switch (pageNumber) {
        case BottomPartOfVolumePanel:
            [self.bottomView bringSubviewToFront: self.bottomPartOfVolumeViewController.view];
            break;
        case BottomPartOfMusicControlPanel:
            [self.bottomView bringSubviewToFront: self.bottomPartOfMusicControlPanelViewController.view];
            break;
        case BottomPartOfMusicSpeedPanel:
            [self.bottomView bringSubviewToFront: self.bottomPartOfMusicSpeedViewController.view];
            break;
    }
}

- (void) setTargetCellLoopCountAdd: (int) Index Value:(int)NewValue
{
    TempoCell * TargetCell = self.engine.tempoCells[Index];
    
    
    if (NewValue < [[GlobalConfig TempoCellLoopCountMin] intValue]){
        NewValue = [[GlobalConfig TempoCellLoopCountMin] intValue];
    }else if (NewValue > [[GlobalConfig TempoCellLoopCountMax] intValue]){
        NewValue = [[GlobalConfig TempoCellLoopCountMax] intValue];
    }
    
    TargetCell.loopCount = [NSNumber numberWithInt:NewValue];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [self.bottomPartOfVolumeViewController.grooveCellsSelector.GrooveCellValueStringList replaceObjectAtIndex:Index withObject:[NSString stringWithFormat:@"%d", NewValue]];
    
    [self syncTempoListWithModel];
    
    [self syncTempoCellDatatableWithModel];
    
    [self reflashCellListAndCurrentCellByCurrentData];
    
}

- (void) DeleteTargetIndexCell: (int) CurrentFocusIndex
{
    // 不可以刪掉最後一個, 或大於Count > 或負數Index
    if ((self.engine.tempoCells.count <= 1 )
        || (self.engine.tempoCells.count <= self.currentSelectedCellIndex )
        || (self.currentSelectedCellIndex <0 )
        ){
        return;
    }
    
    // 找到要刪除的
    TempoCell *_deletedCell = self.engine.tempoCells[self.currentSelectedCellIndex];
    
    // 刪掉資料庫對應資料
    [gMetronomeModel DeleteTargetTempoCell:_deletedCell];
    _deletedCell = nil;
    
    // 重讀資料庫
    [self syncTempoListWithModel];
    
    [self syncTempoCellDatatableWithModel];
    
    // 如果刪掉的是最後一個
    // 向前移一個
    if (self.currentSelectedCellIndex >= self.engine.tempoCells.count){
        self.currentSelectedCellIndex = (int)(self.engine.tempoCells.count -1);
    }
    
    // TODO : 嚴重 同步問題！！！
    self.engine.currentTempoList.focusCellIndex = [NSNumber numberWithInt:self.currentSelectedCellIndex];
    [gMetronomeModel Save];
    // ================
    
    // 重新顯示
    [self reflashCellListAndCurrentCellByCurrentData];
}

//
// ==============================

// =================================
// iAD function

-(void) bannerViewWillLoadAd:(ADBannerView *)banner
{
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    // 廣告載入
    
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // 有錯誤會進來
}


-(BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // 使用者點了廣告後開啟畫面
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

//
// =================================

// ==============================
// controller property setting
//
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

//
// ==============================

// ======================
// Network function
//

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
