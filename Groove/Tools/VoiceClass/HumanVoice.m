//
//  HumanVoice.m
//  Groove
//
//  Created by C-ty on 2015/1/3.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "HumanVoice.h"

@implementation HumanVoice
- (void) InitializeVoicePath
{
    self.AccentPath = [[NSBundle mainBundle] pathForResource:@"One" ofType:@"wav"];
    self.FirstBeatPath = [[NSBundle mainBundle] pathForResource:@"One" ofType:@"wav"];
    self.AndBeatPath = [[NSBundle mainBundle] pathForResource:@"Human_and" ofType:@"wav"];
    self.EBeatPath = [[NSBundle mainBundle] pathForResource:@"Human_e" ofType:@"wav"];
    self.ABeatPath = [[NSBundle mainBundle] pathForResource:@"Human_a" ofType:@"wav"];
    self.GiBeatPath = [[NSBundle mainBundle] pathForResource:@"Human_Gi" ofType:@"wav"];
    self.GaBeatPath = [[NSBundle mainBundle] pathForResource:@"Human_Ga" ofType:@"wav"];
    
    self.TwoBeatPath = [[NSBundle mainBundle] pathForResource:@"Two" ofType:@"wav"];
    self.ThreeBeatPath = [[NSBundle mainBundle] pathForResource:@"Three" ofType:@"wav"];
    self.FourBeatPath = [[NSBundle mainBundle] pathForResource:@"Four" ofType:@"wav"];
    self.FiveBeatPath = [[NSBundle mainBundle] pathForResource:@"Five" ofType:@"wav"];
    self.SixBeatPath = [[NSBundle mainBundle] pathForResource:@"Six" ofType:@"wav"];
    self.SevenBeatPath = [[NSBundle mainBundle] pathForResource:@"Seven" ofType:@"wav"];
    self.EightBeatPath = [[NSBundle mainBundle] pathForResource:@"Eight" ofType:@"wav"];
    self.NineBeatPath = [[NSBundle mainBundle] pathForResource:@"Nine" ofType:@"wav"];
    self.TenBeatPath = [[NSBundle mainBundle] pathForResource:@"Ten" ofType:@"wav"];
    self.ElevenBeatPath = [[NSBundle mainBundle] pathForResource:@"Eleven" ofType:@"wav"];
    self.TweleveBeatPath = [[NSBundle mainBundle] pathForResource:@"Twelve" ofType:@"wav"];

}
@end
