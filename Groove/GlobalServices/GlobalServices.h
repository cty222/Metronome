//
//  GlobalServices.h
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeEngine.h"

typedef NS_ENUM(NSUInteger) {
    METRONOME_PAGE,
    SYSTEMSETTING_PAGE,
    TEMPOLIST_PAGE,
} __MAIN_PAGE;

@interface GlobalServices : NSObject

@property MetronomeEngine *engine;

- (UIViewController *) getUIViewController: (__MAIN_PAGE) key;

@end
