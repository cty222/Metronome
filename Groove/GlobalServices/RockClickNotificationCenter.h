//
//  RockClickNotificationCenter.h
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>

// GlobalEvent
typedef NS_ENUM(NSUInteger) {
    AccentCircleButton,
    QuarterCircleButton,
    EighthNoteCircleButton,
    SixteenthNoteCircleButton,
    TrippleNoteCircleButton,
    LastNoteCircleButton = TrippleNoteCircleButton,
} __CircleButton;

#define kCircleButtonTwickLing @"kCircleButtonTwickLing"
#define kChangeToSystemPageView @"kChangeToSystemPageView"
#define kSetBPMValueNotification @"kSetBPMValueNotification"
#define kChangeCellCounter @"kChangeCellCounter"
#define kDeleteTargetIndexCell @"kDeleteTargetIndexCell"
#define kPlayCellListButtonClick @"kPlayCellListButtonClick"
#define kAddLoopCellButtonClick @"kAddLoopCellButtonClick"

@interface RockClickNotificationCenter : NSObject

- (void) makeCircleButtonTwickLing: (__CircleButton) value;
- (void) switchMainWindowToSystemView;
- (void) setBPMValue;
- (void) changeCellCounter: (float) value;
- (void) deleteTargetIndexCell;
- (void) playCellListButtonClick;
- (void) addLoopCellButtonClick;

@end
