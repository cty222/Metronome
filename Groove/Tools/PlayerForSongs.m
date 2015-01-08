//
//  PlayerForSongs.m
//  Groove
//
//  Created by C-ty on 2014/12/12.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "PlayerForSongs.h"

static MPMusicPlayerController * MusicPlayer = nil;

@implementation PlayerForSongs
{
    AVAudioPlayer * _Player;
    NSTimeInterval _StartTime;
    NSTimeInterval _StopTime;
    NSTimeInterval _TickStopTime;

    BOOL _IsReadyToPlay;
   
    NSTimer * _TestingTimer;
    
    UIAlertView *_MusicTimeAlert;

    BOOL _LoopingEnable;
}

// =======================
// Function tools
//
- (void) initWithContentsOfURL:(NSURL*) url
{
    if (_Player == nil)
    {
        _Player = [AVAudioPlayer alloc];
    }
    
    _Player = [_Player initWithContentsOfURL:url error:nil];
    
    _Player.meteringEnabled = YES;
    [self SetPlayMusicLoopingEnable:NO];
    _Player.delegate = self;
}

- (void) Play
{
    [self PlayWithTempStartAndStopTime:self.StartTime :self.StopTime];
}

- (void) PlayWithTempStartAndStopTime : (NSTimeInterval) StartTime : (NSTimeInterval) StopTime
{
    if (!_IsReadyToPlay)
    {
        return;
    }
    
    if (StopTime < StartTime)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStopTimeLowerThanStartTimeEvent object:nil];
        if (_MusicTimeAlert == nil)
        {
            _MusicTimeAlert = [[UIAlertView alloc]
                               initWithTitle:@"MusicStopTimeWarming"
                               message:@"Your stop time is lower than start time,\n please set currectly!!"
                               delegate:nil
                               cancelButtonTitle:@"OK, I know it."
                               otherButtonTitles:nil, nil];
        }
        [_MusicTimeAlert show];
        return;
    }

    _Player.currentTime = StartTime;
    _TickStopTime = StopTime;
    
    [_Player play];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicStatusChangedEvent object:nil];
    
    if (_TestingTimer!= nil)
    {
        [_TestingTimer invalidate];
        _TestingTimer =nil;
    }
    _TestingTimer = [NSTimer scheduledTimerWithTimeInterval:(StopTime - StartTime + 0.01)
                                                     target:self
                                                   selector:@selector(StopMusicTick:)
                                                   userInfo:nil
                                                    repeats:NO];
}

- (void) Stop
{
    if (_TestingTimer!= nil)
    {
        [_TestingTimer invalidate];
        _TestingTimer =nil;
    }
    [_Player stop];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicStatusChangedEvent object:nil];
    
}
- (MPMediaItem *) GetFirstMPMediaItemFromPersistentID : (NSNumber *)PersistentID
{
    MPMediaPropertyPredicate * Predicate = [MPMediaPropertyPredicate predicateWithValue:PersistentID forProperty:MPMediaItemPropertyPersistentID];
    
    MPMediaQuery *songQuery = [[MPMediaQuery alloc] init];
    [songQuery addFilterPredicate: Predicate];
    if (songQuery.items.count > 0)
    {
        //song exists
        return [songQuery.items objectAtIndex:0];
    }
    return nil;
}

- (void) PrepareMusicToplay : (MPMediaItem *) Item
{
    NSURL *url = [Item valueForProperty:MPMediaItemPropertyAssetURL];
    
    if (gPlayMusicChannel != nil && gPlayMusicChannel.isPlaying)
    {
        [gPlayMusicChannel Stop];
    }
    
    [gPlayMusicChannel initWithContentsOfURL:url];
    if (!_IsReadyToPlay)
    {
        _IsReadyToPlay = YES;
    }
}

- (void) SetPrepareNotReady
{
    _IsReadyToPlay = NO;
}

- (NSString *) ReturnTimeValueToString : (NSTimeInterval) Time
{
    int Minutes = ((int)(Time) / 60);
    if (Minutes > 60)
    {
        Minutes = 60;
    }
    
    int Seconds = (int)Time % 60;
    int Centiseconds = floorf((Time - floorf(Time)) * 100);
    
    NSString * ReturnStr = [NSString stringWithFormat:@"%02d:%02d.%02d", Minutes, Seconds, Centiseconds];
    
    return ReturnStr;
}

