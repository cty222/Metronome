//
//  AudioPlay.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "AudioPlay.h"


@implementation AudioPlay
{
}

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

+ (void) InitAlcDevice
{
    if (openALDevice)
    {
        alcDestroyContext (openALContext);
        alcCloseDevice(openALDevice);
    }
    
    openALDevice = alcOpenDevice(NULL);
    openALContext = alcCreateContext(openALDevice, NULL);
    alcMakeContextCurrent(openALContext);
}

+ (void) RestartAlcDevice
{
    // 關掉 AVAudioSession
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    // 取消Current cuntext
    alcMakeContextCurrent(NULL);
    // 暫停Current cuntext
    alcSuspendContext(openALContext);
    
    // 打開 AVAudioSession
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // Restore open al context
    alcMakeContextCurrent(openALContext);
    // 'unpause' my context
    alcProcessContext(openALContext);
}


- (id)init
{
    self = [super init];
    if (self)
    {
       [AudioPlay InitAlcDevice];
       [AudioPlay RestartAlcDevice];
        
        // 讓silence mode 下也有聲音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                               error:nil];
        
        //註冊系統Notification event : AVAudioSessionInterruptionNotification對應的selector
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(AVAudioSessionInterruptionHandler:)
                                                     name: AVAudioSessionInterruptionNotification
                                                   object: [AVAudioSession sharedInstance]];
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
#if AUDIO_LOG
    NSLog(@"Audio dealloc");
#endif
    alcMakeContextCurrent(NULL);
    if (openALContext) {alcDestroyContext(openALContext); openALContext = NULL;}
    if (openALDevice) {alcCloseDevice(openALDevice); openALDevice = NULL;}
}

// ===============================
// Handler
//
- (void) AVAudioSessionInterruptionHandler : (NSNotification*) notification
{
    NSDictionary *interruptionDictionary = [notification userInfo];
    NSNumber *interruptionType = (NSNumber *)[interruptionDictionary valueForKey:AVAudioSessionInterruptionTypeKey];
    int Type = [interruptionType intValue];
    
    if (Type == AVAudioSessionInterruptionTypeBegan)
    {
    }
    else if (Type == AVAudioSessionInterruptionTypeEnded)
    {
        // Apple 好像在某個時期有bug
        // 如果開openAL後, 跳到其他使用音訊的程式
        // 會調用 beginInterruption 中斷
        // 但不會調用 endInterruption
        // 所以不會回復聲音
        [AudioPlay RestartAlcDevice];
    }
}

//
// ===============================

@end
