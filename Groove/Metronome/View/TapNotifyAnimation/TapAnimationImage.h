//
//  TapAnimationImage.h
//  Groove
//
//  Created by C-ty on 2014/12/17.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

typedef enum {
    TAP_ALERT_GRAY,
    TAP_START_RED
} TAP_ANIMATION_MODE;

@interface TapAnimationImage : XibViewInterface
@property (strong, nonatomic) IBOutlet UIImageView *ImageGrayStep1;
@property (strong, nonatomic) IBOutlet UIImageView *ImageGrayStep2;
@property (strong, nonatomic) IBOutlet UIImageView *ImageRedStep1;
@property (strong, nonatomic) IBOutlet UIImageView *ImageRedStep2;

@property (getter = GetMode, setter = SetMode:) TAP_ANIMATION_MODE Mode;
@property (getter = GetHidden, setter = SetHidden:) BOOL hidden;

@end
