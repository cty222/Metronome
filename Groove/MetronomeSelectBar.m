//
//  MetronomeSelectBar.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeSelectBar.h"

#define CELL_WIDTH   40
#define CELL_HEIGHT  40
#define CELL_MERGIN  CELL_WIDTH /4;
#define FIRST_CELL_OFFSET_COUNT 2

@implementation MetronomeSelectBar
{
    // Data
    NSMutableArray * _GrooveCellValueStringList;
    
    // Property
    BOOL _Touched;
    int _FocusIndex;
    SELECT_BAR_MOVE_MODE _MovedMode;
    float _FocusLine;

    // Touch Event
    CGPoint _OriginalLocation;
    NSTimer *MoveToCenterTimer;
    
    NSTimer *LongTouchTimer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.FocusIndex = 0;
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void) DisplayCellList
{
    UIView * ControlView = self.GrooveCellListView;
    
    // Clear all cell
    [[ControlView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];

    float CellWidth  = CELL_WIDTH;
    float CellHeight = CELL_HEIGHT;
    float CellLocation_X = 0;
    float CellLocation_Y = (ControlView.bounds.size.height - CellHeight)/2 ;
    
    for (int Index = 0; Index < self.GrooveCellValueStringList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake(CellLocation_X, CellLocation_Y, CellWidth, CellHeight);
        CellLocation_X += CellWidth + CELL_MERGIN;
        
        SelectBarCell * TmpCell = [[SelectBarCell alloc] initWithFrame:TmpFrame];
        TmpCell.IndexNumber = Index;
        TmpCell.ValueLabel.text = (NSString *)self.GrooveCellValueStringList[Index];
        TmpCell.delegate = self;
        TmpCell.HorizontalSensitivity = [self Sensitivity];

        [ControlView addSubview:TmpCell];
    }
    
    CGRect frame = self.GrooveCellListView.frame;
    self.GrooveCellListView.frame = CGRectMake(frame.origin.x + [self FocusLine] - CELL_WIDTH/2, frame.origin.y, frame.size.width, frame.size.height);
    
    [self SetFrameValueWhenStopSelect];
}

- (void) FlashDisplayFrame
{
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
        
        
        if (NoFucus && [self isFocusCell:TmpCell])
        {
            self.FocusIndex = Index;
            NoFucus = NO;
        }
    }
    
    // This is for first Cell and last Cell
    // it avoid user have no focus cell
    if (self.FocusIndex == 0 && NoFucus)
    {
        [self HorizontalValueChange:1 :nil];
    }
    else if (self.FocusIndex == (self.GrooveCellValueStringList.count -1) && NoFucus)
    {
        [self HorizontalValueChange: -1 :nil];
    }
}

- (Boolean) isFocusCell: (SelectBarCell *) TargetCell
{
    UIView * ControlView = self.GrooveCellListView;

    float CellViewStart = TargetCell.frame.origin.x + ControlView.frame.origin.x;
    float CellViewEnd = TargetCell.frame.origin.x + TargetCell.frame.size.width + ControlView.frame.origin.x;

    if (CellViewStart <= [self FocusLine] && CellViewEnd >= [self FocusLine])
    {
        NSLog(@"New Focus %d", TargetCell.IndexNumber);
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
        [self HorizontalValueChange:1 :nil];
    }
    else if ((int)FocusCellBase_X < (int)([self FocusLine]  - CELL_WIDTH/2))
    {
        [self HorizontalValueChange:-1 :nil];
    }
    else
    {
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
        
        // Until stop touching, parent's focusIndex will change.
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
    if (!_Touched)
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
        UIView * ControlView = self.GrooveCellListView;
        _FocusLine = ControlView.bounds.size.width/2;
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


- (BOOL) GetTouched
{
    return _Touched;
}

- (void) SetTouched: (BOOL)NewValue
{
    _Touched = NewValue;
    if (_Touched)
    {
        [self LongTouchFlashPageInfo];
    }
    else
    {
        [self SetFrameValueWhenStopSelect];
    }
}

- (int) GetFocusIndex
{
    return _FocusIndex;
}

- (void) SetFocusIndex:(int) NewValue
{
  
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

    // Set from code, not user touch, CurrentMove will be Zero.
    // (MoveToCenterTimer == nil) is for avoid recursive error.
    if (!_Touched && OldValue != NewValue && MoveToCenterTimer == nil)
    {
        [self SetFrameValueWhenStopSelect];
        return;
    }
    
    
    // Set New label background color
    // When Initialize, we will set _FocusIndex from zero to zero.
    // So it must out of brackets.
    NSLog(@"OldFocusCell");
    SelectBarCell * OldFocusCell = ControlView.subviews[OldValue];
    OldFocusCell.IsFocusOn = NO;
    
    NSLog(@"NewFocusCell");
    SelectBarCell * NewFocusCell = ControlView.subviews[NewValue];
    NewFocusCell.IsFocusOn = YES;



}
//
// ============================


// ============================
//

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    _OriginalLocation = [self GetLocationPoint: touches];
    self.Touched = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.Touched)
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
    self.Touched = NO;
}

- (CGPoint) GetLocationPoint: (NSSet*)touches
{
    UITouch *Touch =  [touches anyObject];
    return [Touch locationInView:Touch.view];
}



// ============================
// delegate
//
- (void) HorizontalValueChange:(int)ChangeValue :(SelectBarCell *)ThisCell
{
    
    CGRect frame = self.GrooveCellListView.frame;
    self.GrooveCellListView.frame = CGRectMake(frame.origin.x - ChangeValue, frame.origin.y, frame.size.width, frame.size.height);
    
    [self FlashDisplayFrame];

}


- (void) VerticlValueChange: (int) ChangeValue : (SelectBarCell *) ThisCell
{
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

- (BOOL) LongPressModeEnable: (SelectBarCell *) ThisCell
{
    if (_MovedMode == SELECT_CELL_NONE)
    {
        _MovedMode = SELECT_CAN_DROP;
        return YES;
    }
    else
    {
        return NO;
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
