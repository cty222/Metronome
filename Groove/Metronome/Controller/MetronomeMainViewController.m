//
//  MetronomeMainViewControllerIphone.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeMainViewController.h"


@interface MetronomeMainViewController ()

@end

@implementation MetronomeMainViewController
{
    // Index
    int _FocusIndex;
    BOOL _IsDeleteUICellFinished;
    
    // LoopCellPlayingFlag
    METRONOME_PLAYING_MODE _PlayingMode;
    
    // Tools
    NotesTool * _NTool;
    
    
    // ========================
    // Loop
    NSTimer *PlaySoundTimer;
    
    // Loop Counter
    int _AccentCounter;
    CURRENT_PLAYING_NOTE _CurrentPlayingNoteCounter;
    int _LoopCountCounter;
    int _TimeSignatureCounter;
    BOOL _ListChangeFocusFlag;
    //
    // ========================

}

- (void) SyncMetronomeBehaviorPropertiesFromGlobalConfig
{
    self.MetronomeBehaviorProperties = [GlobalConfig GetMetronomeBehaviorProperties];
    if (self.MetronomeBehaviorProperties.BPMDoubleEnable)
    {
        _CellParameterSettingSubController.BPMPicker.Mode = BPM_PICKER_DOUBLE_MODE;
    }
    else
    {
        _CellParameterSettingSubController.BPMPicker.Mode = BPM_PICKER_INT_MODE;
    }
}

- (void) SyncMusicPropertyFromGlobalConfig
{
    self.MusicProperties = [GlobalConfig GetMusicProperties];
    if (self.MusicProperties.MusicFunctionEnable)
    {
        _LoopAndPlayViewSubController.PlayMusicButton.hidden = NO;
        _LoopAndPlayViewSubController.PlayCellListButton.hidden = YES;
        
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
        _LoopAndPlayViewSubController.PlayMusicButton.hidden = YES;
        _LoopAndPlayViewSubController.PlayCellListButton.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    // Metronomoe propeties will make BPM picker change
    [self SyncMetronomeBehaviorPropertiesFromGlobalConfig];
    
    [self SyncCurrentTempoListFromModel];
    
    [self SyncCurrentTempoCellDatatableWithModel];

    [self ReflashCellListAndFocusCellByCurrentData];
    
    if (self.CellParameterSettingSubController != nil)
    {
        [self.CellParameterSettingSubController MainViewWillAppear];
    }
    
    if (self.LoopAndPlayViewSubController != nil)
    {
        [self.LoopAndPlayViewSubController MainViewWillAppear];
    }
    
    if (self.SystemPageController != nil)
    {
        [self.SystemPageController MainViewWillAppear];
    }
    
    // ===================
    // Setup music by model music info
    if (gPlayMusicChannel == nil)
    {
        gPlayMusicChannel = [PlayerForSongs alloc];
    }
    
    if (self.CurrentTempoList.musicInfo == nil)
    {
        self.CurrentTempoList.musicInfo = [gMetronomeModel CreateNewMusicInfo];
        [gMetronomeModel Save];
    }
    
    if (self.CurrentTempoList.musicInfo.persistentID != nil)
    {
        MPMediaItem *Item =  [gPlayMusicChannel GetFirstMPMediaItemFromPersistentID : self.CurrentTempoList.musicInfo.persistentID ];
        if (![gPlayMusicChannel isPlaying])
        {
            [gPlayMusicChannel PrepareMusicToplay:Item];
        }
        gPlayMusicChannel.StartTime = [self.CurrentTempoList.musicInfo.startTime floatValue];
        gPlayMusicChannel.StopTime = [self.CurrentTempoList.musicInfo.endTime floatValue];
    }
    
    [self SyncMusicPropertyFromGlobalConfig];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.PlayingMode = STOP_PLAYING;
    [gPlayMusicChannel Stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self InitailzieTools];
    
    [self InitializeFlagStatus];
    
    // UI layout
    //
    
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
    
    // Initalize Sub View
    [self InitializeTopSubView];
    
    [self InitializeBottomSubView];

    // Get Control UI form sub View and initialize default data
    [self InitializeSubController];
    
    [self.CellParameterSettingSubController InitlizeCellParameterControlItems];
    
    [self.LoopAndPlayViewSubController InitlizePlayingItems];
    
    [self.LoopAndPlayViewSubController InitializeLoopControlItem];
   
    [self.SystemPageController InitializeSystemButton];
    
    
    [self GlobaleventInitialize];
    
}

- (void) GlobaleventInitialize
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TouchedNotificationCallBack:)
                                                 name:kTouchGlobalHookNotification
                                               object:nil];
    
    // Change View Controller
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePageToSystemView:)
                                                 name:kChangeToSystemPageView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePageToMetronomeView:)
                                                 name:kChangeBackToMetronomeView
                                               object:nil];
}

