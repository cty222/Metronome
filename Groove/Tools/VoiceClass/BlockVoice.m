//
//  NomalLowClickVoice.m
//  Groove
//
//  Created by C-ty on 2015/1/8.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "BlockVoice.h"

@implementation BlockVoice

//================================
// It need to be override
//================================
- (void) InitializeVoicePath
{
    self.AccentPath = [[NSBundle mainBundle] pathForResource:@"Accent_Low" ofType:@"wav"];
    self.FirstBeatPath = [[NSBundle mainBundle] pathForResource:@"Quarter_Low" ofType:@"wav"];
    self.AndBeatPath = [[NSBundle mainBundle] pathForResource:@"And_Low" ofType:@"wav"];
    self.EBeatPath = [[NSBundle mainBundle] pathForResource:@"E_Low" ofType:@"wav"];
    self.ABeatPath = [[NSBundle mainBundle] pathForResource:@"E_Low" ofType:@"wav"];
    self.TicBeatPath = [[NSBundle mainBundle] pathForResource:@"Tic_Low" ofType:@"wav"];
    self.TocBeatPath = [[NSBundle mainBundle] pathForResource:@"Tic_Low" ofType:@"wav"];
}
@end
