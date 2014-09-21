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
    int _BPMValue;
    int _BPMMax;
    int _BPMMin;
    
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    NSTimer *ArrowCancellTimer;
    NSTimer *ArrowLongPushTimer;
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
    return self;
}

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

// ===========================
//
//
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
    self.LebalBPMValue.text = [NSString stringWithFormat:@"%d", _BPMValue];
}
//
// ===========================
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
    }
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) TouchBeginEvent : (CGPoint) TouchLocation
{
    OriginalLocation.x = TouchLocation.x;
    OriginalLocation.y = TouchLocation.y;
    self.Touched = YES;
}

- (void) TouchEndEvent : (CGPoint) TouchLocation
{
    self.Touched = NO;
}

- (void) TouchMoveEvent : (CGPoint) TouchLocation
{
    if (self.Touched)
    {
        // Because zero point is on left top, large point in on right bottom
        int MoveUp = (OriginalLocation.y - TouchLocation.y) / [self Sensitivity];
        if (MoveUp != 0)
        {
            self.BPMValue += MoveUp;
            OriginalLocation = TouchLocation;
        }
    }
}

- (void) TouchCancellEvent : (CGPoint) TouchLocation
{
    self.Touched = NO;
}

- (IBAction) ScrollBPM : (UISwipeGestureRecognizer *) sendor
{

}

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
