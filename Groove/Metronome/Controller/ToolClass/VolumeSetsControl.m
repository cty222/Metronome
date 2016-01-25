//
//  VolumeSetsControl.m
//  Groove
//
//  Created by C-ty on 2015/1/28.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "VolumeSetsControl.h"
#import "MetronomeMainViewController.h"


@interface VolumeSetsControl ()

@property MetronomeMainViewController *Parent;

@end

@implementation VolumeSetsControl

-(id) init : (id) Parent
{
    self = [super init];
    if (self && [NSStringFromClass([Parent class]) isEqualToString:@"MetronomeMainViewController"]){
        self.Parent = Parent;
        self.AccentCircleVolumeButton = self.Parent.volumeBottomSubview.AccentCircleVolumeButton;
        self.QuarterCircleVolumeButton = self.Parent.volumeBottomSubview.QuarterCircleVolumeButton;
        self.EighthNoteCircleVolumeButton = self.Parent.volumeBottomSubview.EighthNoteCircleVolumeButton;
        self.SixteenthNoteCircleVolumeButton = self.Parent.volumeBottomSubview.SixteenthNoteCircleVolumeButton;
        self.TrippleNoteCircleVolumeButton = self.Parent.volumeBottomSubview.TrippleNoteCircleVolumeButton;
        [self InitializeVolumeSets];
    }
    else{
        NSLog(@"VolumeSetsControl Initialize failed!!!");
    }
    return self;
}

- (void) ResetVolumeSets
{
    [self.AccentCircleVolumeButton ResetHandle];
    [self.QuarterCircleVolumeButton ResetHandle];
    [self.EighthNoteCircleVolumeButton ResetHandle];
    [self.SixteenthNoteCircleVolumeButton ResetHandle];
    [self.TrippleNoteCircleVolumeButton ResetHandle];
}

-(void) InitializeVolumeSets
{
    self.AccentCircleVolumeButton.delegate = self;
    self.QuarterCircleVolumeButton.delegate = self;
    self.EighthNoteCircleVolumeButton.delegate = self;
    self.SixteenthNoteCircleVolumeButton.delegate = self;
    self.TrippleNoteCircleVolumeButton.delegate = self;
    
    CIRCLEBUTTON_RANGE VolumeRange;
    VolumeRange.MaxIndex = 10.0;
    VolumeRange.MinIndex = 0;
    VolumeRange.UnitValue = 0.1;
    
    self.AccentCircleVolumeButton.IndexRange = VolumeRange;
    self.AccentCircleVolumeButton.IndexValueSensitivity = 1;
    self.AccentCircleVolumeButton.tag = AccentCircle_Button;
    
    self.QuarterCircleVolumeButton.IndexRange = VolumeRange;
    self.QuarterCircleVolumeButton.IndexValueSensitivity = 1;
    self.QuarterCircleVolumeButton.tag = QuarterCircle_Button;
    
    self.EighthNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.EighthNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.EighthNoteCircleVolumeButton.tag = EighthNoteCircle_Button;
    
    self.SixteenthNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.SixteenthNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.SixteenthNoteCircleVolumeButton.tag = SixteenthNoteCircle_Button;
    
    self.TrippleNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.TrippleNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.TrippleNoteCircleVolumeButton.tag = TrippleNoteCircle_Button;
}


- (void) SetVolumeBarVolume : (TempoCell *)Cell
{
    self.AccentCircleVolumeButton.IndexValue = [Cell.accentVolume floatValue];
    self.QuarterCircleVolumeButton.IndexValue = [Cell.quarterNoteVolume floatValue];
    self.EighthNoteCircleVolumeButton.IndexValue = [Cell.eighthNoteVolume floatValue];
    self.SixteenthNoteCircleVolumeButton.IndexValue = [Cell.sixteenNoteVolume floatValue];
    self.TrippleNoteCircleVolumeButton.IndexValue = [Cell.trippleNoteVolume floatValue];
}

- (IBAction) CircleButtonValueChanged:(CircleButton*) ThisCircleButton;
{
    float Value = ThisCircleButton.IndexValue;
    switch (ThisCircleButton.tag) {
        case AccentCircle_Button:
            self.Parent.engine.currentCell.accentVolume = [NSNumber numberWithFloat:Value];
            break;
        case QuarterCircle_Button:
            self.Parent.engine.currentCell.quarterNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case EighthNoteCircle_Button:
            self.Parent.engine.currentCell.eighthNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case SixteenthNoteCircle_Button:
            self.Parent.engine.currentCell.sixteenNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case TrippleNoteCircle_Button:
            self.Parent.engine.currentCell.trippleNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        default:
            break;
    }
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
}
@end
