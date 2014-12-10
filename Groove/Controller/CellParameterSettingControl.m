//
//  CellParameterSettingControl.m
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "CellParameterSettingControl.h"

// Private property
@interface CellParameterSettingControl ()

// Tap Trigger ounter
@property (getter = GetTapTriggerCounter, setter = SetTapTriggerCounter:) int TapTriggerCounter;

@end

@implementation CellParameterSettingControl
{
    // Tap Fuction
    double _LastRecordTime_ms;
    NSDate * _Date;;
    int _TapTriggerCounter;
}

-(void) InitializeVolumeSets
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    self.AccentCircleVolumeButton = Parent.BottomSubView.AccentCircleVolumeButton;
    self.QuarterCircleVolumeButton = Parent.BottomSubView.QuarterCircleVolumeButton;
    self.EighthNoteCircleVolumeButton = Parent.BottomSubView.EighthNoteCircleVolumeButton;
    self.SixteenthNoteCircleVolumeButton = Parent.BottomSubView.SixteenthNoteCircleVolumeButton;
    self.TrippleNoteCircleVolumeButton = Parent.BottomSubView.TrippleNoteCircleVolumeButton;
    
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
    
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    self.BPMPicker = Parent.TopSubView.BPMPicker;
    self.OptionScrollView = Parent.TopSubView.OptionScrollView;
    self.VoiceTypePicker = Parent.TopSubView.VoiceTypePicker;
    self.TimeSigaturePicker = Parent.TopSubView.TimeSigaturePicker;
    self.LoopCellEditer = Parent.TopSubView.LoopCellEditer;
    self.TapAlertImage = Parent.TopSubView.TapAlertImage;
    self.TimeSignaturePickerView = Parent.TopSubView.TimeSignaturePickerView;
    self.VoiceTypePickerView = Parent.TopSubView.VoiceTypePickerView;
    self.LoopCellEditerView = Parent.TopSubView.LoopCellEditerView;

    // BPM Picker Initialize
    self.BPMPicker.delegate = self;
    
    
    //VoiceTypePicker
    [self InitilaizeVoiceTypePickerView];
    [self.VoiceTypePicker addTarget:self
                               action:@selector(VoiceTypePickerDisplay:) forControlEvents:UIControlEventTouchDown];
    
    // Time Signature
    [self InitilaizeTimeSignaturePickerView];
    [self.TimeSigaturePicker addTarget:self
                             action:@selector(TimeSigaturePickerDisplay:) forControlEvents:UIControlEventTouchDown];
    

    // LoopCellEditer
    [self InitilaizeLoopCellEditerView];
    [self.LoopCellEditer addTarget:self
                                action:@selector(LoopCellEditerDisplay:) forControlEvents:UIControlEventTouchDown];


   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TouchedNotificationCallBack:)
                                                 name:kTouchGlobalHookNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TapResetNotificationCallBack:)
                                                 name:kTapResetNotification
                                               object:nil];
    

}

- (void) InitilaizeVoiceTypePickerView
{
    NSArray *VoiceTypeArray = [gMetronomeModel FetchVoiceType];
    self.VoiceTypePickerView.OriginYOffset = self.OptionScrollView.frame.origin.y - self.VoiceTypePickerView.frame.origin.y;
    self.VoiceTypePickerView.ArrowCenterLine = self.VoiceTypePicker.frame.origin.y + self.VoiceTypePicker.frame.size.height/2 - self.OptionScrollView.contentOffset.y;
    self.VoiceTypePickerView.TriggerButton = self.VoiceTypePicker;
    self.VoiceTypePickerView.delegate = self;
    
    [self.VoiceTypePickerView DisplayPropertyCell:VoiceTypeArray : self.VoiceTypePicker];
}


- (void) InitilaizeTimeSignaturePickerView
{
    // If nil, create data view
    NSArray *TimeSignatureTypeArray = [gMetronomeModel FetchTimeSignatureType];
    self.TimeSignaturePickerView.OriginYOffset = self.OptionScrollView.frame.origin.y - self.TimeSignaturePickerView.frame.origin.y;
    self.TimeSignaturePickerView.ArrowCenterLine = self.TimeSigaturePicker.frame.origin.y + self.TimeSigaturePicker.frame.size.height/2 - self.OptionScrollView.contentOffset.y;
    self.TimeSignaturePickerView.TriggerButton = self.TimeSigaturePicker;
    self.TimeSignaturePickerView.delegate = self;
    
    [self.TimeSignaturePickerView DisplayPropertyCell:TimeSignatureTypeArray : self.TimeSigaturePicker];
    
}

