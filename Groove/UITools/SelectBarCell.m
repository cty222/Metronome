//
//  SelectBarCell.m
//  Groove
//
//  Created by C-ty on 2014/11/16.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SelectBarCell.h"

@implementation SelectBarCell
{
    // Property
    UIImageView *_CurrentDisplayView;
    BOOL _Touched;
    BOOL _IsFocusOn;
    int _Value;
    SELECT_CELL_MOVE_MODE _MoveMode;

    CGPoint _OriginalLocation;
    CGPoint _OriginalFrameOrigin;
    CGPoint _TouchedOriginOffset;

    NSTimer *_LongPressTimer;
    
    // Short press
    NSDate * _Date;
    double _PressTime_ms;

    
    float _LongPressSecond;
    float _ShortPressSecond;
    float _VerticalSensitivity;
    float _HorizontalSensitivity;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.NoramlImage.hidden = YES;
        self.FocusImage.hidden = YES;
        self.LongPressImage.hidden = YES;
        self.CurrentDisplayView = self.NoramlImage;
        
        // Moving event
        
        // Setting
        self.ValueLabel.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        
        self.MoveMode = SELECT_CELL_NONE;
        self.ShortPressSecond = 0.5;
        self.LongPressSecond = 0.8;
        self.VerticalSensitivity = 16;
        self.HorizontalSensitivity = 1;
        
        _Date = [NSDate date];
    }
    return self;
}

// ================================
// Property
//
- (BOOL) GetIsfocusOn
{
    return _IsFocusOn;
}

- (void) SetIsfocusOn : (BOOL) NewValue
{
    if (NewValue == _IsFocusOn)
    {
        return;
    }
    
    _IsFocusOn = NewValue;

    if (_IsFocusOn)
    {
        self.MoveMode = SELECT_CELL_FOCUS_ON;
    }
    else
    {
        self.MoveMode = SELECT_CELL_NONE;
    }
}

- (UIImageView *)GetCurrentDisplayView
{
    return _CurrentDisplayView;
}

- (void) SetCurrentDisplayView : (UIImageView *) NewDisplayView
{
    if (NewDisplayView == nil)
    {
        return;
    }
    
    if (_CurrentDisplayView != nil)
    {
        _CurrentDisplayView.hidden = YES;
    }
    
    _CurrentDisplayView = NewDisplayView;
    _CurrentDisplayView.hidden = NO;
}

-(void) SetTouched: (BOOL) NewValue
{
    if (_Touched == NewValue && self.MoveMode == SELECT_CELL_BLOCK)
    {
        return;
    }
    
    _Touched = NewValue;
    if (_Touched)
    {
        _PressTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
        
       if (_LongPressTimer != nil)
        {
            [_LongPressTimer invalidate];
            _LongPressTimer = nil;
        }
        _LongPressTimer = [NSTimer scheduledTimerWithTimeInterval:self.LongPressSecond
                                                         target:self
                                                         selector:@selector(LongPressTick:)
                                                       userInfo:nil
                                                        repeats:NO];
        

    }
    else
    {
        if (_PressTime_ms != 0)
        {
            double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
            if ((CurrentRecordTime_ms -_PressTime_ms) < self.ShortPressSecond * 1000.0)
            {
                self.MoveMode = SELECT_CELL_SHORT_PRESS;
            }
        }
        
        self.MoveMode = SELECT_CELL_NONE;
    }
    
    [self CellTouchedChange:_Touched : self];
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) SetMoveMode : (SELECT_CELL_MOVE_MODE) NewValue
{
    // Set mode block situation
    if ((_MoveMode == NewValue)
        || (NewValue >= SELECT_CELL_MODE_END || NewValue < SELECT_CELL_NONE)
        || (_MoveMode != SELECT_CELL_NONE && NewValue == SELECT_CELL_SHORT_PRESS)
        )
    {
        return;
    }
  

    // before change
    if (_MoveMode == SELECT_CELL_LONG_PRRESS_MOVE)
    {
        if (![self IsLongPressModeEnable:NO : self])
        {
            self.frame = CGRectMake(_OriginalFrameOrigin.x, _OriginalFrameOrigin.y, self.frame.size.width, self.frame.size.height);
        }
    }
    
    // Change
    switch (NewValue) {
        case SELECT_CELL_NONE:
            if (self.IsFocusOn)
            {
                self.MoveMode = SELECT_CELL_FOCUS_ON;
                return;
            }
            self.CurrentDisplayView = self.NoramlImage;
            break;
            
        case SELECT_CELL_NORMAL_MOVE:
            if (self.IsFocusOn)
            {
                self.MoveMode = SELECT_CELL_FOCUS_ON_MOVE;
                return;
            }
            self.CurrentDisplayView = self.NoramlImage;
            break;
            
        case SELECT_CELL_FOCUS_ON:
            if (!self.IsFocusOn)
            {
                self.MoveMode = SELECT_CELL_NONE;
                return;
            }
            self.CurrentDisplayView = self.FocusImage;
            break;
            
        case SELECT_CELL_FOCUS_ON_MOVE:
            if (!self.IsFocusOn)
            {
                self.MoveMode = SELECT_CELL_NORMAL_MOVE;
                return;
            }
            self.CurrentDisplayView = self.FocusImage;
            break;
            
        case SELECT_CELL_SHORT_PRESS:
            _MoveMode = NewValue;
            [self ShortPressToSetFocus:self];
            return;
            break;
            
        case SELECT_CELL_LONG_PRRESS_MOVE:
            if (![self IsLongPressModeEnable:YES : self])
            {
                return;
            }
            _OriginalFrameOrigin = self.frame.origin;
            self.CurrentDisplayView = self.LongPressImage;
            break;
            
        case SELECT_CELL_BLOCK:
            break;
            
        default:
            return;
            break;
    }
    _MoveMode = NewValue;
}

