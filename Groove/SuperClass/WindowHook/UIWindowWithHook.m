//
//  UIWindowWithHook.m
//  Groove
//
//  Created by C-ty on 2014/11/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "UIWindowWithHook.h"

@implementation UIWindowWithHook


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];  // Apple says you must always call this!
    
    if (self.EnableTouchHookNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTouchGlobalHookNotification object:event];
    }
}

@end
