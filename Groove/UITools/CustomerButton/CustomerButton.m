//
//  CustomerButton.m
//  Groove
//
//  Created by C-ty on 2015/1/3.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "CustomerButton.h"

// Private property
@interface CustomerButton ()

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetIsScroll, setter = SetIsScroll:) BOOL IsScroll;

@end

@implementation CustomerButton
{
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    
    // Short press
    BOOL _IsScroll;
    float _ShortPressSecond;
    NSDate * _Date;
    double _PressTime_ms;
}

// ================================
// property
//
- (int) Sensitivity
{
    return 1;
}

- (void) SetIsScroll : (BOOL) NewValue
{
    _IsScroll = NewValue;
}

- (BOOL) GetIsScroll
{
    return  _IsScroll;
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
        self.IsScroll = NO;

        [self ShortPressCheckStart];
    }
    else
    {
        [self ShortPressCheckEnd];
        self.IsScroll = NO;
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
            self.IsScroll = YES;
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

// ============================
// delegate
//
- (void) ShortPress: (id) ThisPicker
{
    if (self.IsScroll)
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

//
// ================================

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
