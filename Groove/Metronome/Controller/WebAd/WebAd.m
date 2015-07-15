//
//  WebAd.m
//  RockClick
//
//  Created by C-ty on 2015/7/15.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "WebAd.h"

@implementation WebAd

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// ============================
// delegate
//
- (IBAction) closeWebAdEvent: (id) sender
{
   
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(closeWebAdEvent:)])
        {
            [self.delegate closeWebAdEvent: sender];
        }
    }
}
//
// ============================

@end
