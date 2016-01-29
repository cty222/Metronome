//
//  BPMPickerViewController.m
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "BPMPickerViewController.h"

@interface BPMPickerViewController ()

@property (getter = GetIsValueChange, setter = SetIsValueChange:) BOOL IsValueChange;
@property int Sensitivity;
@property double StepValue;
@property NSNumber * DeviceType;

@end

@implementation BPMPickerViewController{
    BPM_PICKER_MODE _Mode;
    double _Value;
    int _MaxLimit;
    int _MinLimit;
    
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    NSTimer *ArrowCancellTimer;
    NSTimer *ArrowLongPushTimer;
    
    // Short press
    BOOL _IsValueChange;
    float _ShortPressSecond;
    NSDate * _Date;
    double _PressTime_ms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initInViewDidLoad];
}

-(void) initInViewDidLoad {
    
    self.Mode = BPM_PICKER_INT_MODE;
    
    
    _MaxLimit = [[GlobalConfig BPMMaxValue] intValue];
    _MinLimit = [[GlobalConfig BPMMinValue] intValue];
    
    
    self.Value = 120;
    self.ShortPressSecond = 0.5;
    
    self.UpArrow.userInteractionEnabled = NO;
    self.DownArrow.userInteractionEnabled = NO;
    
    self.UpArrow.hidden = YES;
    self.DownArrow.hidden = YES;
    self.Touched = NO;
    
}

- (float) LongPushArraySensitivity
{
    return 0.3;
}


// =================================
// Property
//
- (BPM_PICKER_MODE) GetMode
{
    return _Mode;
}

- (void) SetMode: (BPM_PICKER_MODE) NewValue
{
    _Mode = NewValue;
    switch (_Mode) {
        case BPM_PICKER_INT_MODE:
            self.Sensitivity = 5;
            self.StepValue = 1;
            self.ValueLabel.font = [self.ValueLabel.font  fontWithSize:140];
            break;
        case BPM_PICKER_DOUBLE_MODE:
            self.Sensitivity = 3;
            self.StepValue = 0.1;
            self.ValueLabel.font = [self.ValueLabel.font  fontWithSize:95];
            break;
        default:
            self.Mode = BPM_PICKER_INT_MODE;
            break;
    }
}

- (double) GetValue
{
    return _Value;
}

- (void) SetValue : (double) NewValue
{
    // 小數點的關係會讓300出不來
    if (NewValue > _MaxLimit || NewValue < _MinLimit) {
        return;
    }
    
    _Value =  ROUND_ONE_DECOMAL_FROM_DOUBLE(NewValue);
    
    switch (self.Mode) {
        case BPM_PICKER_INT_MODE:
            [self.ValueLabel setText:[NSString stringWithFormat:@"%d", (int)self.Value]];
            break;
        case BPM_PICKER_DOUBLE_MODE:
            [self.ValueLabel setText:[NSString stringWithFormat:@"%0.1f", self.Value]];
            break;
        default:
            // Avoid Bug
            self.Mode = BPM_PICKER_INT_MODE;
            [self.ValueLabel setText:[NSString stringWithFormat:@"%d", (int)self.Value]];
            break;
    }
    
    // Pass to parent view.
    if (self.delegate != nil){
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetBPMValue:)]){
            [self.delegate SetBPMValue: self];
        }
    }
}
//
// ===========================

// ============================
// delegate
//
- (void) ShortPress: (id) ThisPicker
{
    if (self.IsValueChange){
        return;
    }

    if (self.delegate != nil){
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(ShortPress:)]){
            [self.delegate ShortPress: ThisPicker];
        }
    }
}
//
// ============================

// ================================
// Function
//

- (void) ShortPressCheckStart
{
    if (_Date == nil)
    {
        _Date = [NSDate date];
    }
    
    _PressTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
}

- (void) ShortPressCheckEnd
{
    if (_PressTime_ms != 0)
    {
        double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
        if ((CurrentRecordTime_ms -_PressTime_ms) < self.ShortPressSecond * 1000.0)
        {
            [self ShortPress:self];
        }
    }
}

