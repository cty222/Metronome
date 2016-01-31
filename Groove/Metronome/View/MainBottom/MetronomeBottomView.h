//
//  MetronomeBottomView.h
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//
#import "XibViewInterface.h"
#import "MetronomeSelectBar.h"
#import "GlobalServices.h"
#import "GlobalConfig.h"
#import "CircleButton.h"
#import "UINSOperation.h"


@interface MetronomeBottomView : XibViewInterface <CircleButtonProtocol>
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *metronomeCellsSelector;

// Volume button
@property (strong, nonatomic) IBOutlet CircleButton *accentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *quarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *eighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *sixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *trippleNoteCircleVolumeButton;
// loop button
@property (strong, nonatomic) IBOutlet UIButton *playCurrentCellButton;


- (void) resetVolumeSets;
- (void) setVolumeBarVolume : (TempoCell *)cell;
@end
