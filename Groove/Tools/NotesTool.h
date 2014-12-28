//
//  NotesTool.h
//  Metronome_Ver1
//
//  Created by C-ty on 2014/7/7.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import <Foundation/Foundation.h>

// Display
//1 2 3 4 5 6 7 8 9 10 11 12
//1     e     &      a
//1       gi      ga
typedef enum {
    NONE_CLICK = 0,
    FIRST_CLICK = 1,
    F_GI_CLICK  = 3,
    E_CLICK     = 4,
    GI_CLICK    = 5,
    AND_CLICK   = 7,
    GA_CLICK    = 9,
    A_CLICK     = 10,
    AF_GA_CLICK = 11,
    LAST_CLICK  = 12,
    RESET_CLICK = 13,
    ACCENT_CLICK
} CURRENT_PLAYING_NOTE;

typedef enum {
    ACCENT_NOTE         = 1,
    TWO_NOTE            = 2,
    FOUR_NOTE           = 4,
    EIGHT_NOTE          = 8,
    TWELEVE_NOTE        = 12,
    SIXTEEN_NOTE        = 16,
    TWENTY_FOUR_NOTE    = 24,
} NOTES_FAMILY;

@protocol NoteProtocol <NSObject>
@required

@optional
- (void) FirstBeatFunc;
- (void) EBeatFunc;
- (void) AndBeatFunc;
- (void) ABeatFunc;
- (void) FrontGiBeatFunc;
- (void) GiBeatFunc;
- (void) GaBeatFunc;
- (void) AfterGaBeatFunc;
- (void) DefaultFunc;

@end

#define MAX_BPM_VALUE 250
#define MIN_BPM_VALUE 30

#define START_PICKER_BPM_VALUE (120 - MIN_BPM_VALUE)
#define START_SLIDER_BPM_VALUE (120)
#define ONCE_TIME (60 / LAST_CLICK)

#define BPM_TO_TIMER_VALUE(BPMValue) (((double)60/(double)BPMValue)/(double)LAST_CLICK)

#define SIGNATURE_NOTE 4

#define MAX_VOLUME 10
#define MIN_VOLUME 0
#define MAX_VOLUME_RANGE 4
#define MIN_VOLUME_RANGE 2

#define MAX_BEATS 16
#define MIN_BEATS 1
#define DEFAULT_BEATS 4

#define FirstDrumBits        0x00000003
#define SecondDrumBits       0x0000000C
#define ThirdrumBits         0x00000030
#define FourthDrumBits       0x000000C0
#define FifthDrumBits        0x00000300
#define SixthDrumBits        0x00000C00
#define SeventhDrumBits      0x00003000
#define EighthDrumBits       0x0000C000
#define NinthDrumBits        0x00030000
#define TenthDrumBits        0x000C0000
#define EleventhDrumBits     0x00300000
#define TwelfthDrumBits      0x00C00000
#define ThirteethDrumBits    0x03000000
#define FourteenthDrumBits   0x0C000000
#define FifteenthDrumBits    0x30000000
#define SixteenthDrumBits    0xC0000000

#define CHECK_BITS 0x3   //for 0b11
#define NUMBER_OF_CLICK_BITS 2

NSMutableDictionary *gPlist;
NSString * gPlistDst;

@interface NotesTool : NSObject

@property (nonatomic, assign) id<NoteProtocol> delegate;

+ (void) NotesFunc : (CURRENT_PLAYING_NOTE) InputNote : (NotesTool *) TargetNotesTool;
@end


