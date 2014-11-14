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
    NSArray * CurrentCellsDataTable;
    
    // Tap Fuction
    double _LastRecordTime_ms;
    NSDate * _Date;;
    NSTimer *ClearTapTimer;

    // Index
    int _FocusIndex;
    TempoCell *_CurrentCell;
    
    BOOL DeleteFillDataFlag;
    BOOL ChangeBPMValueFlag;

    
    // LoopCellPlayingFlag
    METRONOME_PLAYING_MODE _PlayingMode;
    
    // Tools
    NotesTool * NTool;
    
    // Loop
    NSTimer *PlaySoundTimer;
    
    // Loop Counter
    int _AccentCounter;
    CURRENT_PLAYING_NOTE _CurrentPlayingNoteCounter;
    int _LoopCountCounter;
    int _TimeSignatureCounter;
    BOOL ChangeToNextCellFlag;
    
    // PlayCell Image
    UIImage *_SinglePlayImage;
    UIImage *_RedPlayloopImage;
    UIImage *_BlackPlayloopImage;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//
//    }
//    return self;
//}

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

#if DEBUG_CLOSE
    NSLog(@"%@", self.FullView);
    NSLog(@"%@", self.TopView);
    NSLog(@"%@", self.BottomView);
#endif
    
    // Initalize Sub View
    [self InitializeTopSubView];
    
    [self InitializeBottomSubView];

    // Get Control UI form sub View and initialize default data
    [self InitlizeCellParameterControlItems];
    
    [self InitlizePlayingItems];
    
    [self InitializeLoopControlItem];
    
    [self FillData];
}

-(void) InitializeVolumeSets
{
    self.AccentCircleVolumeButton = self.BottomSubView.AccentCircleVolumeButton;
    self.QuarterCircleVolumeButton = self.BottomSubView.QuarterCircleVolumeButton;
    self.EighthNoteCircleVolumeButton = self.BottomSubView.EighthNoteCircleVolumeButton;
    self.SixteenthNoteCircleVolumeButton = self.BottomSubView.SixteenthNoteCircleVolumeButton;
    self.TrippleNoteCircleVolumeButton = self.BottomSubView.TrippleNoteCircleVolumeButton;
    
    self.AccentCircleVolumeButton.delegate = self;
    self.QuarterCircleVolumeButton.delegate = self;
    self.EighthNoteCircleVolumeButton.delegate = self;
    self.SixteenthNoteCircleVolumeButton.delegate = self;
    self.TrippleNoteCircleVolumeButton.delegate = self;
    
    CIRCLEBUTTON_RANGE VolumeRange;
    VolumeRange.MaxIndex = 10.0;
    VolumeRange.MinIndex = 0;
    VolumeRange.UnitValue = 0.1;
    
    self.AccentCircleVolumeButton.IndexRange = VolumeRange;
    self.AccentCircleVolumeButton.IndexValueSensitivity = 1;
    self.AccentCircleVolumeButton.tag = ACCENT_VOLUME_BUTTON;
    
    self.QuarterCircleVolumeButton.IndexRange = VolumeRange;
    self.QuarterCircleVolumeButton.IndexValueSensitivity = 1;
    self.QuarterCircleVolumeButton.tag = QUARTER_VOLUME_BUTTON;
    
    self.EighthNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.EighthNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.EighthNoteCircleVolumeButton.tag = EIGHTH_NOTE_VOLUME_BUTTON;
    
    self.SixteenthNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.SixteenthNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.SixteenthNoteCircleVolumeButton.tag = SIXTEENTH_NOTE_VOLUME_BUTTON;
    
    self.TrippleNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.TrippleNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.TrippleNoteCircleVolumeButton.tag = TRIPPLET_NOTE_VOLUME_BUTTON;
}

