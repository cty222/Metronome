//
//  PlayerForSongs.h
//  Groove
//
//  Created by C-ty on 2014/12/12.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>

#define kMusicLoudEnoughEvent @"kMusicLoudEnoughEvent"
#define kPlayMusicStatusChangedEvent @"kPlayMusicStatusChangedEvent"
#define kStopTimeLowerThanStartTimeEvent @"kStopTimeLowerThanStartTimeEvent"

#define ROUND_DOUBLE_TIME(value) (floor(value * 1000)/1000 + 0.0001)

@class PlayerForSongs;

PlayerForSongs * gPlayMusicChannel;

@interface PlayerForSongs : NSObject < AVAudioPlayerDelegate>

@property (setter=SetVolume:, getter=GetVolume) float Volume;
@property (setter=SetCurrentTime:, getter=GetCurrentTime) NSTimeInterval CurrentTime;
@property (setter=SetStartTime:, getter=GetStartTime) NSTimeInterval StartTime;
@property (setter=SetStopTime:, getter=GetStopTime) NSTimeInterval StopTime;

@property(readonly, getter=isPlaying) BOOL Playing; /* is it playing or not? */
@property(readonly, getter=GetURL) NSURL *URL; /* returns nil if object was not created with a URL */
@property(readonly, getter=GetDuration) NSTimeInterval duration;

@property(readonly, getter=GetIsReadyToPlay) BOOL IsReadyToPlay;

- (void) PrepareMusicToplay : (MPMediaItem *) Item;
- (void) SetPrepareNotReady;

- (MPMediaItem *) GetFirstMPMediaItemFromPersistentID : (NSNumber *)PersistentID;

- (void) PlayWithTempStartAndStopTime : (NSTimeInterval) StartTime : (NSTimeInterval) StopTime;

- (void) Play;

- (void) Stop;

- (void) DisplayInfo;

- (void) SetPlayRateToHalf;

- (void) SetPlayRateToNormal;

- (void) SetPlayMusicLoopingEnable : (BOOL) Enable;

- (NSString *) ReturnTimeValueToString : (NSTimeInterval) Time;

// Debug
- (void) PrintAllInfoOfItemProperty : (MPMediaItem *) Item;

@end
