//
//  ValuePickerTemplate.m
//  Groove
//
//  Created by C-ty on 2014/12/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "ValuePickerTemplate.h"

// Private property
@interface ValuePickerTemplate ()

@property (getter = GetIsValueChange, setter = SetIsValueChange:) BOOL IsValueChange;
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;

@end

@implementation ValuePickerTemplate
{
    float _Value;
    float _MaxLimit;
    float _MinLimit;
    
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    NSTimer *ArrowLongPushTimer;
    
    // Short press
    BOOL _IsValueChange;
    float _ShortPressSecond;
    NSDate * _Date;
    double _PressTime_ms;
}

- (float) LongPushArraySensitivity
{
    return 0.3;
}

- (int) Sensitivity
{
    return 3;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

-(void) Initialize
{
    self.Value = 0;
    self.ShortPressSecond = 0.5;

    self.ValueLabel.userInteractionEnabled = NO;
    self.UpArrow.userInteractionEnabled = NO;
    self.DownArrow.userInteractionEnabled = NO;
    
    self.Touched = NO;
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self Initialize];
        
        NSLog(@"%@", self);
    };
    return self;
}

- (id) init
{
    self = [super init];
    if (self) {
        // If set this enable, the touch will send event to lebal
    }
    return self;
}


- (float) GetValue
{
    return _Value;
}

- (void) SetValue : (float) NewValue
{
    if (NewValue > _MaxLimit || NewValue < _MinLimit)
    {
        return;
    }
    
    _Value = NewValue;
    
    [self.ValueLabel setText:[NSString stringWithFormat:@"%d", (int)self.Value]];
    
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetValue:)])
        {
            [self.delegate SetValue: self];
        }
    }
}

- (void) SetValueWithoutDelegate : (int) NewValue
{
    if (NewValue > _MaxLimit || NewValue < _MinLimit)
    {
        return;
    }
    
    _Value = NewValue;
    
    [self.ValueLabel setText:[NSString stringWithFormat:@"%d", (int)self.Value]];

}

//
// ===========================

// ============================
// delegate
//
- (void) ShortPress: (id) ThisPicker
{
    if (self.IsValueChange)
    {
        return;
    }
    
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(ShortPress:)])
        {
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
    
    CGRect UpArrowFrame = self.UpArrow.frame;
    CGRect DownArrowFrame = self.DownArrow.frame;
    
    if ((TouchLocation.x > UpArrowFrame.origin.x && TouchLocation.x < UpArrowFrame.origin.x + UpArrowFrame.size.width) && (TouchLocation.y > UpArrowFrame.origin.y && TouchLocation.y < UpArrowFrame.origin.y + UpArrowFrame.size.height))
    {
        self.Value++;
        self.IsValueChange = YES;
    }
    else if((TouchLocation.x > DownArrowFrame.origin.x && TouchLocation.x < DownArrowFrame.origin.x + DownArrowFrame.size.width) && (TouchLocation.y > DownArrowFrame.origin.y && TouchLocation.y < DownArrowFrame.origin.y + DownArrowFrame.size.height))
    {
        self.Value--;
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
        
        [self CheckTouchValueArrow: OriginalLocation];
       
        [self ShortPressCheckStart];
    }
    else
    {
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
        int MoveUp = (double)(OriginalLocation.y - TouchLocation.y) / [self Sensitivity];
        if (MoveUp != 0)
        {
            self.IsValueChange = YES;
            self.Value += MoveUp;
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
- (void) ArrowLongPushTicker: (NSTimer *) ThisTimer
{
    [self CheckTouchValueArrow: OriginalLocation];
}

//========

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
