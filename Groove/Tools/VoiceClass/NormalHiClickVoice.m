//
//  NomalHiClickVoice.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "NormalHiClickVoice.h"

@implementation NormalHiClickVoice

//================================
// It need to be override
//================================
- (void) InitializeVoicePath
{
    self.AccentPath = [[NSBundle mainBundle] pathForResource:@"Accent_Hi" ofType:@"wav"];
    self.FirstBeatPath = [[NSBundle mainBundle] pathForResource:@"Quarter_Hi" ofType:@"wav"];
    self.AndBeatPath = [[NSBundle mainBundle] pathForResource:@"And_Hi" ofType:@"wav"];
    self.EBeatPath = [[NSBundle mainBundle] pathForResource:@"E_Hi" ofType:@"wav"];
    self.ABeatPath = [[NSBundle mainBundle] pathForResource:@"E_Hi" ofType:@"wav"];
    self.TicBeatPath = [[NSBundle mainBundle] pathForResource:@"Tic_Hi" ofType:@"wav"];
    self.TocBeatPath = [[NSBundle mainBundle] pathForResource:@"Tic_Hi" ofType:@"wav"];
}
@end