- (void) ChangePageToSystemView:(NSNotification *)Notification
{
    [self presentViewController:[GlobalConfig SystemPageViewController] animated:YES completion:nil];
}

- (void) ChangePageToMetronomeView:(NSNotification *)Notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TouchedNotificationCallBack:(NSNotification *)Notification
{
/*    UIEvent *Event = [Notification object];
    NSSet *touches = [Event allTouches];
    UITouch *touch = [touches anyObject];
    UIView * target = [touch view];*/
}

- (void) InitializeSubController
{
    self.CellParameterSettingSubController = [[CellParameterSettingControl alloc] init];
    self.CellParameterSettingSubController.ParrentController = self;
    
    self.LoopAndPlayViewSubController = [[LoopAndPlayViewControl alloc] init];
    self.LoopAndPlayViewSubController.ParrentController = self;
    
    self.SystemPageController = [[SystemPageControl alloc] init];
    self.SystemPageController.ParrentController = self;
}

- (void) InitailzieTools
{
    // 2. Initialize player
    [AudioPlay AudioPlayEnable];
    
    // 3. Initilize Click Voice
    [AudioPlay ResetClickVocieList];
    
    _NTool = [[NotesTool alloc] init];
    _NTool.delegate = self;
}

- (void) InitializeFlagStatus
{
    _PlayingMode = STOP_PLAYING;
    _FocusIndex = -1;
    
    self.ChangeBPMValueFlag = NO;
}

