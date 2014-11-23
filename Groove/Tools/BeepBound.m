//
//  BeepBound.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/6/22.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "BeepBound.h"

@implementation BeepBound

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
    
    [self LoadVoice: &AccentVoice : [self AccentPath]];
    
    [self LoadVoice: &FirstBeatVoice : [self FirstBeatPath]];
    [self LoadVoice: &AndBeatVoice : [self AndBeatPath]];
    [self LoadVoice: &EBeatVoice : [self EBeatPath]];
    [self LoadVoice: &ABeatVoice : [self ABeatPath]];
    [self LoadVoice: &GiBeatVoice : [self GiBeatPath]];
    [self LoadVoice: &GaBeatVoice : [self GaBeatPath]];
    
    return self;
}

- (void) dealloc
{
    NSLog(@"dealloc");
    [self ReleaseVoice];

}

-(void) ReleaseVoice
{
    if (AccentVoice.Buf)
    {
        free(AccentVoice.Buf);
        alDeleteSources(1, &AccentVoice.SourceID);
        alDeleteBuffers(1, &AccentVoice.outputBuffer);
    }
    if (FirstBeatVoice.Buf)
    {
        free(FirstBeatVoice.Buf);
        alDeleteSources(1, &FirstBeatVoice.SourceID);
        alDeleteBuffers(1, &FirstBeatVoice.outputBuffer);
    }
    if (AndBeatVoice.Buf)
    {
        free(AndBeatVoice.Buf);
        alDeleteSources(1, &AndBeatVoice.SourceID);
        alDeleteBuffers(1, &AndBeatVoice.outputBuffer);
    }
    if (EBeatVoice.Buf)
    {
        free(EBeatVoice.Buf);
        alDeleteSources(1, &EBeatVoice.SourceID);
        alDeleteBuffers(1, &EBeatVoice.outputBuffer);
    }
    if (ABeatVoice.Buf)
    {
        free(ABeatVoice.Buf);
        alDeleteSources(1, &ABeatVoice.SourceID);
        alDeleteBuffers(1, &ABeatVoice.outputBuffer);
    }
    if (GiBeatVoice.Buf)
    {
        free(GiBeatVoice.Buf);
        alDeleteSources(1, &GiBeatVoice.SourceID);
        alDeleteBuffers(1, &GiBeatVoice.outputBuffer);
    }
    if (GaBeatVoice.Buf)
    {
        free(GaBeatVoice.Buf);
        alDeleteSources(1, &GaBeatVoice.SourceID);
        alDeleteBuffers(1, &GaBeatVoice.outputBuffer);
    }
    
    AccentVoice.Buf       = nil;
    AccentVoice.Size      = 0;
    FirstBeatVoice.Buf     = nil;
    FirstBeatVoice.Size    = 0;
    AndBeatVoice.Buf    = nil;
    AndBeatVoice.Size   = 0;
    EBeatVoice.Buf  = nil;
    EBeatVoice.Size = 0;
    ABeatVoice.Buf  = nil;
    ABeatVoice.Size = 0;
    GiBeatVoice.Buf   = nil;
    GiBeatVoice.Size  = 0;
    GaBeatVoice.Buf   = nil;
    GaBeatVoice.Size  = 0;
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
    alBufferData(VoicePtr->outputBuffer, AL_FORMAT_STEREO16, VoicePtr->Buf, VoicePtr->Size, 44100);
    alSourcei(VoicePtr->SourceID, AL_BUFFER, VoicePtr->outputBuffer);
}

- (AUDIO_FILE) GetAccentVoice
{
    return AccentVoice;
}
- (AUDIO_FILE) GetFirstBeatVoice
{
    return FirstBeatVoice;
}
- (AUDIO_FILE) GetAndBeatVoice
{
    return AndBeatVoice;
}
- (AUDIO_FILE) GetEbeatVoice
{
    return EBeatVoice;
}
- (AUDIO_FILE) GetAbeatVoice
{
    return ABeatVoice;
}
- (AUDIO_FILE) GetGibeatVoice
{
    return GiBeatVoice;
}
- (AUDIO_FILE) GetGabeatVoice
{
    return GaBeatVoice;
}
@end
