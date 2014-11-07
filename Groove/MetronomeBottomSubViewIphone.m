//
//  MetronomeBottomSubViewIphone.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeBottomSubViewIphone.h"

@implementation MetronomeBottomSubViewIphone
{
    NSArray * _CurrentDataTable;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.VolumeSet removeFromSuperview];
        self.VolumeSet = [[VolumeBarSet alloc] initWithFrame:self.VolumeSet.frame];
        self.VolumeSet.MaxValue = 10.0;
        self.VolumeSet.MinValue = -1.0;
        self.VolumeSet.delegate = self;
        [self addSubview:self.VolumeSet];
       
        
        [self.SelectGrooveBar removeFromSuperview];
        self.SelectGrooveBar = [[MetronomeSelectBar alloc] initWithFrame:self.SelectGrooveBar.frame];
        self.SelectGrooveBar.delegate = self;
        [self addSubview:self.SelectGrooveBar];
        
        self.adView.delegate = self;
        
        // Tap
        UIGraphicsBeginImageContext(self.TapBPMValueButton.frame.size);
        [[UIImage imageNamed:@"Tap"] drawInRect:self.TapBPMValueButton.bounds];
        UIImage *TapImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.TapBPMValueButton.backgroundColor = [UIColor colorWithPatternImage:TapImage];
        
        // Voice
        UIGraphicsBeginImageContext(self.VoiceButton.frame.size);
        [[UIImage imageNamed:@"Voice_Hi-Click"] drawInRect:self.VoiceButton.bounds];
        UIImage *VoiceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.VoiceButton.backgroundColor = [UIColor colorWithPatternImage:VoiceImage];
        
        // Time Signature
        UIGraphicsBeginImageContext(self.TimeSignatureButton.frame.size);
        [[UIImage imageNamed:@"TimeSignature4_4"] drawInRect:self.TimeSignatureButton.bounds];
        UIImage *TimeSignatureImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.TimeSignatureButton.backgroundColor = [UIColor colorWithPatternImage:TimeSignatureImage];
        
        // Back ground
        /*UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:@"BottomViewBackground"] drawInRect:self.bounds];
        UIImage *SelfBackGroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:SelfBackGroundImage];*/
        self.backgroundColor = [UIColor whiteColor];
        

        
        // TODO : Test CircleButton
        self.VolumeSet.hidden = YES;
        [self.TestCircleButton removeFromSuperview];
        self.TestCircleButton = [[CircleButton alloc] initWithFrame:self.TestCircleButton.frame];
        [self addSubview:self.TestCircleButton];
        self.TestCircleButton.MaxIndex = 100;
        self.TestCircleButton.MinIndex = 0;
        self.TestCircleButton.Sensitivity = 3;
        self.TestCircleButton.IndexValue = 80;

    }
    return self;
}

- (void) SetVolumeBarVolume : (TempoCell *)Cell
{
    self.VolumeSet.SliderAccent.value = [Cell.accentVolume floatValue];
    self.VolumeSet.SliderQuarterNote.value = [Cell.quarterNoteVolume floatValue];
    self.VolumeSet.SliderEighthNote.value = [Cell.eighthNoteVolume floatValue];
    self.VolumeSet.SliderSixteenNote.value = [Cell.sixteenNoteVolume floatValue];
    self.VolumeSet.SliderTrippleNote.value = [Cell.trippleNoteVolume floatValue];
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

// =================================
// Property
//
- (NSArray *) GetCurrentDataTable
{
    return _CurrentDataTable;
}
- (void) SetCurrentDataTable : (NSArray *) NewValue
{
    int _FocusIndex = 0;
    
    _CurrentDataTable = NewValue;
    
    // Set Select Loop bar
    [self CopyGrooveLoopListToSelectBar: _CurrentDataTable];

    _FocusIndex = [self GetFocusIndex];
    
    if (_FocusIndex >= 0 && _FocusIndex < _CurrentDataTable.count)
    {
        [self SetVolumeBarVolume: _CurrentDataTable[_FocusIndex]];
    }
    else
    {
        // First Initailize will give wrong Index
        // NSLog(@"Wrong Index");
    }

}

- (int) GetFocusIndex
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(GetFocusIndex)])
        {
            return [self.delegate GetFocusIndex];
        }
    }

    return 0;
}

- (void) SetFocusIndex:(int) NewValue
{
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetFocusIndex:)])
        {
            [self.delegate SetFocusIndex: NewValue];
        }
    }
    
    // UI 自動動作
    [self SetVolumeBarVolume: _CurrentDataTable[[self GetFocusIndex]]];
}

- (void) ChangeSelectBarForcusIndex: (int) NewValue
{
    self.SelectGrooveBar.FocusIndex = NewValue;
}
//
// =================================

// =================================
// Action
//
- (IBAction) VolumeSliderValueChanged:(TmpVerticalSlider*) ThisVerticalSlider
{
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(VolumeSliderValueChanged:)])
        {
            [self.delegate VolumeSliderValueChanged: ThisVerticalSlider];
        }
    }
}

- (IBAction) PlayCurrentCellButtonClick: (UIButton *) ThisClickedButton {
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(PlayCurrentCellButtonClick:)])
        {
            [self.delegate PlayCurrentCellButtonClick: ThisClickedButton];
        }
    }
}

- (IBAction) TapBPMValueButtonClick: (UIButton *) ThisClickedButton {
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(TapBPMValueButtonClick:)])
        {
            [self.delegate TapBPMValueButtonClick: ThisClickedButton];
        }
    }
}

- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton {
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(AddLoopCellButtonClick:)])
        {
            [self.delegate AddLoopCellButtonClick: ThisClickedButton];
        }
    }
}


- (IBAction) DeleteLoopCellButtonClick: (UIButton *) ThisClickedButton {
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(DeleteLoopCellButtonClick:)])
        {
            [self.delegate DeleteLoopCellButtonClick: ThisClickedButton];
        }
    }
}

- (IBAction) PlayLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(PlayLoopCellButtonClick:)])
        {
            [self.delegate PlayLoopCellButtonClick: ThisClickedButton];
        }
    }
}
//
// =================================


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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
