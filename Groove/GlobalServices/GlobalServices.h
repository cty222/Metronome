//
//  GlobalServices.h
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotesTool.h"
#import "MetronomeEngine.h"
#import "RockClickNotificationCenter.h"

typedef NS_ENUM(NSUInteger) {
    METRONOME_PAGE,
    SYSTEMSETTING_PAGE,
    TEMPOLIST_PAGE,
} __MAIN_PAGE;

@interface GlobalServices : NSObject

@property NotesTool * noteCallbackInterface;
@property MetronomeEngine *engine;
@property RockClickNotificationCenter *notificationCenter;

- (UIViewController *) getUIViewController: (__MAIN_PAGE) key;

@end
