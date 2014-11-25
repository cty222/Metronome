//
//  SubPropertySelector.h
//  Groove
//
//  Created by C-ty on 2014/11/26.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

#define kSubPropertySelectorHiddenNotification @"kSubPropertySelectorHiddenNotification"
#define Key_SubPropertySelectorMode @"Key_SubPropertySelectorMode"
#define Key_TriggerViewCenterLine @"Key_TriggerViewCenterLine"

typedef enum{
    SUB_PROPERTY_MODE_HIDDEN,
    SUB_PROPERTY_MODE_SHOW,
    SUB_PROPERTY_MODE_END
} SUB_PROPERTY_MODE;

@interface SubPropertySelector : XibViewInterface
@property (strong, nonatomic) IBOutlet UIImageView *ArrowView;
@property (strong, nonatomic) IBOutlet UIScrollView *ContentScrollView;
@property (readonly, getter=GetMode)SUB_PROPERTY_MODE Mode;
@property float OriginYOffset;
- (void) ChangeMode: (SUB_PROPERTY_MODE) ModeValue : (float) TriggerViewCenterLineValue;

@end