- (void) InitlizeCellParameterControlItems
{
    [self InitializeVolumeSets];
    
    self.BPMPicker = self.TopSubView.BPMPicker;
    self.VoiceTypeCircleButton = self.BottomSubView.VoiceTypeCircleButton;
    self.TimeSigaturePicker = self.TopSubView.TimeSigaturePicker;
    self.TapButton = self.TopSubView.TapButton;
    
    // BPM Picker Initialize
    self.BPMPicker.delegate = self;
    
    // VoiceType CircleButton initialize
    self.VoiceTypeCircleButton.delegate = self;
    CIRCLEBUTTON_RANGE VolumeRange;
    VolumeRange.MaxIndex = 10.0;
    VolumeRange.MinIndex = 0;
    VolumeRange.UnitValue = 1;
    
    self.VoiceTypeCircleButton.IndexRange = VolumeRange;
    self.VoiceTypeCircleButton.IndexValueSensitivity = 1;
    self.VoiceTypeCircleButton.IndexValue = 3;
    self.VoiceTypeCircleButton.tag = VOICE_TYPE_BUTTON;
    
    /*UIGraphicsBeginImageContext(self.VoiceButton.frame.size);
    [[UIImage imageNamed:@"Voice_Hi-Click"] drawInRect:self.VoiceButton.bounds];
    UIImage *VoiceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.VoiceButton.backgroundColor = [UIColor colorWithPatternImage:VoiceImage];*/
    
     // Time Signature
     UIGraphicsBeginImageContext(self.TimeSigaturePicker.frame.size);
     [[UIImage imageNamed:@"TimeSignature4_4"] drawInRect:self.TimeSigaturePicker.bounds];
     UIImage *TimeSignatureImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     self.TimeSigaturePicker.backgroundColor = [UIColor colorWithPatternImage:TimeSignatureImage];
    
    // Tap Button initialize
    UIGraphicsBeginImageContext(self.TapButton.frame.size);
    [[UIImage imageNamed:@"Tap"] drawInRect:self.TapButton.bounds];
    UIImage *TapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.TapButton.backgroundColor = [UIColor colorWithPatternImage:TapImage];
    
    [self.TapButton addTarget:self
                       action:@selector(TapBPMValueButtonClick:)forControlEvents:UIControlEventTouchDown];
}

