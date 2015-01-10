//
//  BeepBound.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "BeepBound.h"

@implementation BeepBound
{
    AUDIO_FILE _AccentVoice;
    AUDIO_FILE _FirstBeatVoice;
    AUDIO_FILE _AndBeatVoice;
    AUDIO_FILE _EBeatVoice;
    AUDIO_FILE _ABeatVoice;
    AUDIO_FILE _TicBeatVoice;
    AUDIO_FILE _TocBeatVoice;
    
    // HumanVoice
    AUDIO_FILE _TwoBeatVoice;
    AUDIO_FILE _ThreeBeatVoice;
    AUDIO_FILE _FourBeatVoice;
    AUDIO_FILE _FiveBeatVoice;
    AUDIO_FILE _SixBeatVoice;
    AUDIO_FILE _SevenBeatVoice;
    AUDIO_FILE _EightBeatVoice;
    AUDIO_FILE _NineBeatVoice;
    AUDIO_FILE _TenBeatVoice;
    AUDIO_FILE _ElevenBeatVoice;
    AUDIO_FILE _TwelveBeatVoice;
    
    // Drum
    AUDIO_FILE _BassDrumVoice;
    AUDIO_FILE _SnareVoice;
}

//================================
// It need to be override
//================================
- (void) InitializeVoicePath
{
    // Do NOT writing anything in here.
}

- (id) init
{
    [self ReleaseVoice];
    
    [self InitializeVoicePath];
    
    [self LoadVoice: &_AccentVoice : [self AccentPath]];
    
    [self LoadVoice: &_FirstBeatVoice : [self FirstBeatPath]];
    [self LoadVoice: &_AndBeatVoice : [self AndBeatPath]];
    [self LoadVoice: &_EBeatVoice : [self EBeatPath]];
    [self LoadVoice: &_ABeatVoice : [self ABeatPath]];
    [self LoadVoice: &_TicBeatVoice : [self TicBeatPath]];
    [self LoadVoice: &_TocBeatVoice : [self TocBeatPath]];
    
    // Human
    [self LoadVoice: &_TwoBeatVoice : [self TwoBeatPath]];
    [self LoadVoice: &_ThreeBeatVoice : [self ThreeBeatPath]];
    [self LoadVoice: &_FourBeatVoice : [self FourBeatPath]];
    [self LoadVoice: &_FiveBeatVoice : [self FiveBeatPath]];
    [self LoadVoice: &_SixBeatVoice : [self SixBeatPath]];
    [self LoadVoice: &_SevenBeatVoice : [self SevenBeatPath]];
    [self LoadVoice: &_EightBeatVoice : [self EightBeatPath]];
    [self LoadVoice: &_NineBeatVoice : [self NineBeatPath]];
    [self LoadVoice: &_TenBeatVoice : [self TenBeatPath]];
    [self LoadVoice: &_ElevenBeatVoice : [self ElevenBeatPath]];
    [self LoadVoice: &_TwelveBeatVoice : [self TwelveBeatPath]];
    
    // Drum
    [self LoadVoice: &_BassDrumVoice : [self BassDrumPath]];
    [self LoadVoice: &_SnareVoice : [self SnarePath]];

    return self;
}

- (void) dealloc
{
    NSLog(@"dealloc");
    [self ReleaseVoice];

}

