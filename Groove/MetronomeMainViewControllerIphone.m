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
    
    // Index
    int _FocusIndex;
    TempoCell *_CurrentCell;
    
    BOOL DeleteFillDataFlag;
    
    
    // LoopCellPlayingFlag
    BOOL PalyingLoopFlag;
    BOOL StartFlag;
    BOOL ChangeBPMValueFlag;
    
    // tmp
    NotesTool * NTool;
    int AccentCount;
    CURRENT_PLAYING_NOTE CurrentPlayingNote;
    NSTimer *PlaySoundTimer;


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
    
    [self InitailzieTools];
    
    [self InitializeFlagStatus];
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
    DeleteFillDataFlag = NO;
    PalyingLoopFlag = NO;
    StartFlag = NO;
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

- (void) SetFocusIndex:(int) NewValue
{
    if (NewValue < 0 || NewValue >= CurrentCellsDataTable.count)
    {
      return;
    }
    
    _FocusIndex = NewValue;
    _CurrentCell = CurrentCellsDataTable[_FocusIndex];
    
    self.TopSubView.BPMPicker.BPMValue = [_CurrentCell.bpmValue intValue];
    [self.TopSubView.TimeSignatureButton setTitle:_CurrentCell.timeSignatureType.timeSignature forState:UIControlStateNormal];
    
    if (DeleteFillDataFlag)
    {
        [self FillData];
        DeleteFillDataFlag = NO;
        self.BottomSubView.DeleteLoopCellButton.enabled = YES;
    }
}

- (void) ChangeSelectBarForcusIndex: (int) NewValue
{
    [self.BottomSubView ChangeSelectBarForcusIndex: NewValue];
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
- (void) SetBPMValue : (int) NewValue
{
    _CurrentCell.bpmValue = [NSNumber numberWithInt:NewValue];
    
    ChangeBPMValueFlag = YES;
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
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
    StartFlag = !StartFlag;
    if (StartFlag) {
        [self StartClick];
    }
    else {
        [self StopClickWithResetCounter : YES];
    }
}

- (IBAction) TapBPMValueButtonClick: (UIButton *) ThisClickedButton
{
    NSLog(@"TapBPMValueButtonClick");
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
    
    // 找到目前的
    TempoCell * CurrentCell = CurrentCellsDataTable[DeleteIndex];
    [gMetronomeModel DeleteTargetTempoCell:CurrentCell];
    
    // 重新顯示
    DeleteFillDataFlag = YES;
    self.BottomSubView.DeleteLoopCellButton.enabled = NO;
}

- (IBAction) PlayLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    [self PlayingLoopCellList:YES];

    NSLog(@"PlayLoopCellButtonClick");
}


- (void) FirstBeatFunc
{
    // Accent
    if ( AccentCount == 0 || AccentCount >= 4)
    {
        [gPlayUnit playSound: [_CurrentCell.accentVolume floatValue]/ MAX_VOLUME
                            : [self.CurrentVoice GetAccentVoice]];
        AccentCount = 0;
    }
    
    [gPlayUnit playSound: [_CurrentCell.quarterNoteVolume floatValue] / MAX_VOLUME
                        : [self.CurrentVoice GetFirstBeatVoice]];
    AccentCount++;
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

- (void) PlayingLoopCellList : (BOOL) PlayingStatus
{
    //
    
    // Change to next
    if (PlayingStatus)
    {
        int NewIndex = self.FocusIndex + 1;
        [self ChangeSelectBarForcusIndex: NewIndex];
    }
}



//Stop click
- (void) StopClickWithResetCounter : (BOOL) ResetFlag
{
    if (ResetFlag)
    {
        StartFlag = NO;
        AccentCount = 0;
        CurrentPlayingNote = NONE_CLICK;
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
    StartFlag = YES;
    if (PlaySoundTimer != nil) {
        [self StopClickWithResetCounter: YES];
    }
    
    PlaySoundTimer = [NSTimer scheduledTimerWithTimeInterval:BPM_TO_TIMER_VALUE([_CurrentCell.bpmValue intValue])
                                                      target:self
                                                    selector:@selector(MetronomeTicker:)
                                                    userInfo:nil
                                                     repeats:true];
}

- (void) MetronomeTicker: (NSTimer *) theTimer
{
    // Four Note family
    CurrentPlayingNote == LAST_CLICK ? (CurrentPlayingNote = FIRST_CLICK) : (CurrentPlayingNote++);

    
   [NotesTool NotesFunc:CurrentPlayingNote :NTool];
    
    if(ChangeBPMValueFlag)
    {
        ChangeBPMValueFlag = NO;
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
