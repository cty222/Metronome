//
//  MetronomeEngine.h
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NotesTool.h"
#import "AudioPlay.h"
#import "TempoCell.h"

@class GlobalServices;

@interface MetronomeEngine : NSObject <NoteProtocol>

@property AudioPlay* playUnit;
@property NSMutableArray* clickVoiceList;

@property NSArray * tempoCells;
@property TempoCell *currentCell;
@property (nonatomic) BeepBound* currentVoice;
@property (nonatomic) NSString* currentTimeSignature;
@property (nonatomic) TempoList* currentTempoList;

// ===== TODO: replace ==========
@property NSTimer * clickTimer;
@property CURRENT_PLAYING_NOTE currentPlayingNoteCounter;
@property int accentCounter;
@property int loopCountCounter;
@property int timeSignatureCounter;
@property BOOL listChangeFocusFlag;
// ==============================


- (id) initWithGlobalServices: (GlobalServices *) globalServices;
- (int) decodeTimeSignatureToValue : (NSString *)timeSignatureString;
- (void) triggerMetronomeSounds;

@end