-(void) ReleaseVoice
{
    if (_AccentVoice.Buf)
    {
        free(_AccentVoice.Buf);
        alDeleteSources(1, &_AccentVoice.SourceID);
        alDeleteBuffers(1, &_AccentVoice.outputBuffer);
    }
    if (_FirstBeatVoice.Buf)
    {
        free(_FirstBeatVoice.Buf);
        alDeleteSources(1, &_FirstBeatVoice.SourceID);
        alDeleteBuffers(1, &_FirstBeatVoice.outputBuffer);
    }
    if (_AndBeatVoice.Buf)
    {
        free(_AndBeatVoice.Buf);
        alDeleteSources(1, &_AndBeatVoice.SourceID);
        alDeleteBuffers(1, &_AndBeatVoice.outputBuffer);
    }
    if (_EBeatVoice.Buf)
    {
        free(_EBeatVoice.Buf);
        alDeleteSources(1, &_EBeatVoice.SourceID);
        alDeleteBuffers(1, &_EBeatVoice.outputBuffer);
    }
    if (_ABeatVoice.Buf)
    {
        free(_ABeatVoice.Buf);
        alDeleteSources(1, &_ABeatVoice.SourceID);
        alDeleteBuffers(1, &_ABeatVoice.outputBuffer);
    }
    if (_TicBeatVoice.Buf)
    {
        free(_TicBeatVoice.Buf);
        alDeleteSources(1, &_TicBeatVoice.SourceID);
        alDeleteBuffers(1, &_TicBeatVoice.outputBuffer);
    }
    if (_TocBeatVoice.Buf)
    {
        free(_TocBeatVoice.Buf);
        alDeleteSources(1, &_TocBeatVoice.SourceID);
        alDeleteBuffers(1, &_TocBeatVoice.outputBuffer);
    }
    
    // Human
    if (_TwoBeatVoice.Buf)
    {
        free(_TwoBeatVoice.Buf);
        alDeleteSources(1, &_TwoBeatVoice.SourceID);
        alDeleteBuffers(1, &_TwoBeatVoice.outputBuffer);
    }
    if (_ThreeBeatVoice.Buf)
    {
        free(_ThreeBeatVoice.Buf);
        alDeleteSources(1, &_ThreeBeatVoice.SourceID);
        alDeleteBuffers(1, &_ThreeBeatVoice.outputBuffer);
    }
    if (_FourBeatVoice.Buf)
    {
        free(_FourBeatVoice.Buf);
        alDeleteSources(1, &_FourBeatVoice.SourceID);
        alDeleteBuffers(1, &_FourBeatVoice.outputBuffer);
    }
    if (_FiveBeatVoice.Buf)
    {
        free(_FiveBeatVoice.Buf);
        alDeleteSources(1, &_FiveBeatVoice.SourceID);
        alDeleteBuffers(1, &_FiveBeatVoice.outputBuffer);
    }
    if (_SixBeatVoice.Buf)
    {
        free(_SixBeatVoice.Buf);
        alDeleteSources(1, &_SixBeatVoice.SourceID);
        alDeleteBuffers(1, &_SixBeatVoice.outputBuffer);
    }
    if (_SevenBeatVoice.Buf)
    {
        free(_SevenBeatVoice.Buf);
        alDeleteSources(1, &_SevenBeatVoice.SourceID);
        alDeleteBuffers(1, &_SevenBeatVoice.outputBuffer);
    }
    if (_EightBeatVoice.Buf)
    {
        free(_EightBeatVoice.Buf);
        alDeleteSources(1, &_EightBeatVoice.SourceID);
        alDeleteBuffers(1, &_EightBeatVoice.outputBuffer);
    }
    if (_NineBeatVoice.Buf)
    {
        free(_NineBeatVoice.Buf);
        alDeleteSources(1, &_NineBeatVoice.SourceID);
        alDeleteBuffers(1, &_NineBeatVoice.outputBuffer);
    }
    if (_TenBeatVoice.Buf)
    {
        free(_TenBeatVoice.Buf);
        alDeleteSources(1, &_TenBeatVoice.SourceID);
        alDeleteBuffers(1, &_TenBeatVoice.outputBuffer);
    }
    if (_ElevenBeatVoice.Buf)
    {
        free(_ElevenBeatVoice.Buf);
        alDeleteSources(1, &_ElevenBeatVoice.SourceID);
        alDeleteBuffers(1, &_ElevenBeatVoice.outputBuffer);
    }
    if (_TwelveBeatVoice.Buf)
    {
        free(_TwelveBeatVoice.Buf);
        alDeleteSources(1, &_TwelveBeatVoice.SourceID);
        alDeleteBuffers(1, &_TwelveBeatVoice.outputBuffer);
    }
    
    // Drum
    if (_BassDrumVoice.Buf)
    {
        free(_BassDrumVoice.Buf);
        alDeleteSources(1, &_BassDrumVoice.SourceID);
        alDeleteBuffers(1, &_BassDrumVoice.outputBuffer);
    }
    if (_SnareVoice.Buf)
    {
        free(_SnareVoice.Buf);
        alDeleteSources(1, &_SnareVoice.SourceID);
        alDeleteBuffers(1, &_SnareVoice.outputBuffer);
    }

    
    _AccentVoice.Buf       = nil;
    _AccentVoice.Size      = 0;
    _FirstBeatVoice.Buf     = nil;
    _FirstBeatVoice.Size    = 0;
    _AndBeatVoice.Buf    = nil;
    _AndBeatVoice.Size   = 0;
    _EBeatVoice.Buf  = nil;
    _EBeatVoice.Size = 0;
    _ABeatVoice.Buf  = nil;
    _ABeatVoice.Size = 0;
    _TicBeatVoice.Buf   = nil;
    _TicBeatVoice.Size  = 0;
    _TocBeatVoice.Buf   = nil;
    _TocBeatVoice.Size  = 0;
    
    
    // HumanVoice
    _TwoBeatVoice.Buf   = nil;
    _TwoBeatVoice.Size  = 0;
    _ThreeBeatVoice.Buf   = nil;
    _ThreeBeatVoice.Size  = 0;
    _FourBeatVoice.Buf   = nil;
    _FourBeatVoice.Size  = 0;
    _FiveBeatVoice.Buf   = nil;
    _FiveBeatVoice.Size  = 0;
    _SixBeatVoice.Buf   = nil;
    _SixBeatVoice.Size  = 0;
    _SevenBeatVoice.Buf   = nil;
    _SevenBeatVoice.Size  = 0;
    _EightBeatVoice.Buf   = nil;
    _EightBeatVoice.Size  = 0;
    _NineBeatVoice.Buf   = nil;
    _NineBeatVoice.Size  = 0;
    _TenBeatVoice.Buf   = nil;
    _TenBeatVoice.Size  = 0;
    _ElevenBeatVoice.Buf   = nil;
    _ElevenBeatVoice.Size  = 0;
    _TwelveBeatVoice.Buf   = nil;
    _TwelveBeatVoice.Size  = 0;
    
    // Drum
    _BassDrumVoice.Buf   = nil;
    _BassDrumVoice.Size  = 0;
    _SnareVoice.Buf   = nil;
    _SnareVoice.Size  = 0;
}