- (void) InitilaizeLoopCellEditerView
{
    self.LoopCellEditerView.OriginYOffset = self.OptionScrollView.frame.origin.y - self.TimeSignaturePickerView.frame.origin.y;
    self.LoopCellEditerView.ArrowCenterLine = self.LoopCellEditer.frame.origin.y + self.LoopCellEditer.frame.size.height/2 - self.OptionScrollView.contentOffset.y;
    self.LoopCellEditerView.TriggerButton = self.LoopCellEditer;
    self.LoopCellEditerView.delegate = self;
    
    
    // ValueScrollView
    self.LoopCellEditerView.ValueScrollView.MaxLimit  = [[GlobalConfig LoopValueMax] intValue];
    self.LoopCellEditerView.ValueScrollView.MinLimit  = [[GlobalConfig LoopValueMin] intValue];
    
}

-(IBAction) VoiceTypePickerDisplay:(UIView *)sender
{
    self.VoiceTypePickerView.hidden = !self.VoiceTypePickerView.hidden;
}


-(IBAction) TimeSigaturePickerDisplay:(UIView *)sender
{
    self.TimeSignaturePickerView.hidden = !self.TimeSignaturePickerView.hidden;
}


-(IBAction) LoopCellEditerDisplay:(UIButton *)sender
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    TempoCell * TargetCell = Parent.CurrentCellsDataTable[Parent.FocusIndex];
    self.LoopCellEditerView.ValueScrollView.Value =  [TargetCell.loopCount intValue];
    
    self.LoopCellEditerView.hidden = !self.LoopCellEditerView.hidden;
}

