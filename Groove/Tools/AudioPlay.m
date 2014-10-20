//
//  AudioPlay.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "AudioPlay.h"


@implementation AudioPlay

static ALCdevice *openALDevice;
static ALCcontext *openALContext;

+ (BOOL) AudioPlayEnable
{
    if (gPlayUnit == nil)
    {
        gPlayUnit = [[AudioPlay alloc] init];
    }

    return YES;
}

+ (void) ResetClickVocieList
{
    if (gClickVoiceList == nil)
    {
        gClickVoiceList = [[NSMutableArray alloc] init];
    }
    else
    {
        [gClickVoiceList removeAllObjects];
    }
    
    // ?? why I have beep sound ??
    [gClickVoiceList addObject: [[BeepBound alloc] init]];
    [gClickVoiceList addObject: [[NomalHiClickVoice alloc] init]];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        openALDevice = alcOpenDevice(NULL);
        
        openALContext = alcCreateContext(openALDevice, NULL);
        alcMakeContextCurrent(openALContext);
        
    }		
    return self;
}

- (void) playSound : (double) InsertVolume : (AUDIO_FILE) AudioFile
{
    if (InsertVolume <= 0)
    {
        return;
    }
#if AUDIO_LOG
    NSLog(@"Audio playSound, InsertVolume: %f", InsertVolume);
#endif
    alSourcef(AudioFile.SourceID, AL_PITCH, 1.0f);
    alSourcef(AudioFile.SourceID, AL_GAIN, InsertVolume);
    
    alSourcePlay(AudioFile.SourceID);

}

- (void)dealloc
{
#if CTY_DEBUG
    NSLog(@"Audio dealloc");
#endif
    alcMakeContextCurrent(NULL);
    if (openALContext) {alcDestroyContext(openALContext); openALContext = NULL;}
    if (openALDevice) {alcCloseDevice(openALDevice); openALDevice = NULL;}
}
@end
