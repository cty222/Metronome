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

@interface MetronomeBottomSubViewIphone : XibViewInterface
@property (strong, nonatomic) IBOutlet VolumeBarSet *VolumeSet;
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;

@end
