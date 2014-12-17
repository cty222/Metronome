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
    
    NSTimeInterval _EndTime;
    id<AVAudioPlayerDelegate> _delegate;
    BOOL _CellListPlayWithMusicEvent;
    BOOL _SingleCellPlayWithMusicEvent;

    
    NSTimer * _TestingTimer;
}

- (void) initWithContentsOfURL:(NSURL*) url Info:(NSMutableDictionary *)TimeInfo
{
    _Player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _Player.meteringEnabled = YES;
    _Player.numberOfLoops = 0;
    
    if (TimeInfo == nil)
    {
        self.CurrentTime = 0.0f;
        self.EndTime = _Player.duration;
    }
}

- (NSTimeInterval) ReturnCurrentTime
{
    return [_Player currentTime];
}

- (void) SetStartTimeLoction : (NSTimeInterval) NewTimeLoction
{
    _Player.currentTime = NewTimeLoction;
}

- (void) Play
{
    _Player.currentTime = 0.0f;
    
    [_Player play];
    
    
    if (_SingleCellPlayWithMusicEvent)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicWithSingleCellEvent object:nil];
    }
    
    if (_CellListPlayWithMusicEvent)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicWithCellListEvent object:nil];
    }

    
    if (_TestingTimer!= nil)
    {
        [_TestingTimer invalidate];
        _TestingTimer =nil;
    }
    _TestingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target:self
                                                     selector:@selector(DisplayCallback:)
                                                     userInfo:nil
                                                      repeats:YES];

}

- (void) Stop
{
    [_Player pause];
}


- (void) SetDelegate: (id<AVAudioPlayerDelegate>) NewDelegate
{
    _Player.delegate =  NewDelegate;
}

 - (id<AVAudioPlayerDelegate>) GetDelegate
{
    return _Player.delegate;
}

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

- (void) SetCurrentTime : (NSTimeInterval) StartTime
{
    _Player.currentTime = StartTime;
}

- (NSTimeInterval) GetCurrentTime
{
    return _Player.currentTime;
}

- (void) SetEndTime : (NSTimeInterval) NewEndTime
{
    if (_Player.duration < NewEndTime)
    {
        NewEndTime = _Player.duration;
    }
    
    _EndTime = NewEndTime;
}

- (NSTimeInterval) GetEndTime
{
    if (_Player.duration < _EndTime)
    {
        _EndTime = _Player.duration;
    }
    
    return _EndTime;
}



- (void) DisplayInfo
{
    NSLog(@"音樂總長度 %f", [_Player duration]);
    NSLog(@"聲道數目 %d", [_Player numberOfChannels]);
}

- (void) SetPlayRateToHalf
{
    NSLog(@"SetPlayRateToHalf");
    _Player.enableRate = YES;
    _Player.rate = 0.5;
}

- (void) SetPlayRateToNormal
{
    NSLog(@"SetPlayRateToNormal");
    _Player.enableRate = NO;
    _Player.rate = 1;
}

- (void) DisplayCallback: (NSTimer *) ThisTimer
{
    [_Player updateMeters];

    if (_Player.currentTime >= self.EndTime)
    {
        [self Stop];
    }
    
#if 0
    NSLog(@"目前播放位置 %f", [_Player currentTime]);
    NSLog(@"目前peakPowerForChannel %f", [_Player peakPowerForChannel:0]);
#endif

}
@end
