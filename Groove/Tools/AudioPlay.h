//
//  AudioPlay.h
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

// Click voice class
#import "BeepBound.h"
#import "NomalHiClickVoice.h"
#import "HumanVoice.h"

#import "GlobalConfig.h"
#import "DebugHeader.h"

@class AudioPlay;
// it won't work if add static
AudioPlay* gPlayUnit;
NSMutableArray* gClickVoiceList;

@interface AudioPlay : NSObject <AVAudioPlayerDelegate>

enum ClickVoice{
    NO_VOICE   = -1,
    NORMAL_HI_VOICE  = 0,
    NORMAL_LOW_VOICE = 1,
    HUMAN_VOICE = 2,
    LAST_VOICE = HUMAN_VOICE,
    FIRST_VOICE = NORMAL_HI_VOICE
};

@property int MaxVolume;
- (void) playSound : (double) InsertVolume : (AUDIO_FILE) AudioFile;
+ (BOOL) AudioPlayEnable;
+ (void) ResetClickVocieList;
+ (void) InitAlcDevice;
+ (void) RestartAlcDevice;

@end
