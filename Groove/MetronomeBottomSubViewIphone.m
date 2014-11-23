//
//  MetronomeBottomSubViewIphone.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeBottomSubViewIphone.h"

@implementation MetronomeBottomSubViewIphone
{
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self.SelectGrooveBar removeFromSuperview];
        self.SelectGrooveBar = [[MetronomeSelectBar alloc] initWithFrame:self.SelectGrooveBar.frame];
        [self addSubview:self.SelectGrooveBar];
        
        // Back ground
        self.backgroundColor = [UIColor whiteColor];
       
        [self.AccentCircleVolumeButton removeFromSuperview];
        self.AccentCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.AccentCircleVolumeButton.frame];
        [self addSubview:self.AccentCircleVolumeButton];

        [self.QuarterCircleVolumeButton removeFromSuperview];
        self.QuarterCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.QuarterCircleVolumeButton.frame];
        [self addSubview:self.QuarterCircleVolumeButton];

        [self.EighthNoteCircleVolumeButton removeFromSuperview];
        self.EighthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.EighthNoteCircleVolumeButton.frame];
        [self addSubview:self.EighthNoteCircleVolumeButton];

        [self.SixteenthNoteCircleVolumeButton removeFromSuperview];
        self.SixteenthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.SixteenthNoteCircleVolumeButton.frame];
        [self addSubview:self.SixteenthNoteCircleVolumeButton];

        [self.TrippleNoteCircleVolumeButton removeFromSuperview];
        self.TrippleNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.TrippleNoteCircleVolumeButton.frame];
        [self addSubview:self.TrippleNoteCircleVolumeButton];
       
    }
    return self;
}



//
// =================================


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
