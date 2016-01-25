//
//  MetronomeEngine.h
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotesTool.h"

@interface MetronomeEngine : NSObject

@property NSTimer * clickTimer;
@property CURRENT_PLAYING_NOTE currentPlayingNoteCounter;
@property int accentCounter;
@property int loopCountCounter;
@property int timeSignatureCounter;
@property BOOL listChangeFocusFlag;

@end
