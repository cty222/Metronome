//
//  PlayerForSongs.h
//  Groove
//
//  Created by C-ty on 2014/12/12.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class PlayerForSongs;

@interface PlayerForSongs : NSObject

+ (void) InitPlayerForSongs;
+ (void) Play;
+ (void) Stop;
+ (void) SetQueueWithItemCollection:(MPMediaItemCollection *)itemCollection;
+ (MPMediaItem *)NowPlayingItem;

@end
