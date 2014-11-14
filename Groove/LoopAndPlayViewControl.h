//
//  LoopAndPlayingControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeMainViewControllerIphone.h"


@interface LoopAndPlayViewControl : NSObject <SelectBarProtocol>

// (3) Playing Cell functon item
@property (strong, nonatomic) IBOutlet UIButton *PlayCurrentCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;

// (4) Loop Control function button
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;

@property UIViewController *ParrentController;

- (void) InitlizePlayingItems;
- (void) InitializeLoopControlItem;
- (void) ChangeButtonDisplayByPlayMode;
- (void) ChangeSelectBarForcusIndex: (int) NewValue;
- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable;

@end
