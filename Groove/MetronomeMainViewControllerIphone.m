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
    
    [self InitializeTopSubView];
    
    [self InitializeBottomSubView];

    [self FillData];
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
        self.TopSubView.delegate = self;
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

    self.BottomSubView.delegate = self;
    [self.BottomView addSubview:self.BottomSubView];
}

// ============
//
// TODO : Testing
//
- (void) FillData
{
    CurrentCellsDataTable = [gMetronomeModel FetchTempoCellWhereListName:gMetronomeModel.TempoListDataTable[0]];
    self.BottomSubView.CurrentDataTable = CurrentCellsDataTable;
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
    [self.BottomSubView.TimeSignatureButton setTitle:_CurrentCell.timeSignatureType.timeSignature forState:UIControlStateNormal];
    
    if (DeleteFillDataFlag)
    {
        [self FillData];
        DeleteFillDataFlag = NO;
        self.BottomSubView.DeleteLoopCellButton.enabled = YES;
    }
    
    if (self.PlayingMode == LOOP_PLAYING)
    {
        
        [self StopClickWithResetCounter: YES];
        [self StartClick];
    }
    
}

- (void) ChangeSelectBarForcusIndex: (int) NewValue
{
    [self.BottomSubView ChangeSelectBarForcusIndex: NewValue];
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
            [self.BottomSubView.PlayLoopCellButton setTitle:@"PlayLoop" forState:UIControlStateNormal];
            [self.BottomSubView.PlayCurrentCellButton setTitle:@"Play" forState:UIControlStateNormal];
            break;
        case SINGLE_PLAYING:
            [self.BottomSubView.PlayCurrentCellButton setTitle:@"Stop" forState:UIControlStateNormal];
            [self StartClick];
            break;
        case LOOP_PLAYING:
            [self.BottomSubView.PlayLoopCellButton setTitle:@"StopLoop" forState:UIControlStateNormal];
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

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *Touch =  [touches anyObject];
    if ([NSStringFromClass([Touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [BPMPicker TouchBeginEvent:OriginalLocation];
    }
    else if ([NSStringFromClass([Touch.view class]) isEqualToString:@"MetronomeSelectBar"])
    {
        MetronomeSelectBar* ScrollView = (MetronomeSelectBar *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [ScrollView TouchBeginEvent:OriginalLocation];
    }
    else
    {
        NSLog(@"%@", Touch);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *Touch =  [touches anyObject];
    if ([NSStringFromClass([Touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [BPMPicker TouchEndEvent:OriginalLocation];
    }
    else if ([NSStringFromClass([Touch.view class]) isEqualToString:@"MetronomeSelectBar"])
    {
        MetronomeSelectBar* ScrollView = (MetronomeSelectBar *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [ScrollView TouchEndEvent:OriginalLocation];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *Touch =  [touches anyObject];
    if ([NSStringFromClass([Touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [BPMPicker TouchMoveEvent:OriginalLocation];
    }
    else if ([NSStringFromClass([Touch.view class]) isEqualToString:@"MetronomeSelectBar"])
    {
        MetronomeSelectBar* ScrollView = (MetronomeSelectBar *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [ScrollView TouchMoveEvent:OriginalLocation];
    }
}

 -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *Touch =  [touches anyObject];
    if ([NSStringFromClass([Touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [BPMPicker TouchCancellEvent:OriginalLocation];
    }
    else if ([NSStringFromClass([Touch.view class]) isEqualToString:@"MetronomeSelectBar"])
    {
        MetronomeSelectBar* ScrollView = (MetronomeSelectBar *)Touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [Touch locationInView:Touch.view];
        [ScrollView TouchCancellEvent:OriginalLocation];
    }
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

- (IBAction) VolumeSliderValueChanged:(TmpVerticalSlider*) ThisVerticalSlider
{
    
    float Value = ThisVerticalSlider.value;
    int TagNumber = ThisVerticalSlider.SliderTag;

    switch (TagNumber) {
        case 0:
            _CurrentCell.accentVolume = [NSNumber numberWithFloat:Value];
            break;
        case 1:
            _CurrentCell.quarterNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case 2:
            _CurrentCell.eighthNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case 3:
            _CurrentCell.sixteenNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case 4:
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
    self.BottomSubView.DeleteLoopCellButton.enabled = NO;
}

- (IBAction) PlayLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    if (self.PlayingMode == SINGLE_PLAYING)
    {
        self.PlayingMode = STOP_PLAYING;
        [self.BottomSubView.PlayCurrentCellButton setTitle:@"Play" forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
