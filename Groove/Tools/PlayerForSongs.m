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
        self.EndTime = self.duration;
    }
}

- (void) Play
{
    _Player.currentTime = self.StartTime;
    
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
    
    if (_TestingTimer!= nil)
    {
        [_TestingTimer invalidate];
        _TestingTimer =nil;
    }
    [_Player pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicStatusChangedEvent object:nil];

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
    return _Player.currentTime;
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
    return _StartTime;
}


- (void) SetEndTime : (NSTimeInterval) NewEndTime
{
    if (NewEndTime > _Player.duration)
    {
        NewEndTime = _Player.duration;
    }
    
    _EndTime = NewEndTime;
}

- (NSTimeInterval) GetEndTime
{
    if (_EndTime > _Player.duration)
    {
        _EndTime = _Player.duration;
    }
    
    return _EndTime;
}

- (NSTimeInterval) GetDuration
{
    return [_Player duration];
}

- (void) DisplayInfo
{
    NSLog(@"音樂總長度 %f", [_Player duration]);
    NSLog(@"聲道數目 %lu", (unsigned long)[_Player numberOfChannels]);
}

- (void) SetPlayRateToHalf
{
    _Player.enableRate = YES;
    _Player.rate = 0.5;
}

- (void) SetPlayRateToNormal
{
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

- (NSString *) ReturnTimeValueToString : (NSTimeInterval) Time
{
    
    int Hours =  (Time / 60) / 60;
    int Minutes = (int)(Time - Hours * 60 * 60) / 60;
    int Seconds = (int)Time % 60;
    
    NSString * ReturnStr = [NSString stringWithFormat:@"%d:%02d:%02d",Hours, Minutes, Seconds];
    
    return ReturnStr;
}
@end
