//
//  MetronomeMainViewControllerIphone.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

// View
#import "MetronmoneTopSubViewIphone.h"
#import "MetronomeBottomSubViewIphone.h"
#import "MetronomeSelectBar.h"

// Tools
#import "NotesTool.h"
#import "AudioPlay.h"

typedef enum {
    STOP_PLAYING         = 0,
    SINGLE_PLAYING,
    LOOP_PLAYING,
} METRONOME_PLAYING_MODE;

@interface MetronomeMainViewControllerIphone : UIViewController <NoteProtocol, SelectBarProtocol, MetronomeBottomViewProtocol, LargeBPMPickerProtocol>
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (nonatomic) MetronmoneTopSubViewIphone *TopSubView;
@property (nonatomic) MetronomeBottomSubViewIphone *BottomSubView;


@property (nonatomic, strong) BeepBound* CurrentVoice;
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;
@property (getter = GetPlayingMode, setter = SetPlayingMode:) METRONOME_PLAYING_MODE PlayingMode;

@end
