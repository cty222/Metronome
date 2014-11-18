//
//  MetronomeSelectBar.h
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "GlobalConfig.h"
#import "XibViewInterface.h"
#import "SelectBarCell.h"

typedef enum{
  SELECT_NONE,
  SELECT_CELL,
  SELECT_CAN_DROP,
  SELECT_BAR_UNCHANGED
} SELECT_BAR_MOVE_MODE;

@protocol SelectBarProtocol <NSObject>
@required

@optional

- (void) SetFocusIndex: (int) FocusIndex;
- (BOOL) SetTargetCellLoopCountAdd: (int) Index AddValue:(int)Value;

@end


@interface MetronomeSelectBar : XibViewInterface <SelectBarCellProtocol>
@property (getter = GetGrooveCellValueStringList, setter = SetGrooveCellValueStringList:) NSMutableArray* GrooveCellValueStringList;

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;

@property BOOL NoneHumanChangeFocusFlag;
@property SELECT_BAR_MOVE_MODE Mode;

@property (nonatomic, assign) id<SelectBarProtocol> delegate;

// loop button
@property (strong, nonatomic) IBOutlet UIButton *AddLoopCellButton;
@property (strong, nonatomic) IBOutlet UIButton *PlayLoopCellButton;
@property (strong, nonatomic) IBOutlet UIView *HerizontalScrollBar;
@property (strong, nonatomic) IBOutlet UIImageView *FocusLineImage;
@property (strong, nonatomic) IBOutlet UIView *GrooveCellListView;

@end
