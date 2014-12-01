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
        
        [self.AccentCircleVolumeButton removeFromSuperview];
        self.AccentCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.AccentCircleVolumeButton.frame];
        self.AccentCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"AccentNote"];
        [self addSubview:self.AccentCircleVolumeButton];

        [self.QuarterCircleVolumeButton removeFromSuperview];
        self.QuarterCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.QuarterCircleVolumeButton.frame];
        self.QuarterCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"QuarterNote"];
        [self addSubview:self.QuarterCircleVolumeButton];

        [self.EighthNoteCircleVolumeButton removeFromSuperview];
        self.EighthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.EighthNoteCircleVolumeButton.frame];
        self.EighthNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"8Note"];
        [self addSubview:self.EighthNoteCircleVolumeButton];

        [self.SixteenthNoteCircleVolumeButton removeFromSuperview];
        self.SixteenthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.SixteenthNoteCircleVolumeButton.frame];
        self.SixteenthNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"16Note"];
        [self addSubview:self.SixteenthNoteCircleVolumeButton];

        [self.TrippleNoteCircleVolumeButton removeFromSuperview];
        self.TrippleNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.TrippleNoteCircleVolumeButton.frame];
        self.TrippleNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"TrippleNote"];
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
