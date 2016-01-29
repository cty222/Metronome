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
    AccentCircle_Button,
    QuarterCircle_Button,
    EighthNoteCircle_Button,
    SixteenthNoteCircle_Button,
    TrippleNoteCircle_Button,
} __CIRCLE_BUTTON;

#define kCircleButtonTwickLing @"kCircleButtonTwickLing"
#define kChangeToSystemPageView @"kChangeToSystemPageView"
#define kSetBPMValueNotification @"kSetBPMValueNotification"
#define kChangeCellCounter @"kChangeCellCounter"
#define kDeleteTargetIndexCell @"kDeleteTargetIndexCell"
#define kPlayCellListButtonClick @"kPlayCellListButtonClick"
#define kAddLoopCellButtonClick @"kAddLoopCellButtonClick"

@interface RockClickNotificationCenter : NSObject

- (void) makeCircleButtonTwickLing: (__CIRCLE_BUTTON) value;
- (void) switchMainWindowToSystemView;
- (void) setBPMValue;
- (void) changeCellCounter: (float) value;
- (void) deleteTargetIndexCell;
- (void) playCellListButtonClick;
- (void) addLoopCellButtonClick;

@end