- (SELECT_CELL_MOVE_MODE) GetMoveMode
{
    return _MoveMode;
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

- (void) SetLongPressSecond : (float) NewValue
{
    _LongPressSecond = NewValue;
}

- (float)GetLongPressSecond
{
    if (_LongPressSecond == 0)
    {
        _LongPressSecond = 1;
    }
    return _LongPressSecond;
}

- (void) SetVerticalSensitivity : (float) NewValue
{
    _VerticalSensitivity = NewValue;
}

- (float)GetVerticalSensitivity
{
    if (_VerticalSensitivity == 0)
    {
        _VerticalSensitivity = 1;
    }
    return _VerticalSensitivity;
}

- (void) SetHorizontalSensitivity : (float) NewValue
{
    _HorizontalSensitivity = NewValue;
}

- (float)GetHorizontalSensitivity
{
    if (_HorizontalSensitivity == 0)
    {
        _HorizontalSensitivity = 1;
    }
    return _HorizontalSensitivity;
}

//
// ================================


// ================================
// Touch event
//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (self.MoveMode == SELECT_CELL_BLOCK)
    {
        return;
    }
    
    _OriginalLocation = [self GetLocationPointInSuperview: touches];
    
    self.Touched = YES;

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (self.MoveMode == SELECT_CELL_BLOCK)
    {
        return;
    }
    
    if (self.Touched)
    {
        CGPoint TouchLocation = [self GetLocationPointInSuperview: touches];

        if (self.MoveMode != SELECT_CELL_LONG_PRRESS_MOVE)
        {
            int MoveVertical = (double)(_OriginalLocation.y - TouchLocation.y) / self.VerticalSensitivity;
            int MoveHerizontal = (double)(_OriginalLocation.x - TouchLocation.x) / self.HorizontalSensitivity;
            
            if ((self.MoveMode == SELECT_CELL_NONE) && (MoveVertical !=0 || MoveHerizontal !=0))
            {
                if (_LongPressTimer != nil)
                {
                    [_LongPressTimer invalidate];
                    _LongPressTimer = nil;
                }
            }
            
            if (!self.IsFocusOn)
            {
                self.MoveMode = SELECT_CELL_NORMAL_MOVE;
            }
            else
            {
                self.MoveMode = SELECT_CELL_FOCUS_ON_MOVE;
            }
            
            
            if (MoveHerizontal != 0)
            {
                _OriginalLocation = TouchLocation;
                [self HorizontalValueChange:MoveHerizontal :self];
            }
            
            if (MoveVertical != 0)
            {
                _OriginalLocation = TouchLocation;
                [self VerticlValueChange: MoveVertical : self];
            }
            
        }
        else
        {
            if (self.superview == nil)
            {
                return;
            }
            
            float MoveVertical = (_OriginalLocation.y - TouchLocation.y);
            float MoveHerizontal = (_OriginalLocation.x - TouchLocation.x);

            // Long Press for delete, or change Index
            self.frame = CGRectMake(self.frame.origin.x - MoveHerizontal , self.frame.origin.y - MoveVertical, self.frame.size.width, self.frame.size.height);
            _OriginalLocation = TouchLocation;
        }
        
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;
}

- (CGPoint) GetLocationPointInSuperview: (NSSet*)touches
{
    UITouch *Touch =  [touches anyObject];
    if (self.superview == nil)
    {
        return CGPointMake(0, 0);
    }
    else
    {
        return [Touch locationInView:self.superview];
    }
}


- (void) LongPressTick :(NSTimer *) ThisTimer
{
    if ((self.MoveMode == SELECT_CELL_NONE
        || self.MoveMode == SELECT_CELL_FOCUS_ON)
        && self.Touched)
    {
        self.MoveMode = SELECT_CELL_LONG_PRRESS_MOVE;
    }
}

//
// ================================

// ============================
// delegate
//

- (void) HorizontalValueChange: (int) ChangeValue : (SelectBarCell *) ThisCell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(HorizontalValueChange::)])
        {
            [self.delegate HorizontalValueChange: ChangeValue : ThisCell];
        }
    }
}

- (void) VerticlValueChange: (int) ChangeValue : (SelectBarCell *) ThisCell
{

    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(VerticlValueChange::)])
        {
            [self.delegate VerticlValueChange: ChangeValue: ThisCell];
        }
    }
}

- (BOOL) IsLongPressModeEnable: (BOOL) Enable : (SelectBarCell *) ThisCell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(IsLongPressModeEnable::)])
        {
            
            return [self.delegate IsLongPressModeEnable: Enable : ThisCell];
        }
    }
    return NO;
}

- (void) ShortPressToSetFocus: (SelectBarCell *) ThisCell
{
    if (self.MoveMode != SELECT_CELL_SHORT_PRESS)
    {
        return;
    }
    else
    {
        self.MoveMode = SELECT_CELL_NONE;
    }
    
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(ShortPressToSetFocus:)])
        {
            [self.delegate ShortPressToSetFocus: ThisCell];
        }
    }
    

}

- (void) CellTouchedChange : (BOOL) Touched : (SelectBarCell *) ThisCell
{

    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(CellTouchedChange::)])
        {
            [self.delegate CellTouchedChange : Touched : ThisCell];
        }
    }
}
//
// ============================

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