- (void) InitializeTopSubView
{
    if (self.TopSubView == nil)
    {
        self.TopSubView = [[MetronmoneTopSubViewIphone alloc] initWithFrame:self.TopView.frame];
    }
    if (self.TopView.subviews.count != 0)
    {
        [[self.TopView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.TopView addSubview:self.TopSubView];

}

- (void) InitializeBottomSubView
{
    if (self.BottomSubView == nil)
    {
        CGRect SubFrame = self.BottomView.frame;
        SubFrame.origin = CGPointMake(0, 0);
        
        self.BottomSubView = [[MetronomeBottomView alloc] initWithFrame:SubFrame];
    }
    if (self.BottomView.subviews.count != 0)
    {
        [[self.BottomView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    [self.BottomView addSubview:self.BottomSubView];
}

// ============
//
// TODO : Model Sync
//
- (void) SyncCurrentTempoListFromModel
{
    NSNumber *LastTempoListIndex = [GlobalConfig GetLastTempoListIndex];
    
    self.CurrentTempoList =  [gMetronomeModel PickTargetTempoListFromDataTable:LastTempoListIndex];
   
    if (self.CurrentTempoList == nil)
    {
        NSLog(@"嚴重錯誤: Last TempoList 同步錯誤 Error!!!");

        self.CurrentTempoList = [gMetronomeModel PickTargetTempoListFromDataTable:@0];
        if (self.CurrentTempoList == nil)
        {
            NSLog(@"嚴重錯誤: TempoList 資料庫需要reset");
        }
    }
}

- (void) SyncCurrentTempoCellDatatableWithModel
{
    if (self.CurrentTempoList == nil)
    {
        NSLog(@"錯誤: SyncCurrentFocusCellFromCurrentTempoList CurrentTempoList == nil");
        return;
    }

    self.CurrentCellsDataTable = [gMetronomeModel FetchTempoCellFromTempoListWithSort:self.CurrentTempoList];
    if (self.CurrentCellsDataTable == nil)
    {
        self.CurrentCellsDataTable = gMetronomeModel.TempoListDataTable[0];
    }
    
    NSLog(@"%@", self.CurrentCellsDataTable);
}

- (int) GetFocusCellWithCurrentTempoList
{
    if (self.CurrentTempoList == nil)
    {
        NSLog(@"錯誤: SyncCurrentFocusCellFromCurrentTempoList CurrentTempoList == nil");
        return 0;
    }
    
    NSNumber *LastFocusCellIndex = self.CurrentTempoList.focusCellIndex;

    if (self.CurrentCellsDataTable.count > [LastFocusCellIndex intValue])
    {
        return [LastFocusCellIndex intValue];
    }
    else
    {
        return 0;
    }
}

- (void) ReflashCellListAndFocusCellByCurrentData
{
    [self.LoopAndPlayViewSubController CopyCellListToSelectBar : self.CurrentCellsDataTable];
}


//
// ============

//  =========================
//  property
//
- (BOOL) GetIsDeleteUICellFinished
{
    return _IsDeleteUICellFinished;
}

-(void) SetIsDeleteUICellFinished: (BOOL)NewValue
{
    if (_IsDeleteUICellFinished == NewValue)
    {
        return;
    }
    
    _IsDeleteUICellFinished = NewValue;
}


- (int) GetFocusIndex
{
    if (_FocusIndex >= self.CurrentCellsDataTable.count)
    {
        NSLog(@"Bug !! Controller _FocusIndex over count error" );
        _FocusIndex = (int)(self.CurrentCellsDataTable.count -1);
    }
    else if (_FocusIndex < 0)
    {
        NSLog(@"Bug !! Controller _FocusIndex lower 0 error");
        _FocusIndex = 0;
        
    }
    return _FocusIndex;
}

// 不會設下去到Bottom View UI
- (void) SetFocusIndex:(int) NewValue
{
    if (NewValue < 0
        || NewValue >= self.CurrentCellsDataTable.count
        || (self.PlayingMode == LIST_PLAYING && NewValue == _FocusIndex && !_ListChangeFocusFlag)
        )
    {
      return;
    }
    else if (_ListChangeFocusFlag)
    {
        _ListChangeFocusFlag = NO;
    }
    
    _FocusIndex = NewValue;
    
    // 同步到 Model
    self.CurrentTempoList.focusCellIndex = [NSNumber numberWithInt:_FocusIndex];
    [gMetronomeModel Save];
    
    self.CurrentCell = self.CurrentCellsDataTable[_FocusIndex];
    
    // Set BPM
    self.TopSubView.BPMPicker.Value = [self.CurrentCell.bpmValue floatValue];
    
    // Set Volume Set
    [self.CellParameterSettingSubController SetVolumeBarVolume:self.CurrentCell];
    
    // Set Voice
    self.CurrentVoice = [gClickVoiceList objectAtIndex:[self.CurrentCell.voiceType.sortIndex intValue]];
    self.CurrentCell.voiceType = self.CurrentCell.voiceType;
    [_CellParameterSettingSubController ChangeVoiceTypePickerImage:[self.CurrentCell.voiceType.sortIndex intValue]];
    
    // Set TimeSignature
    self.CurrentTimeSignature = self.CurrentCell.timeSignatureType.timeSignature;
    [self.CellParameterSettingSubController.TimeSigaturePicker setTitle:self.CurrentTimeSignature forState:UIControlStateNormal];

    // Set LoopCount
    [_CellParameterSettingSubController.LoopCellEditerView.ValueScrollView SetValueWithoutDelegate:[self.CurrentCell.loopCount intValue]];

    
    [self ResetCounter];

}

- (METRONOME_PLAYING_MODE) GetPlayingMode
{
    return _PlayingMode;
}

- (void) SetPlayingMode : (METRONOME_PLAYING_MODE) NewValue
{
    if (NewValue == _PlayingMode)
    {
        return;
    }
    
    _PlayingMode = NewValue;
    
    switch (_PlayingMode) {
        case STOP_PLAYING:
            [self StopClick];
            [self ResetCounter];
            if (self.MusicProperties.MusicFunctionEnable && self.MusicProperties.PlaySingleCellWithMusicEnable)
            {
                if (gPlayMusicChannel.isPlaying)
                {
                    [gPlayMusicChannel Stop];
                }
            }
            break;
        case SINGLE_PLAYING:
            [self StartClick];
            if (self.MusicProperties.MusicFunctionEnable && self.MusicProperties.PlaySingleCellWithMusicEnable)
            {
                if (gPlayMusicChannel.isPlaying)
                {
                    [gPlayMusicChannel Stop];
                }
                [gPlayMusicChannel Play];
            }
            break;
        case LIST_PLAYING:
            [self StartClick];
            break;
        default:
            self.PlayingMode = STOP_PLAYING;
            break;
    }
    
    [self.LoopAndPlayViewSubController ChangeButtonDisplayByPlayMode];

}
//
//  =========================



//  =========================
// delegate
//
- (void) FirstBeatFunc
{
    // Accent
    if ( _AccentCounter == 0 || _AccentCounter >= [self.CellParameterSettingSubController DecodeTimeSignatureToValue:self.CurrentTimeSignature])
    {

        [gPlayUnit playSound: [self.CurrentCell.accentVolume floatValue]/ MAX_VOLUME
                            : [self.CurrentVoice GetAccentVoice]];
        if ([self.CurrentCell.accentVolume floatValue] > 0)
        {
            [_CellParameterSettingSubController.AccentCircleVolumeButton TwickLing];
        }
        _AccentCounter = 0;
    }
    
    [gPlayUnit playSound: [self.CurrentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetFirstBeatVoice]];
    if ([self.CurrentCell.quarterNoteVolume floatValue] > 0)
    {
        [_CellParameterSettingSubController.QuarterCircleVolumeButton TwickLing];
    }
    _AccentCounter++;
}

- (void) EBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetEbeatVoice]];
    if ([self.CurrentCell.sixteenNoteVolume floatValue] > 0)
    {
        [_CellParameterSettingSubController.SixteenthNoteCircleVolumeButton TwickLing];
    }
}

- (void) AndBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.eighthNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetAndBeatVoice]];
    if ([self.CurrentCell.eighthNoteVolume floatValue] > 0)
    {
        [_CellParameterSettingSubController.EighthNoteCircleVolumeButton TwickLing];
    }
}