- (void) InitlizePlayingItems
{
    self.PlayCurrentCellButton = self.TopSubView.PlayCurrentCellButton;
    self.PlayLoopCellButton = self.BottomSubView.PlayLoopCellButton;
    
    // PlayLoopCellButton Initalize
    // red  playloop button
    UIGraphicsBeginImageContext(self.PlayLoopCellButton.frame.size);
    [[UIImage imageNamed:@"LoopPlay_red"] drawInRect:self.PlayLoopCellButton.bounds];
    _RedPlayloopImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.PlayLoopCellButton.backgroundColor = [UIColor colorWithPatternImage:_RedPlayloopImage];
    
    // bloak  playloop button
    UIGraphicsBeginImageContext(self.PlayLoopCellButton.frame.size);
    [[UIImage imageNamed:@"LoopPlay_black"] drawInRect:self.PlayLoopCellButton.bounds];
    _BlackPlayloopImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Play Current cell button initialize
    UIGraphicsBeginImageContext(self.PlayCurrentCellButton.frame.size);
    [[UIImage imageNamed:@"SinglePlay"] drawInRect:self.PlayCurrentCellButton.bounds];
    _SinglePlayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];

    [self.PlayCurrentCellButton addTarget:self
                       action:@selector(PlayCurrentCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    
    // Play LoopCellButton Initialize
    [self.PlayLoopCellButton addTarget:self
                                   action:@selector(PlayLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
}

- (void) InitializeLoopControlItem
{
    self.SelectGrooveBar = self.BottomSubView.SelectGrooveBar;
    self.AddLoopCellButton = self.BottomSubView.AddLoopCellButton;
    
    [self.AddLoopCellButton addTarget:self
                                   action:@selector(AddLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    self.SelectGrooveBar.delegate = self;
}

- (void) InitializeSystemButton
{
    self.SystemButton = self.TopSubView.SystemButton;
    self.adView = self.BottomSubView.adView;
    
    self.adView.delegate = self;
}

- (void) InitailzieTools
{
    // 2. Initialize player
    [AudioPlay AudioPlayEnable];
    
    // 3. Initilize Click Voice
    [AudioPlay ResetClickVocieList];
    
    NTool = [[NotesTool alloc] init];
    NTool.delegate = self;
    
    self.CurrentVoice = [gClickVoiceList objectAtIndex:1];
}

- (void) InitializeFlagStatus
{
    _PlayingMode = STOP_PLAYING;
    _FocusIndex = -1;
    
    DeleteFillDataFlag = NO;
    ChangeBPMValueFlag = NO;
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
    CurrentCellsDataTable = [gMetronomeModel FetchTempoCellWhereListName:gMetronomeModel.TempoListDataTable[0]];
    
    [self CopyGrooveLoopListToSelectBar : CurrentCellsDataTable];
}

- (void) SetVolumeBarVolume : (TempoCell *)Cell
{
    self.AccentCircleVolumeButton.IndexValue = [Cell.accentVolume floatValue];
    self.QuarterCircleVolumeButton.IndexValue = [Cell.quarterNoteVolume floatValue];
    self.EighthNoteCircleVolumeButton.IndexValue = [Cell.eighthNoteVolume floatValue];
    self.SixteenthNoteCircleVolumeButton.IndexValue = [Cell.sixteenNoteVolume floatValue];
    self.TrippleNoteCircleVolumeButton.IndexValue = [Cell.trippleNoteVolume floatValue];
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
    NSLog(@"SetFocusIndex");
    if (NewValue < 0 || NewValue >= CurrentCellsDataTable.count || _FocusIndex == NewValue)
    {
      return;
    }
    
    _FocusIndex = NewValue;
    _CurrentCell = CurrentCellsDataTable[_FocusIndex];
    
    self.TopSubView.BPMPicker.BPMValue = [_CurrentCell.bpmValue intValue];
    [self SetVolumeBarVolume:_CurrentCell];
    
    // TODO: 要改成設圖
    //[self.BottomSubView.TimeSignatureButton setTitle:_CurrentCell.timeSignatureType.timeSignature forState:UIControlStateNormal];
    
    if (DeleteFillDataFlag)
    {
        [self FillData];
        DeleteFillDataFlag = NO;
        // TODO:
        //self.BottomSubView.DeleteLoopCellButton.enabled = YES;
    }
    
    if (self.PlayingMode == LOOP_PLAYING)
    {
        
        [self StopClickWithResetCounter: YES];
        [self StartClick];
    }
    
}

- (void) ChangeSelectBarForcusIndex: (int) NewValue
{
    self.SelectGrooveBar.FocusIndex = NewValue;
}


- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable
{
    NSMutableArray * GrooveLoopList = [[NSMutableArray alloc]init];
    for (TempoCell *Cell in CellDataTable)
    {
        [GrooveLoopList addObject:[Cell.loopCount stringValue]];
    }
    self.SelectGrooveBar.GrooveCellList = GrooveLoopList;
}


- (METRONOME_PLAYING_MODE) GetPlayingMode
{
    return _PlayingMode;
}

- (void) SetPlayingMode : (METRONOME_PLAYING_MODE) NewValue
{
    NSLog(@"SetPlayingMode %d", NewValue);
    
    if (NewValue == _PlayingMode)
    {
        return;
    }
    
    _PlayingMode = NewValue;
    
    switch (_PlayingMode) {
        case STOP_PLAYING:
            [self StopClickWithResetCounter : YES];
            self.PlayLoopCellButton.backgroundColor = [UIColor colorWithPatternImage:_RedPlayloopImage];
            self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
            break;
        case SINGLE_PLAYING:
            // TODO : 要改成Stop圖
            self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
            [self StartClick];
            break;
        case LOOP_PLAYING:
            self.PlayLoopCellButton.backgroundColor = [UIColor colorWithPatternImage:_BlackPlayloopImage];

            [self StartClick];
            break;
        default:
            self.PlayingMode = STOP_PLAYING;
            break;
    }

}
//
//  =========================


//  =========================
//
//
- (IBAction) ChangeToGrooveMainViewControllerIphone : (id) Button
{
    
    [self presentViewController:[GlobalConfig GrooveMainViewControllerIphone] animated:YES completion:nil];
}
//
//  =========================

//  =========================
// delegate
//
// 不會設下去到Bottom View UI
- (void) SetBPMValue : (int) NewValue
{
    _CurrentCell.bpmValue = [NSNumber numberWithInt:NewValue];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    if (self.PlayingMode != STOP_PLAYING)
    {
        ChangeBPMValueFlag = YES;
    }
}

- (IBAction) CircleButtonValueChanged:(CircleButton*) ThisCircleButton;
{
    float Value = ThisCircleButton.IndexValue;
    switch (ThisCircleButton.tag) {
        case ACCENT_VOLUME_BUTTON:
            _CurrentCell.accentVolume = [NSNumber numberWithFloat:Value];
            break;
        case QUARTER_VOLUME_BUTTON:
            _CurrentCell.quarterNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case EIGHTH_NOTE_VOLUME_BUTTON:
            _CurrentCell.eighthNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case SIXTEENTH_NOTE_VOLUME_BUTTON:
            _CurrentCell.sixteenNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case TRIPPLET_NOTE_VOLUME_BUTTON:
            _CurrentCell.trippleNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        default:
            break;
    }
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
}

- (IBAction) PlayCurrentCellButtonClick: (UIButton *) ThisClickedButton
{
    if (self.PlayingMode == STOP_PLAYING)
    {
        self.PlayingMode = SINGLE_PLAYING;
    }
    else if (self.PlayingMode == SINGLE_PLAYING)
    {
        self.PlayingMode = STOP_PLAYING;
    }
}

- (IBAction) TapBPMValueButtonClick: (UIButton *) ThisClickedButton
{
    NSLog(@"TapBPMValueButtonClick");
    
    if (_Date == nil)
    {
        _Date = [NSDate date];
    }
    
    if (ClearTapTimer != nil)
    {
        [ClearTapTimer invalidate];
        ClearTapTimer = nil;
    }
    ClearTapTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self
                                                    selector:@selector(ClearTapTicker:)
                                                    userInfo:nil
                                                     repeats:NO];
    if (_LastRecordTime_ms != 0)
    {
        double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
        int NewBPMvalue = 60000.f/(CurrentRecordTime_ms -_LastRecordTime_ms);
        self.TopSubView.BPMPicker.BPMValue = NewBPMvalue;
    }
    
    _LastRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
}

- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    // 新增一筆進資料庫
    [gMetronomeModel AddNewTempoCell];
    
    // 重新顯示
    [self FillData];
}

- (IBAction) DeleteLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    int DeleteIndex;
    int NewIndex;
    // 不可以刪掉最後一個
    if (CurrentCellsDataTable.count == 1 )
    {
        return;
    }
    
    DeleteIndex = self.FocusIndex;

    if (self.FocusIndex == 0)
    {
        NewIndex = self.FocusIndex +1 ;
    }
    else
    {
        NewIndex = self.FocusIndex -1 ;
    }
    [self ChangeSelectBarForcusIndex:NewIndex];
    
    // 找到要刪除的
    TempoCell * DeletedCell = CurrentCellsDataTable[DeleteIndex];
    [gMetronomeModel DeleteTargetTempoCell:DeletedCell];
    
    // 重新顯示
    DeleteFillDataFlag = YES;
    
    // TODO:
    //self.BottomSubView.DeleteLoopCellButton.enabled = NO;
}

- (IBAction) PlayLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    if (self.PlayingMode == SINGLE_PLAYING)
    {
        self.PlayingMode = STOP_PLAYING;        
        
        self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
    }
    
    if (self.PlayingMode == STOP_PLAYING)
    {
        self.PlayingMode = LOOP_PLAYING;
    }
    else if(self.PlayingMode == LOOP_PLAYING)
    {
        self.PlayingMode = STOP_PLAYING;
    }
    
}

- (void) FirstBeatFunc
{
    // Accent
    if ( _AccentCounter == 0 || _AccentCounter >= [self DecodeTimeSignatureToValue:_CurrentCell.timeSignatureType.timeSignature])
    {
        [gPlayUnit playSound: [_CurrentCell.accentVolume floatValue]/ MAX_VOLUME
                            : [self.CurrentVoice GetAccentVoice]];
        _AccentCounter = 0;
    }
    
    [gPlayUnit playSound: [_CurrentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetFirstBeatVoice]];
    _AccentCounter++;
}

- (void) EBeatFunc
{
    [gPlayUnit playSound: [_CurrentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetEbeatVoice]];
}

- (void) AndBeatFunc
{
    [gPlayUnit playSound: [_CurrentCell.eighthNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetAndBeatVoice]];
}

- (void) ABeatFunc
{
    [gPlayUnit playSound: [_CurrentCell.sixteenNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetEbeatVoice]];
}

- (void) GiBeatFunc
{
    [gPlayUnit playSound: [_CurrentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetGibeatVoice]];
}

- (void) GaBeatFunc
{
    [gPlayUnit playSound: [_CurrentCell.trippleNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetGabeatVoice]];
}
//
//  =========================

//  =========================
//  Play Function
//

- (void) PlayingLoopCellList
{
    // Change to next
    if (self.PlayingMode == LOOP_PLAYING)
    {
        ChangeToNextCellFlag = NO;
        int NewIndex = self.FocusIndex + 1;
        
        if (NewIndex >= CurrentCellsDataTable.count)
        {
            self.PlayingMode = STOP_PLAYING;
            return;
        }
        self.FocusIndex = NewIndex;
        [self ChangeSelectBarForcusIndex: NewIndex];
    }
}


//Stop click
- (void) StopClickWithResetCounter : (BOOL) ResetFlag
{
    NSLog(@"StopClickWithResetCounter : %d", ResetFlag);
    
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
    NSLog(@"StartClick");
    
    if (PlaySoundTimer != nil) {
        [self StopClickWithResetCounter: YES];
    }
    
    // 因為Timer的特性是先等再做
    // 所以必須要調整成先開始一次與最後多等一次
    [self MetronomeTicker: nil];
    
    PlaySoundTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE([_CurrentCell.bpmValue intValue])
                                                      target:self
                                                    selector:@selector(MetronomeTicker:)
                                                    userInfo:nil
                                                     repeats:true];
}

