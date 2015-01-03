//
//  NomalHiClickVoice.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "NomalHiClickVoice.h"

@implementation NomalHiClickVoice

//================================
// It need to be override
//================================
- (void) InitializeVoicePath
{
    self.AccentPath = [[NSBundle mainBundle] pathForResource:@"HiAccent" ofType:@"wav"];
    self.FirstBeatPath = [[NSBundle mainBundle] pathForResource:@"HiFirst" ofType:@"wav"];
    self.AndBeatPath = [[NSBundle mainBundle] pathForResource:@"HiAnd" ofType:@"wav"];
    self.EBeatPath = [[NSBundle mainBundle] pathForResource:@"HiE" ofType:@"wav"];
    self.ABeatPath = [[NSBundle mainBundle] pathForResource:@"HiE" ofType:@"wav"];
    self.GiBeatPath = [[NSBundle mainBundle] pathForResource:@"HiGa" ofType:@"wav"];
    self.GaBeatPath = [[NSBundle mainBundle] pathForResource:@"HiGa" ofType:@"wav"];
}
@end
