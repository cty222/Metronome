//
//  MetronomeSelectBar.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeSelectBar.h"

#define CELL_WIDTH   (40)
#define CELL_HEIGHT  (40)
#define CELL_MARGIN  (CELL_WIDTH /4);
#define CONTROL_VIEW_MARGIN_LEFT    ([self FocusLine] - CELL_WIDTH/2)
#define CONTROL_VIEW_MARGIN_RIGHT    (2 * CELL_WIDTH)

@interface MetronomeSelectBar ()
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property BOOL NoneHumanChangeFocusFlag;
@property (getter = GetMode, setter = SetMode:) SELECT_BAR_MOVE_MODE Mode;
@end

@implementation MetronomeSelectBar
{
    // Data
    NSMutableArray * _GrooveCellValueStringList;

    // Property
    BOOL _BarSpaceTouched;
    BOOL _IsAnyCellTouched;

    int _FocusIndex;
    SELECT_BAR_MOVE_MODE _Mode;
    float _FocusLine;
    int _DeleteIndex;
    
    // Touch Event
    CGPoint _OriginalLocation;
    NSTimer *MoveToCenterTimer;
    
    NSTimer *LongTouchTimer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.DropCellView removeFromSuperview];
        self.DropCellView = [[DropCellView alloc] initWithFrame:self.DropCellView.frame];
        [self addSubview:self.DropCellView];
        self.DropCellView.hidden = YES;

        self.DropImage = self.DropCellView.DropImage;
        
        // Initialization code
        self.Mode = SELECT_BAR_NONE;
        self.FocusIndex = 0;
        self.userInteractionEnabled = YES;

    }
    return self;
}


