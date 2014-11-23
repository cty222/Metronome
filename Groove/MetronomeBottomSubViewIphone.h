//
//  MetronomeBottomSubViewIphone.h
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//
#import "iAd/iAd.h"

#import "XibViewInterface.h"
#import "MetronomeSelectBar.h"
#import "MetronomeModel.h"
#import "CircleButton.h"

#import "UINSOperation.h"


@interface MetronomeBottomSubViewIphone : XibViewInterface
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;

// Volume button
@property (strong, nonatomic) IBOutlet CircleButton *AccentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *QuarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *EighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *SixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *TrippleNoteCircleVolumeButton;

// loop button
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayCurrentCellButton;

// Ad view
@property(nonatomic,retain)IBOutlet ADBannerView *adView;

@end
