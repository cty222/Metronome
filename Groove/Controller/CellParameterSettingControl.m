//
//  CellParameterSettingControl.m
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "CellParameterSettingControl.h"

@implementation CellParameterSettingControl
{
    // Tap Fuction
    double _LastRecordTime_ms;
    NSDate * _Date;;
    NSTimer *ClearTapTimer;
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
    self.VoiceTypeCircleButton = Parent.BottomSubView.VoiceTypeCircleButton;
    self.TimeSigaturePicker = Parent.TopSubView.TimeSigaturePicker;
    self.TapButton = Parent.TopSubView.TapButton;
    
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
// Action
//
- (IBAction) TapBPMValueButtonClick: (UIButton *) ThisClickedButton
{
    if (_Date == nil)
    {
        _Date = [NSDate date];
    }
    
    if (ClearTapTimer != nil)
    {
        [ClearTapTimer invalidate];
        ClearTapTimer = nil;
    }
    ClearTapTimer = [NSTimer scheduledTimerWithTimeInterval:TAP_CLEAR_DELAY
                                                     target:self
                                                   selector:@selector(ClearTapTicker:)
                                                   userInfo:nil
                                                    repeats:NO];
    if (_LastRecordTime_ms != 0)
    {
        double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
        int NewBPMvalue = 60000.f/(CurrentRecordTime_ms -_LastRecordTime_ms);
        self.BPMPicker.BPMValue = NewBPMvalue;
    }
    
    _LastRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
}


- (void) ClearTapTicker: (NSTimer *) theTimer
{
    if (_Date != nil)
    {
        _Date = nil;
    }
    _LastRecordTime_ms = 0;
    ClearTapTimer = nil;
}
//
// =========================
@end