- (void) DisplayCellList
{
    NSLog(@"DisplayCellList");
    UIView * ControlView = self.GrooveCellListView;
    
    // Clear all cell
    [[ControlView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];

    ControlView.frame = CGRectMake(ControlView.frame.origin.x,
                                   ControlView.frame.origin.y,
                                   (self.GrooveCellValueStringList.count * CELL_WIDTH) + CONTROL_VIEW_MARGIN_LEFT +CONTROL_VIEW_MARGIN_RIGHT,
                                   ControlView.frame.size.height
                                   );
    
    float CellWidth  = CELL_WIDTH;
    float CellHeight = CELL_HEIGHT;
    float CellLocation_X = 0;
    float CellLocation_Y = (ControlView.bounds.size.height - CellHeight)/2 ;
    
    for (int Index = 0; Index < self.GrooveCellValueStringList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake(CellLocation_X, CellLocation_Y, CellWidth, CellHeight);
        CellLocation_X += CellWidth + CELL_MARGIN;
        
        SelectBarCell * TmpCell = [[SelectBarCell alloc] initWithFrame:TmpFrame];
        TmpCell.IndexNumber = Index;
        TmpCell.ValueLabel.text = (NSString *)self.GrooveCellValueStringList[Index];
        TmpCell.delegate = self;
        TmpCell.HorizontalSensitivity = [self Sensitivity];

        [ControlView addSubview:TmpCell];
    }
    
    CGRect frame = ControlView.frame;
    ControlView.frame = CGRectMake(frame.origin.x + CONTROL_VIEW_MARGIN_LEFT, frame.origin.y, frame.size.width, frame.size.height);

    [self ChangeFocusIndexByFunction: [[GlobalConfig LastFocusCellIndex] intValue]];

}

- (void) FlashDisplayFrame
{
    NSLog(@"FlashDisplayFrame");

    if (self.GrooveCellListView.subviews == nil)
    {
        return;
    }
    
    UIView * ControlView = self.GrooveCellListView;
    
    Boolean NoFucus = YES;
   
    float StartLine = 0;
    float EndLine = self.HerizontalScrollBar.frame.size.width;
    
    for (int Index = 0; Index < self.GrooveCellListView.subviews.count; Index++)
    {
        SelectBarCell * TmpCell = ControlView.subviews[Index];
        
        float CellStartLine = TmpCell.frame.origin.x + ControlView.frame.origin.x;
        float CellEndLine = CellStartLine + TmpCell.frame.size.width;
        
        if (CellEndLine > EndLine ||
            CellStartLine < StartLine
            )
        {
            // if cell is out of view frame, it will be hidden.
            TmpCell.hidden = YES;
        }
        else
        {
            TmpCell.hidden = NO;
        }
        
        
        if (NoFucus && [self isFocusCell:TmpCell] && !self.NoneHumanChangeFocusFlag)
        {
            self.FocusIndex = Index;
            NoFucus = NO;
        }
    }
    
    // This is for first Cell and last Cell
    // it avoid user have no focus cell
    // 這是防止手動拉動超出邊線
    if (!self.NoneHumanChangeFocusFlag)
    {
        if (self.FocusIndex == 0 && NoFucus)
        {
            [self HorizontalValueChange:0.5 :nil];
        }
        else if (self.FocusIndex == (self.GrooveCellValueStringList.count -1) && NoFucus)
        {
            [self HorizontalValueChange: -0.5 :nil];
        }
    }
}

- (Boolean) isFocusCell: (SelectBarCell *) TargetCell
{
    UIView * ControlView = self.GrooveCellListView;
    float CellViewStart = TargetCell.frame.origin.x + ControlView.frame.origin.x;
    float CellViewEnd = TargetCell.frame.origin.x + TargetCell.frame.size.width + ControlView.frame.origin.x;

    if (CellViewStart <= [self FocusLine] && CellViewEnd >= [self FocusLine])
    {
        return YES;
    }
    
    return NO;
}


- (void) SetFrameValueWhenStopSelect
{
    if (MoveToCenterTimer != nil)
    {
        [MoveToCenterTimer invalidate];
        MoveToCenterTimer = nil;
    }
    
    MoveToCenterTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(MoveFocusCellToCenterTick:)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void) MoveFocusCellToCenterTick: (NSTimer *) ThisTimer
{
    // Focus Cell base
    UIView * ControlView = self.GrooveCellListView;
    SelectBarCell * FocusCell = ControlView.subviews[self.FocusIndex];
    float FocusCellBase_X = FocusCell.frame.origin.x + ControlView.frame.origin.x;
    
    if ((int)FocusCellBase_X > (int)([self FocusLine] - CELL_WIDTH/2))
    {
        [self HorizontalValueChange:0.5 :nil];
    }
    else if ((int)FocusCellBase_X < (int)([self FocusLine]  - CELL_WIDTH/2))
    {
        [self HorizontalValueChange:-0.5 :nil];
    }
    else
    {
        self.Mode = SELECT_BAR_NONE;
        self.NoneHumanChangeFocusFlag = NO;
        
        // Until stop touching, parent's focusIndex will change.
        [self FlashDisplayFrame];
        
        if (MoveToCenterTimer != nil)
        {
            [MoveToCenterTimer invalidate];
            MoveToCenterTimer = nil;
        }
        else
        {
            [ThisTimer invalidate];
            return;
        }
        
        if (self.delegate != nil)
        {
            // Check whether delegate have this selector
            if([self.delegate respondsToSelector:@selector(SetFocusIndex:)])
            {
                [self.delegate SetFocusIndex: _FocusIndex];
            }
        }
    }
}

- (void) LongTouchFlashPageInfo
{
    LongTouchTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                         target:self
                                                       selector:@selector(LongTouchFlashTick:)
                                                       userInfo:nil
                                                        repeats:YES];
    
    
}

- (void) LongTouchFlashTick: (NSTimer *) ThisTimer
{
    // 1. Flash page info for user recognize.
    if (!_BarSpaceTouched)
    {
        [LongTouchTimer invalidate];
        LongTouchTimer = nil;
        return;
    }
    
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetFocusIndex:)])
        {
            [self.delegate SetFocusIndex: _FocusIndex];
        }
    }
}

- (void) DeleteTargetIndexCell: (int) Index
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(DeleteTargetIndexCell:)])
        {
            [self.delegate DeleteTargetIndexCell: Index];
        }
    }
}
// ============================
// Property
//
- (float) Sensitivity
{
    return 2;
}

- (float) FocusLine
{
    if (_FocusLine == 0)
    {
        UIView * DisplaySizeView = self.HerizontalScrollBar;
        _FocusLine = DisplaySizeView.bounds.size.width/2;
    }
    
    return _FocusLine;
}


- (NSMutableArray *) GetGrooveCellValueStringList
{
    return _GrooveCellValueStringList;
}

-(void) SetGrooveCellValueStringList: (NSMutableArray *) NewValue
{
    if (NewValue != _GrooveCellValueStringList)
    {
        _GrooveCellValueStringList = NewValue;
        [self DisplayCellList];
    }
}

- (SELECT_BAR_MOVE_MODE) GetMode
{
    return _Mode;
}

