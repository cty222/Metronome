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

- (void) initNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TapChangeBPMCallBack:)
                                                 name:kTapChangeBPMValue
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twicklingCircleButton:)
                                                 name:kCircleButtonTwickLing
                                               object:nil];
}

- (void)twicklingCircleButton:(NSNotification *)notification {
    __CIRCLE_BUTTON btnTag = [((NSNumber *)notification.object) intValue];
    switch (btnTag) {
        case AccentCircle_Button:
            [self.VolumeSetsControl.AccentCircleVolumeButton TwickLing];
            break;
        case QuarterCircle_Button:
            [self.VolumeSetsControl.QuarterCircleVolumeButton TwickLing];
            break;
        case EighthNoteCircle_Button:
            [self.VolumeSetsControl.EighthNoteCircleVolumeButton TwickLing];
            break;
        case SixteenthNoteCircle_Button:
            [self.VolumeSetsControl.SixteenthNoteCircleVolumeButton TwickLing];
            break;
        case TrippleNoteCircle_Button:
            [self.VolumeSetsControl.TrippleNoteCircleVolumeButton TwickLing];
            break;
    }
}

- (void) initlizeCellParameterControlItems
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    // Init Volumesets
    self.VolumeSetsControl = [[VolumeSetsControl alloc] init: Parent];
    
    // Others
    self.bPMPickerViewController = Parent.topPartOfMetronomeViewController.bPMPickerViewController;
    
    self.OptionScrollView = Parent.topPartOfMetronomeViewController.OptionScrollView;
    self.VoiceTypePicker = Parent.topPartOfMetronomeViewController.VoiceTypePicker;
    self.TimeSigaturePicker = Parent.topPartOfMetronomeViewController.TimeSigaturePicker;
    self.LoopCellEditer = Parent.topPartOfMetronomeViewController.LoopCellEditer;
    self.TapAlertImage = Parent.topPartOfMetronomeViewController.TapAnimationImage;
    self.TimeSignaturePickerView = Parent.topPartOfMetronomeViewController.TimeSignaturePickerView;
    self.VoiceTypePickerView = Parent.topPartOfMetronomeViewController.VoiceTypePickerView;
    self.LoopCellEditerView = Parent.topPartOfMetronomeViewController.LoopCellEditerView;

    // BPM Picker Initialize
    self.bPMPickerViewController.delegate = self;
    
    
    //initialize tap function
    self.TapFunction = [[TapFunction alloc] init];
    self.TapFunction.TapAlertImage = self.TapAlertImage;
    [self initNotifications];
    

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
    NSArray *voiceTypeArray = gMetronomeModel.VoiceTypeDataTable;
    self.VoiceTypePickerView.OriginYOffset = self.OptionScrollView.frame.origin.y - self.VoiceTypePickerView.frame.origin.y;
    self.VoiceTypePickerView.ArrowCenterLine = self.VoiceTypePicker.frame.origin.y + self.VoiceTypePicker.frame.size.height/2 - self.OptionScrollView.contentOffset.y;
    self.VoiceTypePickerView.TriggerButton = self.VoiceTypePicker;
    self.VoiceTypePickerView.delegate = self;
    
    [self.VoiceTypePickerView DisplayPropertyCell:voiceTypeArray : self.VoiceTypePicker];
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
    TempoCell * TargetCell = Parent.engine.tempoCells[Parent.currentSelectedCellIndex];
    
    if ([TargetCell.loopCount intValue] != ROUND_NO_DECOMAL_FROM_DOUBLE(self.LoopCellEditerView.ValueScrollView.Value))
    {
        self.LoopCellEditerView.ValueScrollView.Value =  ROUND_ONE_DECOMAL_FROM_DOUBLE([TargetCell.loopCount intValue]);
    }
    
    self.LoopCellEditerView.hidden = !self.LoopCellEditerView.hidden;
}

- (IBAction) ChangeVoiceType:(UIButton *)TriggerItem
{
    NSArray *voiceTypeArray = gMetronomeModel.VoiceTypeDataTable;

    if (voiceTypeArray.count <= TriggerItem.tag) {
        return;
    }
    
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    // Because 0 is no voice
    NSInteger VoiceIndex = TriggerItem.tag;
    Parent.engine.currentCell.voiceType = (VoiceType *)voiceTypeArray[TriggerItem.tag];
    
    [self.VoiceTypePicker setBackgroundImage:[TriggerItem backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];

    Parent.engine.currentVoice = [Parent.globalServices.engine.clickVoiceList objectAtIndex:VoiceIndex];
    
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
    NSArray *TimeSignatureTypeArray = gMetronomeModel.TimeSignatureTypeDataTable;
    
    if (TimeSignatureTypeArray.count <= TriggerItem.tag)
    {
        return;
    }
    
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    Parent.engine.currentCell.timeSignatureType = (TimeSignatureType *)TimeSignatureTypeArray[TriggerItem.tag];
    Parent.engine.currentTimeSignature = TriggerItem.titleLabel.text;
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [self.TimeSigaturePicker setTitle:TriggerItem.titleLabel.text forState:UIControlStateNormal];
}

- (IBAction) ChangeCellCounter:(id)TriggerItem
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    if (self.LoopCellEditerView.ValueScrollView == TriggerItem)
    {
        [Parent.loopAndPlayViewSubController SetTargetCellLoopCountAdd:Parent.currentSelectedCellIndex
                                                                 Value:self.LoopCellEditerView.ValueScrollView.Value];
    }
    else if (self.LoopCellEditerView.CellDeleteButton == TriggerItem)
    {
        [Parent.loopAndPlayViewSubController DeleteTargetIndexCell:Parent.currentSelectedCellIndex];
    }
}

// =========================
// delegate
//
- (void) ShortPress: (id) ThisPicker
{
    [self.TapFunction TapAreaBeingTap];
}

- (void) SetBPMValue : (id) Picker
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    if (Picker == self.bPMPickerViewController)
    {
        // BPM Save
        Parent.engine.currentCell.bpmValue = [NSNumber numberWithFloat:self.bPMPickerViewController.Value];
    
        // TODO : 不要save這麼頻繁
        [gMetronomeModel Save];
    
        if (Parent.currentPlayingMode != STOP_PLAYING)
        {
            Parent.doesItNeedToRestartMetronome = YES;
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
    self.bPMPickerViewController.Value = [self.TapFunction GetNewValue];
}

//
// =========================


@end
