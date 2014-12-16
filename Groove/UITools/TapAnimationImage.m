//
//  TapAnimationImage.m
//  Groove
//
//  Created by C-ty on 2014/12/17.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "TapAnimationImage.h"

@implementation TapAnimationImage
{
    TAP_ANIMATION_MODE _Mode;
    BOOL _hidden;
    NSTimer *_AnimationTimer;

    UIImageView * _CurrentStep1;
    UIImageView * _CurrentStep2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.Mode = TAP_ALERT_GRAY;
    }
    return self;
}

- (TAP_ANIMATION_MODE) GetMode
{
    return _Mode;
}

- (void) SetMode : (TAP_ANIMATION_MODE) NewValue
{
    _Mode = NewValue;
    if (_Mode == TAP_ALERT_GRAY)
    {
        self.ImageGrayStep1.hidden = NO;
        self.ImageGrayStep2.hidden = YES;
        self.ImageRedStep1.hidden = YES;
        self.ImageRedStep2.hidden = YES;
        _CurrentStep1 = self.ImageGrayStep1;
        _CurrentStep2 = self.ImageGrayStep2;
    }
    else
    {
        self.ImageGrayStep1.hidden = YES;
        self.ImageGrayStep2.hidden = YES;
        self.ImageRedStep1.hidden = NO;
        self.ImageRedStep2.hidden = YES;
        _CurrentStep1 = self.ImageRedStep1;
        _CurrentStep2 = self.ImageRedStep2;
    }

}

- (BOOL) GetHidden
{
    return _hidden;
}

- (void) SetHidden:(BOOL)hidden
{
    if (hidden == _hidden)
    {
        return;
    }
    
    _hidden = hidden;
    [super setHidden:_hidden];
    if(_hidden)
    {
        NSLog(@"01");
        self.Mode = TAP_ALERT_GRAY;
    }
    else
    {
        if (_AnimationTimer != nil)
        {
            [_AnimationTimer invalidate];
            _AnimationTimer = nil;
        }
        _AnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(TapAnimationTicker:)
                                                           userInfo:nil
                                                            repeats:YES];
    }
}


- (void) TapAnimationTicker: (NSTimer *) ThisTimer
{
    if (self.hidden)
    {
        [ThisTimer invalidate];
        _AnimationTimer = nil;
    }
    
    NSLog(@"TapAnimationStart");

    _CurrentStep1.hidden = !_CurrentStep1.hidden;
    _CurrentStep2.hidden = !_CurrentStep2.hidden;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
