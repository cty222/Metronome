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
        self.AccentCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"AccentNoteGary"];
        self.AccentCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"AccentNoteRed"];
        [self addSubview:self.AccentCircleVolumeButton];

        [self.QuarterCircleVolumeButton removeFromSuperview];
        self.QuarterCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.QuarterCircleVolumeButton.frame];
        self.QuarterCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"QuarterNoteGary"];
        self.QuarterCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"QuarterNoteRed"];
        [self addSubview:self.QuarterCircleVolumeButton];

        [self.EighthNoteCircleVolumeButton removeFromSuperview];
        self.EighthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.EighthNoteCircleVolumeButton.frame];
        self.EighthNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"8NoteGary"];
        self.EighthNoteCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"8NoteRed"];

        [self addSubview:self.EighthNoteCircleVolumeButton];

        [self.SixteenthNoteCircleVolumeButton removeFromSuperview];
        self.SixteenthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.SixteenthNoteCircleVolumeButton.frame];
        self.SixteenthNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"16NoteGary"];
        self.SixteenthNoteCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"16NoteRed"];
        [self addSubview:self.SixteenthNoteCircleVolumeButton];

        [self.TrippleNoteCircleVolumeButton removeFromSuperview];
        self.TrippleNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.TrippleNoteCircleVolumeButton.frame];
        self.TrippleNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"TrippleNoteGary"];
        self.TrippleNoteCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"TrippleNoteRed"];
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