- (void) DisplayInfo
{
    NSLog(@"音樂總長度 %f", [_Player duration]);
    NSLog(@"聲道數目 %lu", (unsigned long)[_Player numberOfChannels]);
}

- (void) PrintAllInfoOfItemProperty : (MPMediaItem *) Item
{
    NSLog(@"=======================");
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyMediaType]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyTitle]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyAlbumTitle]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyArtist]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyAlbumArtist]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyGenre]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyComposer]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyPlaybackDuration]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyAlbumTrackNumber]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyAlbumTrackCount]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyDiscNumber]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyDiscCount]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyArtwork]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyLyrics]);
    NSLog(@"%@",[Item valueForProperty:MPMediaItemPropertyIsCompilation]);
    NSLog(@"=======================");
}
//
// =======================

// =================
// Property
//
- (void) SetVolume:(float) NewVolume
{
    _Player.volume = NewVolume;
}

- (float) GetVolume
{
    return _Player.volume;
}

-(BOOL) isPlaying
{
    return _Player.isPlaying;
}

-(NSURL *)GetURL
{
    return _Player.url;
}

- (void) SetCurrentTime : (NSTimeInterval) NewCurrentTime
{
    if (NewCurrentTime > self.duration)
    {
        NewCurrentTime = self.duration;
    }
    _Player.currentTime = NewCurrentTime;
}

- (NSTimeInterval) GetCurrentTime
{
    return ROUND_DOUBLE_TIME(_Player.currentTime);
}

- (void) SetStartTime : (NSTimeInterval) NewStartTime
{
    if (NewStartTime <0)
    {
        NewStartTime = 0;
    }
    _StartTime = NewStartTime;
}

- (NSTimeInterval) GetStartTime
{
    return ROUND_DOUBLE_TIME(_StartTime);
}


- (void) SetStopTime : (NSTimeInterval) NewStopTime
{
    _StopTime = NewStopTime;
}

- (NSTimeInterval) GetStopTime
{
    return ROUND_DOUBLE_TIME(_StopTime);
}

- (NSTimeInterval) GetDuration
{
    
#if 0
    NSLog(@"[_Player duration] %f", [_Player duration]);
#endif
    
    return ROUND_DOUBLE_TIME([_Player duration]);
}


- (void) SetPlayRateToHalf
{
    if (_Player.prepareToPlay)
    {
        [_Player stop];
    }
    _Player.enableRate = YES;
    _Player.rate = 0.5;
}

- (void) SetPlayRateToNormal
{
    if (_Player.prepareToPlay)
    {
        [_Player stop];
    }
    _Player.enableRate = NO;
    _Player.rate = 1;
}

- (void) SetPlayMusicLoopingEnable : (BOOL) Enable
{
    _LoopingEnable = Enable;
}


- (BOOL) GetIsReadyToPlay
{
    return _IsReadyToPlay;
}
//
// =======================



// =======================
// Timer tick
//
- (void) StopMusicTick: (NSTimer *) ThisTimer
{
    NSLog(@"StopMusicTick, %f",_TickStopTime);
    [_Player updateMeters];

    if (_Player.currentTime >= _TickStopTime)
    {
        [self Stop];
        if (_LoopingEnable)
        {
            [self Play];
        }
    }
    else
    {
        _TestingTimer = [NSTimer scheduledTimerWithTimeInterval:_TickStopTime - [_Player currentTime] + 0.001
                                                         target:self
                                                       selector:@selector(StopMusicTick:)
                                                       userInfo:nil
                                                        repeats:NO];
    }
#if 1
    NSLog(@"目前播放位置 %f", [_Player currentTime]);
    NSLog(@"目前peakPowerForChannel %f", [_Player peakPowerForChannel:0]);
#endif

}

//
// =======================


// =========================
// AVAudioPlayerDelegate
//
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
    [self Stop];
    if (_LoopingEnable)
    {
        [self Play];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    // By pass
    //NSLog(@"audioPlayerBeginInterruption");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    // By pass
    //NSLog(@"audioPlayerEndInterruption");
}

//
// =========================

@end
