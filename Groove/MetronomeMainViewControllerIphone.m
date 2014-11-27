//
//  MetronomeMainViewControllerIphone.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeMainViewControllerIphone.h"


@interface MetronomeMainViewControllerIphone ()

@end

@implementation MetronomeMainViewControllerIphone
{
    // Index
    int _FocusIndex;
    
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
    //
    // ========================

    
    // Sub Controller
    CellParameterSettingControl * _CellParameterSettingSubController;
    LoopAndPlayViewControl * _LoopAndPlayViewSubController;
    SystemPageControl * _SystemPageController;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    
    [_CellParameterSettingSubController InitlizeCellParameterControlItems];
    
    [_LoopAndPlayViewSubController InitlizePlayingItems];
    
    [_LoopAndPlayViewSubController InitializeLoopControlItem];
   
    [_SystemPageController InitializeSystemButton];
    
    [self GlobaleventInitialize];
    
    [self FillData];

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
                                                 name:kChangeToMetronomeView
                                               object:nil];
}

- (void) ChangePageToSystemView:(NSNotification *)Notification
{
    [self presentViewController:[GlobalConfig SystemPageViewControllerIphone] animated:YES completion:nil];
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
    _CellParameterSettingSubController = [[CellParameterSettingControl alloc] init];
    _CellParameterSettingSubController.ParrentController = self;
    
    _LoopAndPlayViewSubController = [[LoopAndPlayViewControl alloc] init];
    _LoopAndPlayViewSubController.ParrentController = self;
    
    _SystemPageController = [[SystemPageControl alloc] init];
    _SystemPageController.ParrentController = self;
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
        
        self.BottomSubView = [[MetronomeBottomSubViewIphone alloc] initWithFrame:SubFrame];
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
// TODO : Testing
//
- (void) FillData
{
    self.CurrentCellsDataTable = [gMetronomeModel FetchTempoCellWhereListName:gMetronomeModel.TempoListDataTable[0]];
    
    [_LoopAndPlayViewSubController CopyGrooveLoopListToSelectBar : self.CurrentCellsDataTable];
}


//
// ============

//  =========================
//  property
//  
- (int) GetFocusIndex
{
    return _FocusIndex;
}

// 不會設下去到Bottom View UI
- (void) SetFocusIndex:(int) NewValue
{
    if (NewValue < 0 || NewValue >= self.CurrentCellsDataTable.count || _FocusIndex == NewValue)
    {
      return;
    }
    
    _FocusIndex = NewValue;
    self.CurrentCell = self.CurrentCellsDataTable[_FocusIndex];
    
    self.TopSubView.BPMPicker.BPMValue = [self.CurrentCell.bpmValue intValue];
    [_CellParameterSettingSubController SetVolumeBarVolume:self.CurrentCell];
    self.CurrentVoice = [gClickVoiceList objectAtIndex:1];

    // TODO: 要改成設圖
    //[self.BottomSubView.TimeSignatureButton setTitle:_CurrentCell.timeSignatureType.timeSignature forState:UIControlStateNormal];
    

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
            [self StopClickWithResetCounter : YES];
            break;
        case SINGLE_PLAYING:
            // TODO : 要改成Stop圖
            [self StartClick];
            break;
        case LOOP_PLAYING:
            [self StartClick];
            break;
        default:
            self.PlayingMode = STOP_PLAYING;
            break;
    }
    
    [_LoopAndPlayViewSubController ChangeButtonDisplayByPlayMode];

}
//
//  =========================



//  =========================
// delegate
//
- (void) FirstBeatFunc
{
    // Accent
    if ( _AccentCounter == 0 || _AccentCounter >= [_CellParameterSettingSubController DecodeTimeSignatureToValue:self.CurrentCell.timeSignatureType.timeSignature])
    {
        [gPlayUnit playSound: [self.CurrentCell.accentVolume floatValue]/ MAX_VOLUME
                            : [self.CurrentVoice GetAccentVoice]];
        _AccentCounter = 0;
    }
    
    [gPlayUnit playSound: [self.CurrentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetFirstBeatVoice]];
    _AccentCounter++;
}

- (void) EBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetEbeatVoice]];
}

- (void) AndBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.eighthNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetAndBeatVoice]];
}

- (void) ABeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetEbeatVoice]];
}

- (void) GiBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetGibeatVoice]];
}

- (void) GaBeatFunc
{
    [gPlayUnit playSound: [self.CurrentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetGabeatVoice]];
}
//
//  =========================

//  =========================
//  Play Function
//

- (void) ChangeToNextLoopCell
{
    // Change to next
    if (self.PlayingMode == LOOP_PLAYING)
    {
        int NewIndex = self.FocusIndex + 1;
        
        if (NewIndex >= self.CurrentCellsDataTable.count)
        {
            self.PlayingMode = STOP_PLAYING;
            return;
        }

        [self StopClickWithResetCounter: YES];
        self.FocusIndex = NewIndex;
        
        // 如果Count是0就跳到下一個Cell
        if ([self.CurrentCell.loopCount intValue] == 0)
        {
            [self ChangeToNextLoopCell];
            return;
        }
        
        [_LoopAndPlayViewSubController ChangeSelectBarForcusIndex: NewIndex];
        
        [self StartClick];
    }
}


//Stop click
- (void) StopClickWithResetCounter : (BOOL) ResetFlag
{
    if (ResetFlag)
    {
        _LoopCountCounter = 0;
        _TimeSignatureCounter = 0;
        _AccentCounter = 0;
        _CurrentPlayingNoteCounter = NONE_CLICK;
    }
    
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
        [self StopClickWithResetCounter: YES];
    }
    
    // 因為Timer的特性是先等再做
    // 所以必須要調整成先開始一次與最後多等一次
    if (self.PlayingMode == LOOP_PLAYING)
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
    
    PlaySoundTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE([self.CurrentCell.bpmValue intValue])
                                                      target:self
                                                    selector:@selector(MetronomeTicker:)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void) MetronomeTicker: (NSTimer *) ThisTimer
{
    if (self.PlayingMode == STOP_PLAYING)
    {
        [self StopClickWithResetCounter: YES];
        [ThisTimer invalidate];
    }
    
    [NotesTool NotesFunc:_CurrentPlayingNoteCounter :_NTool];
    _CurrentPlayingNoteCounter++;
    
    if (_CurrentPlayingNoteCounter == RESET_CLICK)
    {
        _CurrentPlayingNoteCounter = FIRST_CLICK;
        
        if (self.PlayingMode == LOOP_PLAYING)
        {
            _TimeSignatureCounter++;
            if (_TimeSignatureCounter == [_CellParameterSettingSubController DecodeTimeSignatureToValue:self.CurrentCell.timeSignatureType.timeSignature])
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
        [self StopClickWithResetCounter: NO];
        [self StartClick];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
