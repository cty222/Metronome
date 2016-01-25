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
@end