- (void) ABeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetEbeatVoice]];
    if ([self.CurrentCell.sixteenNoteVolume floatValue] > 0)
    {
        [_CellParameterSettingSubController.SixteenthNoteCircleVolumeButton TwickLing];
    }
}

- (void) GiBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetGibeatVoice]];
    
    if ([self.CurrentCell.trippleNoteVolume floatValue] > 0)
    {
        [_CellParameterSettingSubController.TrippleNoteCircleVolumeButton TwickLing];
    }
}

- (void) GaBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetGabeatVoice]];
    if ([self.CurrentCell.trippleNoteVolume floatValue] > 0)
    {
        [_CellParameterSettingSubController.TrippleNoteCircleVolumeButton TwickLing];
    }
}
//
//  =========================

//  =========================
//  Play Function
//

- (void) ChangeToNextLoopCell
{
    // Change to next
    if (self.PlayingMode == LIST_PLAYING)
    {
        int NewIndex = self.FocusIndex + 1;
        
        if (NewIndex >= self.CurrentCellsDataTable.count)
        {
            if ([GlobalConfig PlayCellListNoneStop])
            {
                NewIndex = 0;
                _ListChangeFocusFlag = YES;
            }
            else
            {
                self.PlayingMode = STOP_PLAYING;
                return;
            }
        }

        [self StopClick];
        self.FocusIndex = NewIndex;
        
        // 如果Count是0就跳到下一個Cell
        if ([self.CurrentCell.loopCount intValue] == 0)
        {
            [self ChangeToNextLoopCell];
            return;
        }
        
        [self.LoopAndPlayViewSubController ChangeSelectBarForcusIndex: NewIndex];
        
        [self StartClick];
    }
}

- (void) ResetCounter
{
    _LoopCountCounter = 0;
    _TimeSignatureCounter = 0;
    _AccentCounter = 0;
    _CurrentPlayingNoteCounter = NONE_CLICK;
}

//Stop click
- (void) StopClick
{
    if (PlaySoundTimer != nil)
    {
        [PlaySoundTimer invalidate];
        PlaySoundTimer = nil;
    }
}

//Start click
- (void) StartClick
{
    if (PlaySoundTimer != nil) {
        [self StopClick];
        [self ResetCounter];
    }
    
    // 因為Timer的特性是先等再做
    // 所以必須要調整成先開始一次與最後多等一次
    if (self.PlayingMode == LIST_PLAYING)
    {
        if (_LoopCountCounter >= [self.CurrentCell.loopCount intValue])
        {
            [self ChangeToNextLoopCell];
            // 最後一次只有delay
            // 沒有聲音
            return;
        }
    }
    
    if (_CurrentPlayingNoteCounter == NONE_CLICK)
    {
        _CurrentPlayingNoteCounter = FIRST_CLICK;
    }
    
    [self MetronomeTicker: nil];
    
    PlaySoundTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE([self.CurrentCell.bpmValue floatValue])
                                                      target:self
                                                    selector:@selector(MetronomeTicker:)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void) MetronomeTicker: (NSTimer *) ThisTimer
{
    if (self.PlayingMode == STOP_PLAYING)
    {
        [self ResetCounter];
        [self StopClick];
        [ThisTimer invalidate];
    }
    
    [NotesTool NotesFunc:_CurrentPlayingNoteCounter :_NTool];
    _CurrentPlayingNoteCounter++;
    
    if (_CurrentPlayingNoteCounter == RESET_CLICK)
    {
        _CurrentPlayingNoteCounter = FIRST_CLICK;
        
        if (self.PlayingMode == LIST_PLAYING)
        {
            _TimeSignatureCounter++;
            if (_TimeSignatureCounter == [self.CellParameterSettingSubController DecodeTimeSignatureToValue:self.CurrentTimeSignature])
            {
                _TimeSignatureCounter = 0;
                _LoopCountCounter++;
                if (_LoopCountCounter >= [self.CurrentCell.loopCount intValue])
                {
                    [self ChangeToNextLoopCell];
                    return;
                }
            }
        }
    }
    
    if(self.ChangeBPMValueFlag && ThisTimer != nil && self.PlayingMode != STOP_PLAYING)
    {
        self.ChangeBPMValueFlag = NO;
        [self StopClick];
        [self StartClick];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
