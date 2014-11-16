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
    NSTimer *_LongPressTimer;
    
    float _LongPressSecond;
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
        self.LongPressSecond = 0.8;
        self.VerticalSensitivity = 4;
        self.HorizontalSensitivity = 1;
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
    _Touched = NewValue;
    if (_Touched)
    {

        
        
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
        self.MoveMode = SELECT_CELL_NONE;
    }
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) SetMoveMode : (SELECT_CELL_MOVE_MODE) NewValue
{
     NSLog(@"Index %d, SetMoveMode",self.IndexNumber);

    if (NewValue >= SELECT_CELL_MODE_END || NewValue < SELECT_CELL_NONE)
    {
        NewValue = SELECT_CELL_NONE;
    }
    
    if (NewValue == SELECT_CELL_LONG_PRRESS_MOVE)
    {
        NSLog(@"Index %d, 1",self.IndexNumber);
        self.CurrentDisplayView = self.LongPressImage;
        _MoveMode = SELECT_CELL_LONG_PRRESS_MOVE;
    }
    else if (NewValue == SELECT_CELL_FOCUS_ON_MOVE || (self.IsFocusOn && _MoveMode == SELECT_CELL_NORMAL_MOVE))
    {
        NSLog(@"Index %d, 2",self.IndexNumber);

        self.CurrentDisplayView = self.FocusImage;
        _MoveMode = SELECT_CELL_FOCUS_ON_MOVE;

    }
    else if (NewValue == SELECT_CELL_FOCUS_ON || self.IsFocusOn)
    {
        NSLog(@"Index %d, 3",self.IndexNumber);

        self.CurrentDisplayView = self.FocusImage;
        _MoveMode = SELECT_CELL_FOCUS_ON;

    }
    else
    {
        NSLog(@"Index %d, 4",self.IndexNumber);

        self.CurrentDisplayView = self.NoramlImage;
        _MoveMode = NewValue;
    }


}

- (SELECT_CELL_MOVE_MODE) GetMoveMode
{

    return _MoveMode;
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
    _OriginalLocation = [self GetLocationPoint: touches];
    
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
        
        if (self.MoveMode != SELECT_CELL_LONG_PRRESS_MOVE)
        {
            self.MoveMode = SELECT_CELL_NORMAL_MOVE;
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
            // Long Press for delete, or change Index
        }
        
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;
    //[self PassTouchedCancelled:touches withEvent:event];

}

- (CGPoint) GetLocationPoint: (NSSet*)touches
{
    UITouch *Touch =  [touches anyObject];
    return [Touch locationInView:Touch.view];
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

- (BOOL) LongPressModeEnable: (SelectBarCell *) ThisCell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(LongPressModeEnable:)])
        {
            return [self.delegate LongPressModeEnable: ThisCell];
        }
    }
    return NO;
}

- (void) ShortPressToSetFocus: (SelectBarCell *) ThisCell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(ShortPressToSetFocus:)])
        {
            [self.delegate ShortPressToSetFocus: ThisCell];
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