- (void) SetMode : (SELECT_BAR_MOVE_MODE) NewValue
{
    if ((_Mode == NewValue)
        || (NewValue >= SELECT_BAR_END || NewValue < SELECT_BAR_NONE)
        )
    {
        return;
    }
    
    switch (NewValue) {
        case SELECT_BAR_NONE:
            _DeleteIndex = -1;
            self.DropCellView.hidden = YES;
            break;
        case SELECT_BAR_CAN_DROP:
            _DeleteIndex = -1;
            self.DropCellView.hidden = NO;
            break;
        case SELECT_BAR_UNCHANGED:
            break;
        default:
            return;
    }
        
    _Mode = NewValue;
}

- (BOOL) GetTouched
{
    return (_IsAnyCellTouched || _BarSpaceTouched);
}

- (void) SetTouched: (BOOL)NewValue
{
    if (_IsAnyCellTouched || _BarSpaceTouched)
    {
        [self LongTouchFlashPageInfo];
    }
    else
    {
        if (self.Mode == SELECT_BAR_NONE)
        {
            [self SetFrameValueWhenStopSelect];
        }
        else
        {
            self.Mode = SELECT_BAR_NONE;
        }
    }
}

- (BOOL) GetBarSpaceTouched
{
    return _BarSpaceTouched;
}

- (void) SetBarSpaceTouched: (BOOL)NewValue
{
    _BarSpaceTouched = NewValue;

    self.Touched = _BarSpaceTouched;
}

- (int) GetFocusIndex
{
    return _FocusIndex;
}

- (void) SetFocusIndex:(int) NewValue
{
    if (self.Mode == SELECT_BAR_UNCHANGED)
    {
        return;
    }
  
    UIView * ControlView = self.GrooveCellListView;

    if (_GrooveCellValueStringList == nil
        || ControlView.subviews.count == 0
        || ControlView.subviews.count <= NewValue
        )
    {
        return;
    }
    
    int OldValue = _FocusIndex;
    _FocusIndex = NewValue;
    [GlobalConfig SetLastFocusCellIndex: _FocusIndex];
  
    // Set New label background color
    // When Initialize, we will set _FocusIndex from zero to zero.
    // So it must out of brackets.
    SelectBarCell * OldFocusCell = ControlView.subviews[OldValue];
    OldFocusCell.IsFocusOn = NO;
    
    SelectBarCell * NewFocusCell = ControlView.subviews[NewValue];
    NewFocusCell.IsFocusOn = YES;

    // Set from code, not user touch, CurrentMove will be Zero.
    // (MoveToCenterTimer == nil) is for avoid recursive error.
    if (self.NoneHumanChangeFocusFlag)
    {
        self.Mode = SELECT_BAR_UNCHANGED;
        [self SetFrameValueWhenStopSelect];
        return;
    }

}

- (void) ChangeFocusIndexByFunction : (int) NewIndex
{
    self.NoneHumanChangeFocusFlag = YES;
    self.FocusIndex = NewIndex;
}
//
// ============================


// ============================
//

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    _OriginalLocation = [self GetLocationPoint: touches];
    [self SetBarSpaceTouched: YES];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self SetBarSpaceTouched: NO];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self GetBarSpaceTouched])
    {
        CGPoint TouchLocation = [self GetLocationPoint: touches];
        
        // Because zero point is on left top, large point in on right bottom
        int MoveLeftRight = (_OriginalLocation.x - TouchLocation.x) / [self Sensitivity];
        
        if (MoveLeftRight != 0)
        {
            
            [self HorizontalValueChange:MoveLeftRight :nil];

            _OriginalLocation = TouchLocation;

        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self SetBarSpaceTouched: NO];
}

- (CGPoint) GetLocationPoint: (NSSet*)touches
{
    UITouch *Touch =  [touches anyObject];
    return [Touch locationInView:Touch.view];
}



// ============================
// delegate
//
- (void) HorizontalValueChange:(float)ChangeValue :(SelectBarCell *)ThisCell
{
    if(self.Mode == SELECT_BAR_CAN_DROP)
    {
        return;
    }
    
    UIView * ControlView = self.GrooveCellListView;

    CGRect frame = ControlView.frame;
    ControlView.frame = CGRectMake(frame.origin.x - ChangeValue, frame.origin.y, frame.size.width, frame.size.height);
    
    [self FlashDisplayFrame];

}


