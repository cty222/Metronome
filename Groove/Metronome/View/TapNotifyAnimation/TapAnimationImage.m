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
    NSTimer *_AnimationTimer;

    UIImageView * _CurrentStep1;
    UIImageView * _CurrentStep2;
    
    CGRect _DisplayFrame;
    CGRect _HideFrame;
    BOOL _EnableAnimation;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.Mode = TAP_ALERT_GRAY;
        _DisplayFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _HideFrame = CGRectMake(0, 0, frame.size.width + 1, frame.size.height);
        _CurrentStep1.hidden = NO;
        _CurrentStep2.hidden = YES;
    }
    return self;
}

- (float) AnimationDelayTime
{
    return 0.5;
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
        self.ImageGrayStep1.hidden = _CurrentStep1.hidden;
        self.ImageGrayStep2.hidden = _CurrentStep2.hidden;
        self.ImageRedStep1.hidden = YES;
        self.ImageRedStep2.hidden = YES;
        _CurrentStep1 = self.ImageGrayStep1;
        _CurrentStep2 = self.ImageGrayStep2;
    }
    else
    {
        self.ImageGrayStep1.hidden = YES;
        self.ImageGrayStep2.hidden = YES;
        self.ImageRedStep1.hidden = _CurrentStep1.hidden;
        self.ImageRedStep2.hidden = _CurrentStep2.hidden;
        _CurrentStep1 = self.ImageRedStep1;
        _CurrentStep2 = self.ImageRedStep2;
    }
}

- (BOOL) GetHidden
{
    return [super isHidden];
}

- (void) SetHidden:(BOOL)hidden
{
    if (hidden == self.hidden)
    {
        return;
    }
    
    [super setHidden:hidden];
    if(self.hidden)
    {
        [self StopAnimation];
        self.Mode = TAP_ALERT_GRAY;
    }
    else
    {
        [self PlayAnimation];
    }
}

- (void) PlayAnimation
{
    if (self.hidden)
    {
        return;
    }

    _EnableAnimation = YES;
    [self AnitmationPushUp];
}

- (void) StopAnimation
{
    [self.AnimateWorkVeiw.layer removeAllAnimations];
    _EnableAnimation = NO;
}

- (void) AnitmationPushDown
{
    if (!_EnableAnimation)
    {
        return;
    }

    // Workaround : 用一個看不見的view來驅動animate
    // show and hidden 不能驅動 animate
    self.AnimateWorkVeiw.frame = _HideFrame;

    [UIView animateWithDuration:0
                          delay:[self AnimationDelayTime]
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.AnimateWorkVeiw.frame = _DisplayFrame;
                     }
                     completion:^(BOOL finished){
                         _CurrentStep1.hidden = YES;
                         _CurrentStep2.hidden = NO;
                         [self AnitmationPushUp];
                     }];
}

- (void) AnitmationPushUp
{
    if (!_EnableAnimation)
    {
        return;
    }
    self.AnimateWorkVeiw.frame = _HideFrame;

    // Workaround : 用一個看不見的view來驅動animate
    // show and hidden 不能驅動 animate
    [UIView animateWithDuration:0
                          delay:[self AnimationDelayTime]
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.AnimateWorkVeiw.frame = _DisplayFrame;
                     }
                     completion:^(BOOL finished){
                         _CurrentStep1.hidden = NO;
                         _CurrentStep2.hidden = YES;
                         [self AnitmationPushDown];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
