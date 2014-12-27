//
//  SmallLeftValuePicker.m
//  Groove
//
//  Created by C-ty on 2014/12/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "TwoDigitsValuePicker.h"

@implementation TwoDigitsValuePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) SyncValueLabelFromValue
{
    [self.ValueLabel setText:[NSString stringWithFormat:@"%02d", (int)self.Value]];
}

@end