- (void) CheckTouchValueArrow : (CGPoint) TouchLocation
{
    if (!self.Touched)
    {
        return;
    }
    
    CGRect UpArrowFrame = self.UpValueFrameView.frame;
    CGRect DownArrowFrame = self.DownValueFrameView.frame;
    
    if ((TouchLocation.x > UpArrowFrame.origin.x && TouchLocation.x < UpArrowFrame.origin.x + UpArrowFrame.size.width) && (TouchLocation.y > UpArrowFrame.origin.y && TouchLocation.y < UpArrowFrame.origin.y + UpArrowFrame.size.height))
    {
        self.Value += self.StepValue;
        self.IsValueChange = YES;
    }
    else if((TouchLocation.x > DownArrowFrame.origin.x && TouchLocation.x < DownArrowFrame.origin.x + DownArrowFrame.size.width) && (TouchLocation.y > DownArrowFrame.origin.y && TouchLocation.y < DownArrowFrame.origin.y + DownArrowFrame.size.height))
    {
        self.Value -= self.StepValue;
        self.IsValueChange = YES;
    }
    
    if (self.IsValueChange == YES && ArrowLongPushTimer == nil)
    {
        ArrowLongPushTimer = [NSTimer scheduledTimerWithTimeInterval:[self LongPushArraySensitivity]
                                                              target:self
                                                            selector:@selector(ArrowLongPushTicker:)
                                                            userInfo:nil
                                                             repeats:YES];
    }
}

//
// ================================

// ================================
// property
//

- (void) SetIsValueChange : (BOOL) NewValue
{
    if (NewValue)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTapResetNotification object:nil];
    }
    
    _IsValueChange = NewValue;
}

- (BOOL) GetIsValueChange
{
    return  _IsValueChange;
}

- (void) SetShortPressSecond : (float) NewValue
{
    _ShortPressSecond = NewValue;
}

- (float)GetShortPressSecond
{
    if (_ShortPressSecond == 0)
    {
        _ShortPressSecond = 0.25;
    }
    return _ShortPressSecond;
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) SetTouched: (BOOL)NewValue
{
    
    _Touched = NewValue;
    
    if (_Touched)
    {
        self.IsValueChange = NO;
        
        if (self.UpArrow.hidden == NO)
        {
            [self CheckTouchValueArrow: OriginalLocation];
        }
        
        self.UpArrow.hidden = NO;
        self.DownArrow.hidden = NO;
        if (ArrowCancellTimer != nil)
        {
            [ArrowCancellTimer invalidate];
            ArrowCancellTimer = nil;
        }
        
        [self ShortPressCheckStart];
    }
    else
    {
        ArrowCancellTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                             target:self
                                                           selector:@selector(ArrowCancellTicker:)
                                                           userInfo:nil
                                                            repeats:NO];
        if (ArrowLongPushTimer != nil)
        {
            [ArrowLongPushTimer invalidate];
            ArrowLongPushTimer = nil;
        }
        
        [self ShortPressCheckEnd];
        self.IsValueChange = NO;
    }
}

//
// ================================

// ================================
// touch event
//

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    OriginalLocation = [self GetLocationPoint: touches];
    
    self.Touched = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.Touched)
    {
        CGPoint TouchLocation = [self GetLocationPoint: touches];
        // Because zero point is on left top, large point in on right bottom
        int MoveUp = (double)(OriginalLocation.y - TouchLocation.y) / self.Sensitivity;
        if (MoveUp != 0)
        {
            self.IsValueChange = YES;
            self.Value += MoveUp * self.StepValue;
            OriginalLocation = TouchLocation;
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;
}

- (CGPoint) GetLocationPoint: (NSSet*)touches
{
    UITouch *Touch =  [touches anyObject];
    return [Touch locationInView:Touch.view];
}

//
// ================================


// ========
// Ticker
- (void) ArrowCancellTicker: (NSTimer *) ThisTimer
{
    self.UpArrow.hidden = YES;
    self.DownArrow.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTapResetNotification object:nil];
}

- (void) ArrowLongPushTicker: (NSTimer *) ThisTimer
{
    [self CheckTouchValueArrow: OriginalLocation];
}


//========


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
