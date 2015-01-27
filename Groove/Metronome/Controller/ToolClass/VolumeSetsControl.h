//
//  VolumeSetsControl.h
//  Groove
//
//  Created by C-ty on 2015/1/28.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleButton.h"
#import "GlobalConfig.h"

typedef enum{
    ACCENT_VOLUME_BUTTON = 101,
    QUARTER_VOLUME_BUTTON,
    EIGHTH_NOTE_VOLUME_BUTTON,
    SIXTEENTH_NOTE_VOLUME_BUTTON,
    TRIPPLET_NOTE_VOLUME_BUTTON
} VOLUME_BUTTON_TAG;

@interface VolumeSetsControl : NSObject <CircleButtonProtocol>
// (1) Volume sets
@property (strong, nonatomic) IBOutlet CircleButton *AccentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *QuarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *EighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *SixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *TrippleNoteCircleVolumeButton;

- (id) init : (id) Parent;
- (void) ResetVolumeSets;
- (void) SetVolumeBarVolume : (TempoCell *)Cell;


@end
