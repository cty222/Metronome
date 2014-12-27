//
//  InputSubmitView.m
//  Groove
//
//  Created by C-ty on 2014/12/19.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "InputSubmitView.h"

@implementation InputSubmitView

- (IBAction) Save: (UIButton *) SaveButton
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(Save:)])
        {
            [self.delegate Save: SaveButton];
        }
    }
}

- (IBAction) Cancel : (UIButton *) CancelButton
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(Cancel:)])
        {
            [self.delegate Cancel: CancelButton];
        }
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
