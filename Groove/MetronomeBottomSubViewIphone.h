//
//  MetronomeBottomSubViewIphone.h
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"
#import "VolumeBarSet.h"
#import "MetronomeSelectBar.h"
#import "MetronomeModel.h"

@protocol MetronomeBottomViewProtocol <NSObject>
@required

@optional
- (void) SetFocusIndex:(int) NewValue;
- (int) GetFocusIndex;

- (IBAction) PlayCurrentCellButtonClick: (UIButton *) ThisClickedButton;
- (IBAction) TapBPMValueButtonClick: (UIButton *) ThisClickedButton;
- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton;
- (IBAction) DeleteLoopCellButtonClick: (UIButton *) ThisClickedButton;
- (IBAction) PlayLoopCellButtonClick: (UIButton *) ThisClickedButton;
- (IBAction) VolumeSliderValueChanged:(TmpVerticalSlider*) ThisVerticalSlider;
@end

@interface MetronomeBottomSubViewIphone : XibViewInterface <SelectBarProtocol, VolumeBarSetProtocol>
@property (strong, nonatomic) IBOutlet VolumeBarSet *VolumeSet;
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;

// Sub button
@property (strong, nonatomic) IBOutlet UIButton *PlayCurrentCellButton;
@property (strong, nonatomic) IBOutlet UIButton *TapBPMValueButton;
@property (strong, nonatomic) IBOutlet UIButton *TimeSignatureButton;
@property (strong, nonatomic) IBOutlet UIButton *VoiceButton;

// loop button
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *DeleteLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;

@property (getter = GetCurrentDataTable, setter = SetCurrentDataTable:) NSArray *CurrentDataTable;

@property (nonatomic, assign) id<SelectBarProtocol, MetronomeBottomViewProtocol> delegate;


- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable;
- (void) ChangeSelectBarForcusIndex: (int) NewValue;


@end
