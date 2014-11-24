//
//  UIWindowWithHook.h
//  Groove
//
//  Created by C-ty on 2014/11/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTouchGlobalHookNotification @"TouchGlobalHookNotification"

@interface UIWindowWithHook : UIWindow
@property BOOL EnableTouchHookNotifications;

@end
