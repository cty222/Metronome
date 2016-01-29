//
//  TopPartOfMetronomeViewController.h
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalServices.h"

#import "BPMPickerViewController.h"
#import "SubPropertySelector.h"
#import "TimeSignaturePickerView.h"
#import "VoiceTypePickerView.h"
#import "LoopCellEditerView.h"
#import "TapAnimationImage.h"
#import "TapFunction.h"
#import "PlayerForSongs.h"

@interface TopPartOfMetronomeViewController : UIViewController <LargeBPMPickerProtocol, SubPropertySelectorProtocol >

@property (strong, nonatomic) BPMPickerViewController *bpmPickerViewController;
@property (strong, nonatomic) IBOutlet UIView *bpmPicker;
@property (strong, nonatomic) IBOutlet TimeSignaturePickerView *timeSignaturePickerView;
@property (strong, nonatomic) IBOutlet VoiceTypePickerView *voiceTypePickerView;
@property (strong, nonatomic) IBOutlet LoopCellEditerView *loopCellEditorView;
@property (strong, nonatomic) IBOutlet UIScrollView *optionScrollView;
@property (strong, nonatomic) IBOutlet UIButton *timeSigatureDisplayPickerButton;
@property (strong, nonatomic) IBOutlet UIButton *voiceTypeDisplayPickerButton;
@property (strong, nonatomic) IBOutlet UIButton *loopCellDisplayEditorButton;
@property (strong, nonatomic) IBOutlet TapAnimationImage *tapAnimationImage;
@property (strong, nonatomic) IBOutlet UIButton *playCellListButton;
@property (strong, nonatomic) IBOutlet UIButton *playMusicButton;
@property (strong, nonatomic) IBOutlet UIButton *systemButton;
@property (strong, nonatomic) IBOutlet UIButton *addLoopCellButton;

- (id) initWithGlobalServices: (GlobalServices *) globalService;
- (void) changeVoiceTypePickerImage: (int) TagNumber;

@end