- (void) MetronomeTicker: (NSTimer *) theTimer
{
    // Loop_Playing mode only !!
    if (ChangeToNextCellFlag)
    {
        ChangeToNextCellFlag = NO;
        if (self.PlayingMode == LOOP_PLAYING)
        {
            [self PlayingLoopCellList];
        }
        return;
    }
    
    // Four Note family
    if (_CurrentPlayingNoteCounter == LAST_CLICK)
    {
        if (self.PlayingMode == LOOP_PLAYING)
        {
            _TimeSignatureCounter++;
            if (_TimeSignatureCounter == [self DecodeTimeSignatureToValue:_CurrentCell.timeSignatureType.timeSignature])
            {
                _TimeSignatureCounter = 0;
                _LoopCountCounter++;
                if (_LoopCountCounter == [_CurrentCell.loopCount intValue])
                {
                    _LoopCountCounter = 0;
                    ChangeToNextCellFlag = YES;
                    
                    // 最後一次只有delay
                    // 沒有聲音
                    return;
                }
            }
        }
        
        _CurrentPlayingNoteCounter = FIRST_CLICK;
    }
    else
    {
        _CurrentPlayingNoteCounter++;
    }
    
   [NotesTool NotesFunc:_CurrentPlayingNoteCounter :NTool];
    
    if(ChangeBPMValueFlag && theTimer != nil && self.PlayingMode != STOP_PLAYING)
    {
        ChangeBPMValueFlag = NO;
        [self StopClickWithResetCounter: NO];
        [self StartClick];
    }
}

