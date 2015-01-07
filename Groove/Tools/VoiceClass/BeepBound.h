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

@property NSString *AccentPath;
@property NSString *FirstBeatPath;
@property NSString *AndBeatPath;
@property NSString *EBeatPath;
@property NSString *ABeatPath;
@property NSString *TicBeatPath;
@property NSString *TocBeatPath;

// HumanVoice
@property NSString *TwoBeatPath;
@property NSString *ThreeBeatPath;
@property NSString *FourBeatPath;
@property NSString *FiveBeatPath;
@property NSString *SixBeatPath;
@property NSString *SevenBeatPath;
@property NSString *EightBeatPath;
@property NSString *NineBeatPath;
@property NSString *TenBeatPath;
@property NSString *ElevenBeatPath;
@property NSString *TwelveBeatPath;



- (void) InitializeVoicePath;
- (void) ReleaseVoice;
- (void) LoadVoice  : (AUDIO_FILE *) VoicePtr : (NSString *) wavFilePath;

- (AUDIO_FILE) GetAccentVoice;
- (AUDIO_FILE) GetFirstBeatVoice;
- (AUDIO_FILE) GetAndBeatVoice;
- (AUDIO_FILE) GetEbeatVoice;
- (AUDIO_FILE) GetAbeatVoice;
- (AUDIO_FILE) GetTicbeatVoice;
- (AUDIO_FILE) GetTocbeatVoice;


// HumanVoice
- (AUDIO_FILE) GetTwoBeatVoice;
- (AUDIO_FILE) GetThreeBeatVoice;
- (AUDIO_FILE) GetFourBeatVoice;
- (AUDIO_FILE) GetFiveBeatVoice;
- (AUDIO_FILE) GetSixBeatVoice;
- (AUDIO_FILE) GetSevenBeatVoice;
- (AUDIO_FILE) GetEightBeatVoice;
- (AUDIO_FILE) GetNineBeatVoice;
- (AUDIO_FILE) GetTenBeatVoice;
- (AUDIO_FILE) GetElevenBeatVoice;
- (AUDIO_FILE) GetTwelveBeatVoice;

@end
