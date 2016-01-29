//
//  RockClickNotificationCenter.m
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "RockClickNotificationCenter.h"

@implementation RockClickNotificationCenter

- (void) makeCircleButtonTwickLing: (__CIRCLE_BUTTON) value
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCircleButtonTwickLing object:@(value)];
}

- (void) switchMainWindowToSystemView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToSystemPageView object:nil];
}

- (void) setBPMValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSetBPMValueNotification object:nil];
}

- (void) changeCellCounter: (float) value
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeCellCounter object:@(value)];
}

- (void) deleteTargetIndexCell
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteTargetIndexCell object:nil];
}

- (void) playCellListButtonClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayCellListButtonClick object:nil];
}

- (void) addLoopCellButtonClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddLoopCellButtonClick object:nil];
}
@end
