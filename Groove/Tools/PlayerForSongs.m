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

+ (void) InitPlayerForSongs
{
    MusicPlayer = [MPMusicPlayerController applicationMusicPlayer];

}

+ (void) Play
{
    if (MusicPlayer == nil)
    {
        [PlayerForSongs InitPlayerForSongs];
    }
    [MusicPlayer play];
}

+ (void) Stop
{
    if (MusicPlayer == nil)
    {
        [PlayerForSongs InitPlayerForSongs];
    }
    [MusicPlayer stop];
}

+ (void) SetQueueWithItemCollection:(MPMediaItemCollection *)itemCollection
{
    if (MusicPlayer == nil)
    {
        [PlayerForSongs InitPlayerForSongs];
    }
    [MusicPlayer setQueueWithItemCollection:itemCollection];
}

+ (MPMediaItem *)NowPlayingItem
{
    if (MusicPlayer == nil)
    {
        [PlayerForSongs InitPlayerForSongs];
    }
    return [MusicPlayer nowPlayingItem];
}


@end
