//
//  DrumVoice1.m
//  Groove
//
//  Created by C-ty on 2015/1/10.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "DrumVoice1.h"

@implementation DrumVoice1
//================================
// It need to be override
//================================
- (void) InitializeVoicePath
{
    self.AccentPath = [[NSBundle mainBundle] pathForResource:@"BassDrum" ofType:@"wav"];
    self.FirstBeatPath = [[NSBundle mainBundle] pathForResource:@"HiHatsOpen" ofType:@"wav"];
    self.AndBeatPath = [[NSBundle mainBundle] pathForResource:@"HiHatsClose" ofType:@"wav"];
    self.EBeatPath = [[NSBundle mainBundle] pathForResource:@"HiHatsClose" ofType:@"wav"];
    self.ABeatPath = [[NSBundle mainBundle] pathForResource:@"HiHatsClose" ofType:@"wav"];
    self.TicBeatPath = [[NSBundle mainBundle] pathForResource:@"RideHard" ofType:@"wav"];
    self.TocBeatPath = [[NSBundle mainBundle] pathForResource:@"RideHard" ofType:@"wav"];
}
@end
