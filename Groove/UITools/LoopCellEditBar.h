//
//  LoopCellEditBar.h
//  Groove
//
//  Created by C-ty on 2014/12/3.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

#define kLoopCellEditBarHiddenNotification @"kLoopCellEditBarHiddenNotification"
#define Key_LoopCellEditBarMode @"Key_LoopCellEditBarMode"
#define Key_LoopCellEditBarTriggerViewCenterLine @"Key_LoopCellEditBarTriggerViewCenterLine"

typedef enum{
    LOOP_CELL_EDIT_BAR_MODE_HIDDEN,
    LOOP_CELL_EDIT_BAR_MODE_SHOW,
    LOOP_CELL_EDIT_BARMODE_END
} LOOP_CELL_EDIT_BAR_MODE;

@interface LoopCellEditBar : XibViewInterface
@property (strong, nonatomic) IBOutlet UIImageView *ArrowView;
@property (strong, nonatomic) IBOutlet UIView *ContentView;

@property (readonly, getter=GetMode)LOOP_CELL_EDIT_BAR_MODE Mode;
@property float OriginYOffset;
- (void) ChangeMode: (LOOP_CELL_EDIT_BAR_MODE) ModeValue : (float) TriggerViewCenterLineValue;
@end
