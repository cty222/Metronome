//
//  SelectBarCell.h
//  Groove
//
//  Created by C-ty on 2014/11/16.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@class SelectBarCell;

typedef enum{
    SELECT_CELL_NONE,
    SELECT_CELL_NORMAL_MOVE,
    SELECT_CELL_FOCUS_ON,
    SELECT_CELL_FOCUS_ON_MOVE,
    SELECT_CELL_LONG_PRRESS_MOVE,
    SELECT_CELL_BLOCK,
    SELECT_CELL_MODE_END
} SELECT_CELL_MOVE_MODE;

@protocol SelectBarCellProtocol <NSObject>
@required

@optional

- (void) HorizontalValueChange: (int) ChangeValue : (SelectBarCell *) ThisCell;
- (void) VerticlValueChange: (int) ChangeValue : (SelectBarCell *) ThisCell;
- (BOOL) LongPressModeEnable: (SelectBarCell *) ThisCell;
- (void) ShortPressToSetFocus: (SelectBarCell*) ThisCell;
- (void) CellTouchedChange : (BOOL) Touched : (SelectBarCell *) ThisCell;
@end

@interface SelectBarCell : XibViewInterface <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetIsfocusOn, setter = SetIsfocusOn:) BOOL IsFocusOn;
@property (getter = GetMoveMode, setter = SetMoveMode:) SELECT_CELL_MOVE_MODE MoveMode;

@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;
@property (getter = GetLongPressSecond, setter = SetLongPressSecond:) float LongPressSecond;
@property (getter = GetVerticalSensitivity, setter = SetVerticalSensitivity:) float VerticalSensitivity;
@property (getter = GetHorizontalSensitivity, setter = SetHorizontalSensitivity:) float HorizontalSensitivity;

@property int IndexNumber;

@property (nonatomic, assign) id<SelectBarCellProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *NoramlImage;
@property (strong, nonatomic) IBOutlet UIImageView *FocusImage;
@property (strong, nonatomic) IBOutlet UIImageView *LongPressImage;
@property (getter = GetCurrentDisplayView, setter = SetCurrentDisplayView:) UIImageView *CurrentDisplayView;

@end
