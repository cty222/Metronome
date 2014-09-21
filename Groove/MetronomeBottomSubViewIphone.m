//
//  MetronomeBottomSubViewIphone.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeBottomSubViewIphone.h"

@implementation MetronomeBottomSubViewIphone

- (void) awakeFromNib
{
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.VolumeSet removeFromSuperview];
        self.VolumeSet = [[VolumeBarSet alloc] initWithFrame:self.VolumeSet.frame];
        [self addSubview:self.VolumeSet];
       
        [self.SelectGrooveBar removeFromSuperview];
        self.SelectGrooveBar = [[MetronomeSelectBar alloc] initWithFrame:self.SelectGrooveBar.frame];
        [self addSubview:self.SelectGrooveBar];
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
