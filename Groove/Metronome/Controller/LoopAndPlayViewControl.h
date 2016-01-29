//
//  LoopAndPlayingControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeMainViewController.h"

@interface LoopAndPlayViewControl : NSObject <SelectBarProtocol>

// (3) Playing Cell functon item
@property (strong, nonatomic) IBOutlet UIButton *PlayCurrentCellButton;

// (4) Loop Control function button
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *SelectGrooveBar;

@property UIViewController *ParrentController;

- (void) InitlizePlayingItems;
- (void) InitializeLoopControlItem;
- (void) ChangeSelectBarForcusIndex: (int) NewIndex;
- (void) CopyCellListToSelectBar : (NSArray *) CellDataTable;


- (void) SetTargetCellLoopCountAdd: (int) Index Value:(int)NewValue;
- (void) DeleteTargetIndexCell: (int) Index;


@end
