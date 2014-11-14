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


@protocol MetronomeBottomViewProtocol <NSObject>
@required

@optional
- (void) SetFocusIndex:(int) NewValue;
- (int) GetFocusIndex;

@end


@interface MetronomeBottomSubViewIphone : XibViewInterface <SelectBarProtocol>
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;

// loop button
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;

@property (getter = GetCurrentDataTable, setter = SetCurrentDataTable:) NSArray *CurrentDataTable;

@property (nonatomic, assign) id<MetronomeBottomViewProtocol> delegate;

// Ad
@property(nonatomic,retain)IBOutlet ADBannerView *adView;

- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable;
- (void) ChangeSelectBarForcusIndex: (int) NewValue;

@property (strong, nonatomic) IBOutlet CircleButton *AccentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *QuarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *EighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *SixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *TrippleNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *VoiceTypeCircleButton;
@end
