//
//  BeepBound.h
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenAl/al.h>
#import <OpenAl/alc.h>

typedef struct{
    void * Buf;
    UInt32 Size;
    ALuint SourceID;
    ALuint outputBuffer;
} AUDIO_FILE;

@interface BeepBound : NSObject
{
    AUDIO_FILE AccentVoice;
    AUDIO_FILE FirstBeatVoice;
    AUDIO_FILE AndBeatVoice;
    AUDIO_FILE EBeatVoice;
    AUDIO_FILE ABeatVoice;
    AUDIO_FILE GiBeatVoice;
    AUDIO_FILE GaBeatVoice;
}

@property NSString *AccentPath;
@property NSString *FirstBeatPath;
@property NSString *AndBeatPath;
@property NSString *EBeatPath;
@property NSString *ABeatPath;
@property NSString *GiBeatPath;
@property NSString *GaBeatPath;

- (void) InitializeVoicePath;
- (void) ReleaseVoice;
- (void) LoadVoice  : (AUDIO_FILE *) VoicePtr : (NSString *) wavFilePath;

- (AUDIO_FILE) GetAccentVoice;
- (AUDIO_FILE) GetFirstBeatVoice;
- (AUDIO_FILE) GetAndBeatVoice;
- (AUDIO_FILE) GetEbeatVoice;
- (AUDIO_FILE) GetAbeatVoice;
- (AUDIO_FILE) GetGibeatVoice;
- (AUDIO_FILE) GetGabeatVoice;
@end
