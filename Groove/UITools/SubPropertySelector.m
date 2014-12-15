//
//  SubPropertySelector.m
//  Groove
//
//  Created by C-ty on 2014/11/26.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SubPropertySelector.h"

@interface SubPropertySelector ()
@end

@implementation SubPropertySelector
{
    BOOL _hidden;
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(TouchedNotificationCallBack:)
                                                     name:kTouchGlobalHookNotification
                                                   object:nil];
        NSLog(@"%@", self);
    }
    return self;
}


- (BOOL) GetHidden
{
    return _hidden;
}

- (void) SetHidden:(BOOL)hidden
{
    _hidden = hidden;
    [super setHidden:_hidden];
    if(_hidden)
    {
    }
    else
    {
        [self.superview bringSubviewToFront:self];
        [self ChangeTriggleViewCenterline: self.ArrowCenterLine];
    }
}

- (void) ChangeTriggleViewCenterline :(float) TriggerViewCenterLineValue
{
    if (self.superview != nil)
    {
        self.ArrowView.frame = CGRectMake(self.ArrowView.frame.origin.x, (TriggerViewCenterLineValue - self.ArrowView.frame.size.height/2 + self.OriginYOffset), self.ArrowView.frame.size.width, self.ArrowView.frame.size.height);
        [self.superview bringSubviewToFront:self];
    }
}

- (IBAction)ClickCell: (id) sender
{
    [self ChangeValue:self :sender];
}

- (IBAction)ChangeValue: (id)RootSuperView : (id) ChooseCell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(ChangeValue::)])
        {
            [self.delegate ChangeValue: self : ChooseCell];
        }
    }
}

- (void)TouchedNotificationCallBack:(NSNotification *)Notification
{
    UIEvent *Event = [Notification object];
    NSSet *touches = [Event allTouches];
    UITouch *touch = [touches anyObject];
    UIView * target = [touch view];
    
    // Important!! : Scroll is nil
    if (target == nil)
    {
        return;
    }
    
    if (![self IsIncludeTargetView: target])
    {
        self.hidden = YES;
    }
}

- (BOOL) IsIncludeTargetView: (UIView *) TargetView
{
    if (TargetView == self || TargetView == self.ContentScrollView || TargetView == self.TriggerButton)
    {
        return YES;
    }
    else
    {
        for (int Index = 0; Index < self.ContentScrollView.subviews.count; Index++) {

            if (TargetView == self.ContentScrollView.subviews[Index])
            {
                return YES;
            }
        }
        return NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
