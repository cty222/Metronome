//
//  LargeBPMPicker.m
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LargeBPMPicker.h"

@implementation LargeBPMPicker
{
    // Picture Array
    NSMutableArray * Digits;
    
    int _BPMValue;
    int _BPMMax;
    int _BPMMin;
    
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    NSTimer *ArrowCancellTimer;
    NSTimer *ArrowLongPushTimer;
    
    // Short press
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
    return 5;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self Initialize];
}

-(void) Initialize
{
    _BPMMax = [[GlobalConfig BPMMaxValue] intValue];
    _BPMMin = [[GlobalConfig BPMMinValue] intValue];

    self.BPMValue = 120;
    self.ShortPressSecond = 0.5;

    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
    CALayer *DownArrowLayer = self.DownArrow.layer;
    [DownArrowLayer setAffineTransform:rotation];
    
    self.UpArrow.userInteractionEnabled = NO;
    self.DownArrow.userInteractionEnabled = NO;

    self.UpArrow.hidden = YES;
    self.DownArrow.hidden = YES;
    self.Touched = NO;
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
#if DIGIT_ENABLE_FLAG
    Digits = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++)
    {
        int TmpIndex = i;
        if (TmpIndex > 1)
        {
            TmpIndex = TmpIndex %2;
        }
        NSString *ImageName = [NSString stringWithFormat:@"reflect_number_%d", TmpIndex];
        UIGraphicsBeginImageContext(self.DigitInOnces.frame.size);
        [[UIImage imageNamed:ImageName] drawInRect:self.DigitInOnces.bounds];
        UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [Digits addObject:Image];
    }
    
    self.DigitInHundreds.userInteractionEnabled = NO;
    self.DigitInTens.userInteractionEnabled = NO;
    self.DigitInOnces.userInteractionEnabled = NO;
#endif

    return self;
}

// NO Use
- (id) init
{
    self = [super init];
    if (self) {
        // If set this enable, the touch will send event to lebal
        // self.LebalBPMValue.userInteractionEnabled = YES;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (int) GetBPMValue
{
    return _BPMValue;
}

- (void) SetBPMValue : (int) NewValue
{
    if (NewValue > _BPMMax || NewValue < _BPMMin)
    {
        return;
    }
    
    _BPMValue = NewValue;
    
#if DIGIT_ENABLE_FLAG
    if (_BPMValue/100 == 0)
    {
        self.DigitInHundreds.hidden = YES;
    }
    else
    {
        self.DigitInHundreds.hidden = NO;
    }
    
    self.DigitInHundreds.backgroundColor = [UIColor colorWithPatternImage:Digits[_BPMValue/100]];
    self.DigitInTens.backgroundColor = [UIColor colorWithPatternImage:Digits[(_BPMValue%100)/10]];
    self.DigitInOnces.backgroundColor = [UIColor colorWithPatternImage:Digits[_BPMValue%10]];
#else
    [self.ValueLabel setText:[NSString stringWithFormat:@"%d", self.BPMValue]];
#endif
    
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetBPMValue:)])
        {
            [self.delegate SetBPMValue: _BPMValue];
        }
    }
}
//
// ===========================

// ============================
// delegate
//
- (void) ShortPress: (LargeBPMPicker *) ThisPicker
{
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

- (void) CheckTouchBPMValueArrow : (CGPoint) TouchLocation
{
    if (!self.Touched)
    {
        return;
    }
    
    BOOL LongPushFlag = NO;
    CGRect UpArrowFrame = self.UpArrow.frame;
    CGRect DownArrowFrame = self.DownArrow.frame;
    
    if ((TouchLocation.x > UpArrowFrame.origin.x && TouchLocation.x < UpArrowFrame.origin.x + UpArrowFrame.size.width) && (TouchLocation.y > UpArrowFrame.origin.y && TouchLocation.y < UpArrowFrame.origin.y + UpArrowFrame.size.height))
    {
        self.BPMValue++;
        LongPushFlag = YES;
    }
    else if((TouchLocation.x > DownArrowFrame.origin.x && TouchLocation.x < DownArrowFrame.origin.x + DownArrowFrame.size.width) && (TouchLocation.y > DownArrowFrame.origin.y && TouchLocation.y < DownArrowFrame.origin.y + DownArrowFrame.size.height))
    {
        self.BPMValue--;
        LongPushFlag = YES;
    }
    
    if (LongPushFlag && ArrowLongPushTimer == nil)
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
        if (self.UpArrow.hidden == NO)
        {
            [self CheckTouchBPMValueArrow: OriginalLocation];
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
        if (_PressTime_ms != 0)
        {
            double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
            if ((CurrentRecordTime_ms -_PressTime_ms) < self.ShortPressSecond * 1000.0)
            {
                [self ShortPress:self];
            }
        }
        
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
            self.BPMValue += MoveUp;
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
}

- (void) ArrowLongPushTicker: (NSTimer *) ThisTimer
{
    [self CheckTouchBPMValueArrow: OriginalLocation];
}


//========
@end
