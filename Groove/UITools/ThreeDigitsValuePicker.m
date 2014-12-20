//
//  ThreeDigitsValuePicker.m
//  Groove
//
//  Created by C-ty on 2014/12/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "ThreeDigitsValuePicker.h"

@implementation ThreeDigitsValuePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// Override !!
- (int) Sensitivity
{
    return 1;
}

- (void) SyncValueLabelFromValue
{
    [self.ValueLabel setText:[NSString stringWithFormat:@"%03d", (int)self.Value]];
}

@end
