//
//  TmpVerticalSlider.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "TmpVerticalSlider.h"

@implementation TmpVerticalSlider

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x -40, frame.origin.y + 70 , frame.size.height, frame.size.width);

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI + M_PI_2); //180 + 90 degree
        self.transform = trans;
        
        self.maximumValue = 10;
        self.minimumValue = -1;
        
        NSLog(@"%@", self);
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

@end
