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

@protocol MetronomeBottomViewProtocol <NSObject>
@required

@optional

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

// Middle
@property (strong, nonatomic) IBOutlet UIButton *PlayCurrentCellButton;
@property (strong, nonatomic) IBOutlet UIButton *TapBPMValueButton;

// Buttom
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *DeleteLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;


@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;

@property (getter = GetCurrentDataTable, setter = SetCurrentDataTable:) NSArray *CurrentDataTable;

@property (nonatomic, assign) id<SelectBarProtocol, MetronomeBottomViewProtocol> delegate;


- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable;


@end
