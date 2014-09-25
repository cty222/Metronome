//
//  GlobalConfig.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GlobalConfig;

enum {
    DEFAULT_DEVICE_TYPE,
    IPHONE_4S,
    IPHONE_5S
} DEVICE_TYPE;

enum {
    DEFAULT_DEVICE_TYPE_HEIGHT = 0,
    IPHONE_4S_HEIGHT = 480,
    IPHONE_5S_HEIGHT = 568
} DEVICE_HEIGHT;

enum {
    DEFAULT_DEVICE_TYPE_WIDTH = 0,
    IPHONE_4S_WIDTH = 320,
    IPHONE_5S_WIDTH = 320
} DEVICE_WIDTH;

@interface GlobalConfig : NSObject
+ (void) Initialize : (UIWindow *) MainWindows;
+ (NSNumber *) MainWindowWidth;
+ (NSNumber *) MainWindowHeight;
+ (NSNumber *) DeviceType;
+ (NSNumber *) BPMMinValue;
+ (NSNumber *) BPMMaxValue;
+ (NSNumber *) DbVersion;


// Main View
+ (UIViewController *) GrooveMainViewControllerIphone;
+ (UIViewController *) MetronomeMainViewControllerIphone;

@end
