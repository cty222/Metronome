//
//  SelectBarCell.m
//  Groove
//
//  Created by C-ty on 2014/11/16.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SelectBarCell.h"

#define LONG_PRESS_ENABLE 0

@interface SelectBarCell ()

@property (strong, nonatomic) IBOutlet UILabel *InnerLabel;
@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetLongPressSecond, setter = SetLongPressSecond:) float LongPressSecond;

@end

@implementation SelectBarCell
{
    // Property
    UIImageView *_CurrentDisplayView;
    BOOL _Touched;
    NSString * _Text;
  
    CGPoint _OriginalLocation;
    
    // Short press
    NSDate * _Date;
    double _PressTime_ms;
    float _ShortPressSecond;

    // Long Press
    NSTimer * _LongPressTimer;
    float _LongPressSecond;
 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
        // Moving event
        
        // Setting
        self.InnerLabel.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        
        self.ShortPressSecond = 0.5;
        self.LongPressSecond = 1.5;
    }
    return self;
}

// ================================
// Property
//
- (void) SetText : (NSString *)NewValue
{
    _Text =  NewValue;
    self.InnerLabel.text = _Text;
}

- (NSString *) GetText
{
    return _Text;
}

-(void) SetTouched: (BOOL) NewValue
{
    if (_Touched == NewValue)
    {
        return;
    }
    
    _Touched = NewValue;
    if (_Touched)
    {
        [self ShortPressCheckStart];

#if LONG_PRESS_ENALE
       if (_LongPressTimer != nil)
        {
            [_LongPressTimer invalidate];
            _LongPressTimer = nil;
        }
        _LongPressTimer = [NSTimer scheduledTimerWithTimeInterval:self.LongPressSecond
                                                         target:self
                                                         selector:@selector(LongPressTick:)
                                                       userInfo:nil
                                                        repeats:YES];
#endif

        

    }
    else
    {
#if LONG_PRESS_ENALE
        if (_LongPressTimer != nil)
        {
            [_LongPressTimer invalidate];
            _LongPressTimer = nil;
        }
#endif
        [self ShortPressCheckEnd];
    }
}

- (BOOL) GetTouched
{
    return _Touched;
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

//
// ================================

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
            [self ShortPressToSetFocus:self];
        }
    }
}


//
// ================================


// ================================
// Touch event
//
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    _OriginalLocation = [self GetLocationPointInSuperview: touches];
    
    self.Touched = YES;

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

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
        return [Touch locationInView:self];
    }
    else
    {
        return [Touch locationInView:self.superview];
    }
}


- (void) LongPressTick :(NSTimer *) ThisTimer
{
    [self LongPressToFocusSelf:self];
}

//
// ================================

// ============================
// delegate
//
- (void) LongPressToFocusSelf: (SelectBarCell *) ThisCell
{
#if LONG_PRESS_ENALE
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(CellLongPress:)])
        {
            [self.delegate CellLongPress: ThisCell];
        }
    }
#endif
}


- (void) ShortPressToSetFocus: (SelectBarCell *) ThisCell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(CellShortPress:)])
        {
            [self.delegate CellShortPress: ThisCell];
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