- (void) VerticlValueChange: (float) ChangeValue : (SelectBarCell *) ThisCell
{
    if(self.Mode == SELECT_BAR_CAN_DROP)
    {
        return;
    }
    
    if (self.delegate != nil)
    {
        int Index = ThisCell.IndexNumber;
        
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetTargetCellLoopCountAdd: AddValue:)])
        {
            if ([self.delegate SetTargetCellLoopCountAdd:Index  AddValue: ChangeValue])
            {
                SelectBarCell * TargetCell =  self.GrooveCellListView.subviews[Index];
                TargetCell.ValueLabel.text = (NSString *)self.GrooveCellValueStringList[Index];
            }
            
        }
    }
}

- (BOOL) IsLongPressModeEnable: (BOOL) Enable : (SelectBarCell *) ThisCell
{
    if (Enable)
    {
        if (self.Mode == SELECT_CELL_NONE)
        {
            self.Mode = SELECT_BAR_CAN_DROP;
            [self sendSubviewToBack:self.DropCellView];
            return YES;
        }
    }
    else
    {
        if (self.Mode == SELECT_BAR_CAN_DROP)
        {
            if (_DeleteIndex >= 0)
            {
                [self DeleteTargetIndexCell: _DeleteIndex];
            }
        }
    }
    return NO;

}

- (void) ShortPressToSetFocus: (SelectBarCell*) ThisCell
{
    self.NoneHumanChangeFocusFlag = YES;
    self.FocusIndex = ThisCell.IndexNumber;
}

- (void) CellTouchedChange : (BOOL) Touched : (SelectBarCell *) ThisCell
{
    if (Touched)
    {
        // 只要有一個Cell 是 Touched 就是Touched狀態
        if (!_IsAnyCellTouched) {
            _IsAnyCellTouched = YES;
        }
    }
    else
    {
        // 所有Cell 都不是 Touched 才不是Touched狀態
        if (_IsAnyCellTouched) {
            BOOL TmpTouched = NO;
            for (int Index = 0; Index < self.GrooveCellListView.subviews.count; Index++) {
                SelectBarCell * Cell = self.GrooveCellListView.subviews[Index];
                if (Cell.Touched) {
                    TmpTouched = Cell.Touched;
                    break;
                }
            }
            if (!TmpTouched)
            {
                _IsAnyCellTouched = NO;
            }
        }
    }
    
    self.Touched = _IsAnyCellTouched;
}

- (void) CellMoving :(SelectBarCell *) ThisCell
{
    float Cell_X_Offset = self.GrooveCellListView.frame.origin.x + self.HerizontalScrollBar.frame.origin.x;
    float Cell_Y_Offset = self.GrooveCellListView.frame.origin.y + self.HerizontalScrollBar.frame.origin.y;
    float DropImage_X_Offset = self.DropCellView.frame.origin.x;
    float DropImage_Y_Offset = self.DropCellView.frame.origin.y;

  
    float Cell_X_Start = ThisCell.frame.origin.x + Cell_X_Offset;
    float Cell_X_End = Cell_X_Start + ThisCell.frame.size.width;
    float Cell_Y_Start = ThisCell.frame.origin.y + Cell_Y_Offset;
    float Cell_Y_End = Cell_Y_Start + ThisCell.frame.size.height;

    float DropImage_X_Start = self.DropImage.frame.origin.x + DropImage_X_Offset;
    float DropImage_X_End = DropImage_X_Start + self.DropImage.frame.size.width;
    float DropImage_Y_Start = self.DropImage.frame.origin.y + DropImage_Y_Offset;
    float DropImage_Y_End = DropImage_Y_Start + self.DropImage.frame.size.height;
    
    if (((Cell_X_Start >= DropImage_X_Start && Cell_X_Start <= DropImage_X_End)
         || (Cell_X_End >= DropImage_X_Start && Cell_X_End <= DropImage_X_End))
        && ( (Cell_Y_Start >= DropImage_Y_Start && Cell_Y_Start <= DropImage_Y_End)
            || (Cell_Y_End >= DropImage_Y_Start && Cell_Y_End <= DropImage_Y_End))
        )
    {
        self.DropImage.backgroundColor = [UIColor yellowColor];
        _DeleteIndex = ThisCell.IndexNumber;
    }
    else
    {
        self.DropImage.backgroundColor = [UIColor blueColor];
        _DeleteIndex = -1;
    }

}
//
// ============================


// 
// ============================
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
