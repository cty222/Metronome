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
  SELECT_BAR_NONE,
  SELECT_BAR_UNCHANGED,
  SELECT_BAR_END
} SELECT_BAR_MOVE_MODE;

@protocol SelectBarProtocol <NSObject>
@required

@optional

- (void) SetFocusIndex: (int) FocusIndex;
@end

@interface MetronomeSelectBar : XibViewInterface <SelectBarCellProtocol, UIScrollViewDelegate>
@property (getter = GetGrooveCellValueStringList, setter = SetGrooveCellValueStringList:) NSMutableArray* GrooveCellValueStringList;
@property (nonatomic, assign) id<SelectBarProtocol> delegate;
- (void) ChangeFocusIndexWithUIMoving : (int) NewIndex;
- (void) DisplayUICellList: (int) FocusCellIndex;


// loop button
@property (strong, nonatomic) IBOutlet UIView *HerizontalScrollBar;
@property (strong, nonatomic) IBOutlet UIImageView *FocusLineImage;
@property (strong, nonatomic) IBOutlet UIScrollView *GrooveCellListView;

@end
