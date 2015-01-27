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
@property TapFunction * TapFunction;

@end

@implementation CellParameterSettingControl
{
 
}

- (void) MainViewWillAppear
{
    [self.VolumeSetsControl ResetVolumeSets];
}


- (void) InitlizeCellParameterControlItems
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    // Init Volumesets
    self.VolumeSetsControl = [[VolumeSetsControl alloc] init: Parent];
    
    // Others
    self.BPMPicker = Parent.TopSubView.BPMPicker;
    self.OptionScrollView = Parent.TopSubView.OptionScrollView;
    self.VoiceTypePicker = Parent.TopSubView.VoiceTypePicker;
    self.TimeSigaturePicker = Parent.TopSubView.TimeSigaturePicker;
    self.LoopCellEditer = Parent.TopSubView.LoopCellEditer;
    self.TapAlertImage = Parent.TopSubView.TapAnimationImage;
    self.TimeSignaturePickerView = Parent.TopSubView.TimeSignaturePickerView;
    self.VoiceTypePickerView = Parent.TopSubView.VoiceTypePickerView;
    self.LoopCellEditerView = Parent.TopSubView.LoopCellEditerView;

    // BPM Picker Initialize
    self.BPMPicker.delegate = self;
    
    
    //Init  TapFunction
    self.TapFunction = [[TapFunction alloc] init];
    self.TapFunction.TapAlertImage = self.TapAlertImage;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TapChangeBPMCallBack:)
                                                 name:kTapChangeBPMValue
                                               object:nil];

    //VoiceTypePicker
    [self InitilaizeVoiceTypePickerView];
    [self.VoiceTypePicker addTarget:self
                               action:@selector(VoiceTypePickerDisplay:) forControlEvents:UIControlEventTouchDown];
    
    // Time Signature
    [self.TimeSigaturePicker setTitleColor:[TimeSignaturePickerView TextFontColor] forState:UIControlStateNormal];
    [self InitilaizeTimeSignaturePickerView];
    [self.TimeSigaturePicker addTarget:self
                             action:@selector(TimeSigaturePickerDisplay:) forControlEvents:UIControlEventTouchDown];
    

    // LoopCellEditer
    [self InitilaizeLoopCellEditerView];
    [self.LoopCellEditer addTarget:self
                                action:@selector(LoopCellEditerDisplay:) forControlEvents:UIControlEventTouchDown];
   
}



- (void) InitilaizeVoiceTypePickerView
{
    NSArray *VoiceTypeArray = gMetronomeModel.VoiceTypeDataTable;
    self.VoiceTypePickerView.OriginYOffset = self.OptionScrollView.frame.origin.y - self.VoiceTypePickerView.frame.origin.y;
    self.VoiceTypePickerView.ArrowCenterLine = self.VoiceTypePicker.frame.origin.y + self.VoiceTypePicker.frame.size.height/2 - self.OptionScrollView.contentOffset.y;
    self.VoiceTypePickerView.TriggerButton = self.VoiceTypePicker;
    self.VoiceTypePickerView.delegate = self;
    
    [self.VoiceTypePickerView DisplayPropertyCell:VoiceTypeArray : self.VoiceTypePicker];
}


- (void) InitilaizeTimeSignaturePickerView
{
    // If nil, create data view
    NSArray *TimeSignatureTypeArray = gMetronomeModel.TimeSignatureTypeDataTable;
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
    self.LoopCellEditerView.ValueScrollView.MaxLimit  = [[GlobalConfig TempoCellLoopCountMax] intValue];
    self.LoopCellEditerView.ValueScrollView.MinLimit  = [[GlobalConfig TempoCellLoopCountMin] intValue];
    
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
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    TempoCell * TargetCell = Parent.CurrentCellsDataTable[Parent.FocusIndex];
    
    if ([TargetCell.loopCount intValue] != ROUND_NO_DECOMAL_FROM_DOUBLE(self.LoopCellEditerView.ValueScrollView.Value))
    {
        self.LoopCellEditerView.ValueScrollView.Value =  ROUND_ONE_DECOMAL_FROM_DOUBLE([TargetCell.loopCount intValue]);
    }
    
    self.LoopCellEditerView.hidden = !self.LoopCellEditerView.hidden;
}

- (IBAction) ChangeVoiceType:(UIButton *)TriggerItem
{
    NSArray *VoiceTypeArray = gMetronomeModel.VoiceTypeDataTable;

    if (gClickVoiceList.count <= TriggerItem.tag || VoiceTypeArray.count <= TriggerItem.tag)
    {
        return;
    }
    
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    // Because 0 is no voice
    NSInteger VoiceIndex = TriggerItem.tag;
    Parent.CurrentCell.voiceType = (VoiceType *)VoiceTypeArray[TriggerItem.tag];
    Parent.CurrentVoice = [gClickVoiceList objectAtIndex:VoiceIndex];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [self.VoiceTypePicker setBackgroundImage:[TriggerItem backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];


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
    NSArray *TimeSignatureTypeArray = gMetronomeModel.TimeSignatureTypeDataTable;
    
    if (TimeSignatureTypeArray.count <= TriggerItem.tag)
    {
        return;
    }
    
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    Parent.CurrentCell.timeSignatureType = (TimeSignatureType *)TimeSignatureTypeArray[TriggerItem.tag];
    Parent.CurrentTimeSignature = TriggerItem.titleLabel.text;
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [self.TimeSigaturePicker setTitle:TriggerItem.titleLabel.text forState:UIControlStateNormal];
}

- (IBAction) ChangeCellCounter:(id)TriggerItem
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

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
    else if ([TimeSignatureString isEqualToString:@"9/4"])
    {
        return 9;
    }
    else if ([TimeSignatureString isEqualToString:@"10/4"])
    {
        return 10;
    }
    else if ([TimeSignatureString isEqualToString:@"11/4"])
    {
        return 11;
    }
    else if ([TimeSignatureString isEqualToString:@"12/4"])
    {
        return 12;
    }
    return 4;
}

// =========================
// delegate
//
- (void) ShortPress: (LargeBPMPicker *) ThisPicker
{
    [self.TapFunction TapAreaBeingTap];
}

- (void) SetBPMValue : (id) Picker
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    if (Picker == self.BPMPicker)
    {
        // BPM Save
        Parent.CurrentCell.bpmValue = [NSNumber numberWithFloat:self.BPMPicker.Value];
    
        // TODO : 不要save這麼頻繁
        [gMetronomeModel Save];
    
        if (Parent.PlayingMode != STOP_PLAYING)
        {
            Parent.IsNeededToRestartMetronomeClick = YES;
        }
    }
}
//
// =========================

// =========================
// Event callback
//


- (void) TapChangeBPMCallBack :(NSNotification *)Notification
{
    self.BPMPicker.Value = [self.TapFunction GetNewValue];
}

//
// =========================


@end
