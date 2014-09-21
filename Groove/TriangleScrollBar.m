//
//  TriangleScrollBar.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "TriangleScrollBar.h"

@implementation TriangleScrollBar
{
    CGRect _CloseFrame;
    CGRect _OpenFrame;
    BOOL _Opened;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self Initialize];

}

- (void) Initialize
{
    _OpenFrame = CGRectMake(0, 0, 320, 300);
    _CloseFrame = CGRectMake(57, 115, _OpenFrame.size.width, _OpenFrame.size.height);
    self.bounds = CGRectMake(0, 0, _OpenFrame.size.width, _OpenFrame.size.height);
    
    self.Opened = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (BOOL) GetOpened
{
    return _Opened;
}
- (void) SetOpened:(BOOL)NewValue
{

    NSLog(@"????????");
    _Opened = NewValue;
    if (!_Opened) {
        self.frame = _CloseFrame;
    }
    else
    {
        self.frame = _OpenFrame;
    }
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