- (void) LoadVoice  : (AUDIO_FILE *) VoicePtr : (NSString *) wavFilePath
{
    // new add debug for no audio path;
    if (wavFilePath == nil){
        return;
    }
    
     NSString *audioFilePath = wavFilePath;

     NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
    
     // Check will it be audio file?
     AudioFileID afid;
     OSStatus openAudioFileResult = AudioFileOpenURL((__bridge CFURLRef)audioFileURL, kAudioFileReadPermission, 0, &afid);
     if (0 != openAudioFileResult)
     {
     NSLog(@"An error occurred when attempting to open the audio file %@: %d", audioFilePath, (int)openAudioFileResult);
     return;
     }
    
     // Get audio file size in audioDataByteCount
     UInt64 audioDataByteCount = 0;
     UInt32 propertySize = sizeof(audioDataByteCount);
     OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &audioDataByteCount);
     if (0 != getSizeResult)
     {
     NSLog(@"An error occurred when attempting to determine the size of audio file %@: %d", audioFilePath, (int)getSizeResult);
     return;
     }
    
    
    //==============
    if(VoicePtr->Buf != nil)
     {
         free(VoicePtr->Buf);
         VoicePtr->Buf = nil;
         VoicePtr->Size = 0;
     }
    
    //
    //it might be wrong, if file size is over 32 bit max value.
    //
    VoicePtr->Size  = (UInt32)audioDataByteCount;
    VoicePtr->Buf = malloc(VoicePtr->Size);
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &VoicePtr->Size, VoicePtr->Buf);

    if (0 != readBytesResult)
    {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %d", audioFilePath, (int)readBytesResult);
        free(VoicePtr->Buf);
        VoicePtr->Buf = nil;
        return;
    }
    AudioFileClose(afid);
    
    //======

    alGenSources(1, &VoicePtr->SourceID);
    alGenBuffers(1, &VoicePtr->outputBuffer);
    alBufferData(VoicePtr->outputBuffer, AL_FORMAT_MONO16, VoicePtr->Buf, VoicePtr->Size, 44100);
    alSourcei(VoicePtr->SourceID, AL_BUFFER, VoicePtr->outputBuffer);
}

- (AUDIO_FILE) GetAccentVoice
{
    return _AccentVoice;
}
- (AUDIO_FILE) GetFirstBeatVoice
{
    return _FirstBeatVoice;
}
- (AUDIO_FILE) GetAndBeatVoice
{
    return _AndBeatVoice;
}
- (AUDIO_FILE) GetEbeatVoice
{
    return _EBeatVoice;
}
- (AUDIO_FILE) GetAbeatVoice
{
    return _ABeatVoice;
}
- (AUDIO_FILE) GetTicbeatVoice
{
    return _TicBeatVoice;
}
- (AUDIO_FILE) GetTocbeatVoice
{
    return _TocBeatVoice;
}

// Human
- (AUDIO_FILE) GetTwoBeatVoice
{
    return _TwoBeatVoice;
}

- (AUDIO_FILE) GetThreeBeatVoice
{
    return _ThreeBeatVoice;
}

- (AUDIO_FILE) GetFourBeatVoice
{
    return _FourBeatVoice;
}

- (AUDIO_FILE) GetFiveBeatVoice
{
    return _FiveBeatVoice;
}

- (AUDIO_FILE) GetSixBeatVoice
{
    return _SixBeatVoice;
}

- (AUDIO_FILE) GetSevenBeatVoice
{
    return _SevenBeatVoice;
}

- (AUDIO_FILE) GetEightBeatVoice
{
    return _EightBeatVoice;
}

- (AUDIO_FILE) GetNineBeatVoice
{
    return _NineBeatVoice;
}

- (AUDIO_FILE) GetTenBeatVoice
{
    return _TenBeatVoice;
}

- (AUDIO_FILE) GetElevenBeatVoice
{
    return _ElevenBeatVoice;
}

- (AUDIO_FILE) GetTwelveBeatVoice
{
    return _TwelveBeatVoice;
}

// Drum
- (AUDIO_FILE) GetBassDrumVoice
{
    return _BassDrumVoice;
}

- (AUDIO_FILE) GetSnareVoice
{
    return _SnareVoice;
    
}

@end
