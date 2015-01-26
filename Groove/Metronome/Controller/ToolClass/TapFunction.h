//
//  TapFunction.h
//  Groove
//
//  Created by C-ty on 2015/1/27.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapAnimationImage.h"
#import "GlobalConfig.h"

#define kTapChangeBPMValue @"kTapChangeBPMValue"

@interface TapFunction : NSObject

- (void) TapAreaBeingTap;

@property (strong, nonatomic) IBOutlet TapAnimationImage *TapAlertImage;
@property float NewValue;
@end