- (void) ClearTapTicker: (NSTimer *) theTimer
{
    NSLog(@"Tap Clear");
    if (_Date != nil)	
    {
        _Date = nil;
    }
    _LastRecordTime_ms = 0;
    ClearTapTimer = nil;
}


- (int) DecodeTimeSignatureToValue : (NSString *)TimeSignatureString
{
    
    if ([TimeSignatureString isEqualToString:@"1/4"])
    {
        return 1;
    }
    else if ([TimeSignatureString isEqualToString:@"2/4"])
    {
        return 2;
    }
    else if ([TimeSignatureString isEqualToString:@"3/4"])
    {
        return 3;
    }
    else if ([TimeSignatureString isEqualToString:@"4/4"])
    {
        return 4;
    }
    else if ([TimeSignatureString isEqualToString:@"5/4"])
    {
        return 5;
    }
    else if ([TimeSignatureString isEqualToString:@"6/4"])
    {
        return 6;

    }
    else if ([TimeSignatureString isEqualToString:@"7/4"])
    {
        return 7;

    }
    else if ([TimeSignatureString isEqualToString:@"8/4"])
    {
        return 8;
    }
    
    return 4;
}


// =================================
// iAD function

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // 有錯誤會進來
}

- (void) bannerViewActionDidFinish:(ADBannerView *)banner
{
    // 使用者關掉廣告內容畫面
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    // 廣告載入
}

-(void) bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}

-(BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // 使用者點了廣告後開啟畫面
    return YES;
}


//
// =================================


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