- (IBAction) ChangeVoiceType:(UIButton *)TriggerItem
{
    NSArray *VoiceTypeArray = [gMetronomeModel FetchVoiceType];

    if (gClickVoiceList.count <= TriggerItem.tag || VoiceTypeArray.count <= TriggerItem.tag)
    {
        return;
    }
    
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    // Because 0 is no voice
    NSInteger VoiceIndex = TriggerItem.tag;
    Parent.CurrentVoice = [gClickVoiceList objectAtIndex:VoiceIndex];
    Parent.CurrentCell.voiceType = (VoiceType *)VoiceTypeArray[TriggerItem.tag];
    
    [self.VoiceTypePicker setBackgroundImage:[TriggerItem backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];

    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
}

- (void) ChangeVoiceTypePickerImage: (int) TagNumber
{
    UIButton * TriggerItem = [self.VoiceTypePickerView ReturnTargetButton:TagNumber];
    if (TriggerItem != nil)
    {
        [self.VoiceTypePicker setBackgroundImage:[TriggerItem backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    }
}

- (IBAction)ChangeValue: (id)RootSuperView : (UIButton *) ChooseCell;
{
    if (RootSuperView == self.VoiceTypePickerView)
    {
        [self ChangeVoiceType: ChooseCell];
    }
    else if (RootSuperView == self.TimeSignaturePickerView)
    {
        [self ChangeTimeSignature: ChooseCell];
    }
    else if (RootSuperView == self.LoopCellEditerView)
    {
        [self ChangeCellCounter: ChooseCell];
    }
    
}

- (IBAction) ChangeTimeSignature:(UIButton *)TriggerItem
{
    NSArray *TimeSignatureTypeArray = [gMetronomeModel FetchTimeSignatureType];
    
    if (TimeSignatureTypeArray.count <= TriggerItem.tag)
    {
        return;
    }
    
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    Parent.CurrentCell.timeSignatureType = (TimeSignatureType *)TimeSignatureTypeArray[TriggerItem.tag];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [self.TimeSigaturePicker setTitle:TriggerItem.titleLabel.text forState:UIControlStateNormal];
}

- (IBAction) ChangeCellCounter:(id)TriggerItem
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    if (self.LoopCellEditerView.ValueScrollView == TriggerItem)
    {
        [Parent.LoopAndPlayViewSubController SetTargetCellLoopCountAdd:Parent.FocusIndex
                                                                 Value:self.LoopCellEditerView.ValueScrollView.Value];
    }
    else if (self.LoopCellEditerView.CellDeleteButton == TriggerItem)
    {
        [Parent.LoopAndPlayViewSubController DeleteTargetIndexCell:Parent.FocusIndex];
    }
}

- (void)TouchedNotificationCallBack:(NSNotification *)Notification
{
   /*UIEvent *Event = [Notification object];
    NSSet *touches = [Event allTouches];
    UITouch *touch = [touches anyObject];
    UIView * target = [touch view];*/
}

- (void) SetVolumeBarVolume : (TempoCell *)Cell
{
    self.AccentCircleVolumeButton.IndexValue = [Cell.accentVolume floatValue];
    self.QuarterCircleVolumeButton.IndexValue = [Cell.quarterNoteVolume floatValue];
    self.EighthNoteCircleVolumeButton.IndexValue = [Cell.eighthNoteVolume floatValue];
    self.SixteenthNoteCircleVolumeButton.IndexValue = [Cell.sixteenNoteVolume floatValue];
    self.TrippleNoteCircleVolumeButton.IndexValue = [Cell.trippleNoteVolume floatValue];
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

// =========================
// delegate
//
- (void) ShortPress: (LargeBPMPicker *) ThisPicker
{
    [self TapBPMValueButtonClick:ThisPicker];
}

- (IBAction) CircleButtonValueChanged:(CircleButton*) ThisCircleButton;
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    float Value = ThisCircleButton.IndexValue;
    switch (ThisCircleButton.tag) {
        case ACCENT_VOLUME_BUTTON:
            Parent.CurrentCell.accentVolume = [NSNumber numberWithFloat:Value];
            break;
        case QUARTER_VOLUME_BUTTON:
            Parent.CurrentCell.quarterNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case EIGHTH_NOTE_VOLUME_BUTTON:
            Parent.CurrentCell.eighthNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case SIXTEENTH_NOTE_VOLUME_BUTTON:
            Parent.CurrentCell.sixteenNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case TRIPPLET_NOTE_VOLUME_BUTTON:
            Parent.CurrentCell.trippleNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        default:
            break;
    }
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
}

- (void) SetBPMValue : (int) NewValue
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    Parent.CurrentCell.bpmValue = [NSNumber numberWithInt:NewValue];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    if (Parent.PlayingMode != STOP_PLAYING)
    {
        Parent.ChangeBPMValueFlag = YES;
    }
}
//
// =========================


// =========================
// Property
//
- (int) GetTapTriggerCounter
{
    return _TapTriggerCounter;
}

- (void) SetTapTriggerCounter: (int) NewValue
{
    // TODO: Open A Timer or animation to show Tap icon when Second Tap
    if(NewValue >=1 && NewValue <  [self TapTriggerNumber])
    {
        // check icon
        // Show normal Icon
        self.TapAlertImage.hidden = NO;
    }
    else if (NewValue >= [self TapTriggerNumber])
    {
        // show
        self.TapAlertImage.hidden = NO;
    }
    else
    {
        // check icon
        // Hidden Icon
        self.TapAlertImage.hidden = YES;
    }
    
    _TapTriggerCounter = NewValue;
}

//
// =========================

// =========================
// Action
//
- (int) TapTriggerNumber
{
    return 3;
}

- (IBAction) TapBPMValueButtonClick: (id) ThisClickedButton
{
    if (_Date == nil)
    {
        _Date = [NSDate date];
    }
    
    if (_LastRecordTime_ms != 0 && self.TapTriggerCounter >= [self TapTriggerNumber])
    {
        double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
        int NewBPMvalue = 60000.f/(CurrentRecordTime_ms -_LastRecordTime_ms);
        
        // 如果速度低於BPMMinValue, 就重算
        if( NewBPMvalue >= [[GlobalConfig BPMMinValue] intValue])
        {
            self.BPMPicker.Value = NewBPMvalue;
        }
        else
        {
            self.TapTriggerCounter = 0;
        }
    }
    
    _LastRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
    self.TapTriggerCounter++;
}

// If using scroll or single step to change BPM value, need to clean TapTriggerCounter
- (void) TapResetNotificationCallBack :(NSNotification *)Notification
{
    [self TapResetTicker:nil];
}


- (void) TapResetTicker: (NSTimer *) theTimer
{
    if (_Date != nil)
    {
        _Date = nil;
    }
    _LastRecordTime_ms = 0;
    self.TapTriggerCounter = 0;
}
//
// =========================
@end
