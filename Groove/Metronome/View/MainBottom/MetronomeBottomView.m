//
//  MetronomeBottomView.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeBottomView.h"

@implementation MetronomeBottomView
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
        
        [self.metronomeCellsSelector removeFromSuperview];
        self.metronomeCellsSelector = [[MetronomeSelectBar alloc] initWithFrame:self.metronomeCellsSelector.frame];
        [self addSubview:self.metronomeCellsSelector];
        
        int index = 0;
        for(index = 0; index <= LastNoteCircleButton; index++){
            [self createVolumeButton: index];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(twicklingCircleButton:)
                                                     name:kCircleButtonTwickLing
                                                   object:nil];
     
    }
    return self;
}

// =======================
// public methods
//
- (void) resetVolumeSets
{
    [self.accentCircleVolumeButton resetHandle];
    [self.quarterCircleVolumeButton resetHandle];
    [self.eighthNoteCircleVolumeButton resetHandle];
    [self.sixteenthNoteCircleVolumeButton resetHandle];
    [self.trippleNoteCircleVolumeButton resetHandle];
}

- (void) setVolumeBarVolume: (TempoCell *)cell
{
    self.accentCircleVolumeButton.IndexValue = [cell.accentVolume floatValue];
    self.quarterCircleVolumeButton.IndexValue = [cell.quarterNoteVolume floatValue];
    self.eighthNoteCircleVolumeButton.IndexValue = [cell.eighthNoteVolume floatValue];
    self.sixteenthNoteCircleVolumeButton.IndexValue = [cell.sixteenNoteVolume floatValue];
    self.trippleNoteCircleVolumeButton.IndexValue = [cell.trippleNoteVolume floatValue];
}

- (void)twicklingCircleButton:(NSNotification *)notification {
    __CircleButton btnTag = [((NSNumber *)notification.object) intValue];
    CircleButton * tagertButton = [self getCircleButtonByTagNumber:btnTag];
    if (tagertButton){
        [tagertButton twickLing];
    }
}

//
// =======================

// =======================
// private methods
- (CircleButton *) getCircleButtonByTagNumber: (__CircleButton) btnTag{
    CircleButton * tagertButton = nil;
    switch (btnTag) {
        case AccentCircleButton:
            tagertButton = self.accentCircleVolumeButton;
            break;
        case QuarterCircleButton:
            tagertButton = self.quarterCircleVolumeButton;
            break;
        case EighthNoteCircleButton:
            tagertButton = self.eighthNoteCircleVolumeButton;
            break;
        case SixteenthNoteCircleButton:
            tagertButton = self.sixteenthNoteCircleVolumeButton;
            break;
        case TrippleNoteCircleButton:
            tagertButton = self.trippleNoteCircleVolumeButton;
            break;
    }
    return tagertButton;
}

-(void) createVolumeButton: (__CircleButton)tagName
{
    CircleButton *targetButton = nil;
    CircleButton *newButton = nil;
    switch(tagName){
        case AccentCircleButton:
            targetButton = self.accentCircleVolumeButton;
            newButton = [[CircleButton alloc] initWithFrame:targetButton.frame];
            newButton.signPicture.image = [UIImage imageNamed:@"AccentNoteGary"];
            newButton.twickPicture.image = [UIImage imageNamed:@"AccentNoteRed"];
            self.accentCircleVolumeButton = newButton;
            break;
        case QuarterCircleButton:
            targetButton = self.quarterCircleVolumeButton;
            newButton = [[CircleButton alloc] initWithFrame:targetButton.frame];
            newButton.signPicture.image = [UIImage imageNamed:@"QuarterNoteGary"];
            newButton.twickPicture.image = [UIImage imageNamed:@"QuarterNoteRed"];
            self.quarterCircleVolumeButton = newButton;
            break;
        case EighthNoteCircleButton:
            targetButton = self.eighthNoteCircleVolumeButton;
            newButton = [[CircleButton alloc] initWithFrame:targetButton.frame];
            newButton.signPicture.image = [UIImage imageNamed:@"8NoteGary"];
            newButton.twickPicture.image = [UIImage imageNamed:@"8NoteRed"];
            self.eighthNoteCircleVolumeButton = newButton;
            break;
        case SixteenthNoteCircleButton:
            targetButton = self.sixteenthNoteCircleVolumeButton;
            newButton = [[CircleButton alloc] initWithFrame:targetButton.frame];
            newButton.signPicture.image = [UIImage imageNamed:@"16NoteGary"];
            newButton.twickPicture.image = [UIImage imageNamed:@"16NoteRed"];
            self.sixteenthNoteCircleVolumeButton = newButton;
            break;
        case TrippleNoteCircleButton:
            targetButton = self.trippleNoteCircleVolumeButton;
            newButton = [[CircleButton alloc] initWithFrame:targetButton.frame];
            newButton.signPicture.image = [UIImage imageNamed:@"TrippleNoteGary"];
            newButton.twickPicture.image = [UIImage imageNamed:@"TrippleNoteRed"];
            self.trippleNoteCircleVolumeButton = newButton;
            break;
    }
    [targetButton removeFromSuperview];
    [self addSubview:newButton];
    newButton.tag = tagName;
    
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
