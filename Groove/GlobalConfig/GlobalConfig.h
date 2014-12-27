//
//  GlobalConfig.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

// ************************************************
// If Change plist value, it also need to change version
// ************************************************

#import <Foundation/Foundation.h>
#import "MetronomeModel.h"
#import "MusicProperties.h"

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
+ (BOOL) ReBuildDbFlag;
+ (void) Initialize : (UIWindow *) MainWindows;
+ (NSNumber *) MainWindowWidth;
+ (NSNumber *) MainWindowHeight;
+ (NSNumber *) DeviceType;
+ (NSNumber *) BPMMinValue;
+ (NSNumber *) BPMMaxValue;
+ (NSNumber *) DbVersion;
+ (NSNumber *) LoopValueMin;
+ (NSNumber *) LoopValueMax;
+ (NSNumber *) LoopCellMaxCount;
+ (BOOL) PlayCellListNoneStop;
+ (void) SetPlayCellListNoneStop : (BOOL) NewValue;

+ (NSNumber *) GetLastTempoListIndex;
+ (void) SetLastTempoListIndex : (int) NewValue;


// Music bounds flags
+ (MusicProperties *) GetMusicProperties;
+ (void) SetMusicProperties : (MusicProperties *) NewMusicProperties;

// Main View
+ (UIViewController *) SystemPageViewController;
+ (UIViewController *) MetronomeMainViewController;
+ (UIViewController *) TempoListController;

// GlobalEvent
#define kChangeToSystemPageView @"kChangeToSystemPageView"
#define kChangeBackToMetronomeView @"kChangeBackToMetronomeView"

#define kChangeToTempoListPickerView @"kChangeToTempoListPickerView"
#define kChangeBackToSystemPageView @"kChangeBackToSystemPageView"
@end
