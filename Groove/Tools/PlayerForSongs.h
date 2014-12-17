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
#define kPlayMusicWithSingleCellEvent @"kPlayMusicWithSingleCellEvent"
#define kPlayMusicWithCellListEvent @"kPlayMusicWithCellListEvent"


@class PlayerForSongs;

PlayerForSongs * gPlayMusicChannel;

@interface PlayerForSongs : NSObject

@property (setter=SetDelegate:, getter=GetDelegate) id<AVAudioPlayerDelegate> delegate;
@property (setter=SetVolume:, getter=GetVolume) float Volume;
@property (setter=SetCurrentTime:, getter=GetCurrentTime) NSTimeInterval CurrentTime;
@property (setter=SetEndTime:, getter=GetEndTime) NSTimeInterval EndTime;

@property(readonly, getter=isPlaying) BOOL Playing; /* is it playing or not? */
@property(readonly, getter=GetURL) NSURL *URL; /* returns nil if object was not created with a URL */


- (void) initWithContentsOfURL:(NSURL*) url Info:(NSMutableDictionary *)TimeInfo;

- (void) SetStartTimeLoction : (NSTimeInterval) NewTimeLoction;

- (void) Play;

- (void) Stop;

- (void) DisplayInfo;

- (void) SetPlayRateToHalf;

- (void) SetPlayRateToNormal;

@end
