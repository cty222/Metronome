//
//  BundleGrooveCell.h
//  Metronome_Ver1
//
//  Created by C-ty on 2014/8/21.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//


#import "XibTableViewCellInterface.h"

@interface TempoListUICell : XibTableViewCellInterface

@property (weak, nonatomic) IBOutlet UILabel *LblName;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchMute;

@end
