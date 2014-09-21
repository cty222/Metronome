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
        
        [self.TriangleView removeFromSuperview];
        self.TriangleView = [[TriangleScrollBar alloc] initWithFrame:self.TriangleView.frame];
        [self addSubview:self.TriangleView];
        
        [self bringSubviewToFront:self.VolumeSet];
        self.TriangleView.Opened = YES;
        
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
