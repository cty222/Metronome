//
//  MetronomeSelectBar.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeSelectBar.h"

#define CELL_WIDTH   (55)
#define CELL_HEIGHT  (40)
#define CONTROL_VIEW_MARGIN_LEFT    0
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
        
        self.GrooveCellListView.delegate = self;
    }
    return self;
}


- (void) DisplayCellList
{
    UIScrollView * ControlView = self.GrooveCellListView;
    
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
        CellLocation_X += CellWidth;
        
        SelectBarCell * TmpCell = [[SelectBarCell alloc] initWithFrame:TmpFrame];
        TmpCell.IndexNumber = Index;
        TmpCell.ValueLabel.text = (NSString *)self.GrooveCellValueStringList[Index];
        TmpCell.delegate = self;

        [ControlView addSubview:TmpCell];
    }
  
    ControlView.contentInset = UIEdgeInsetsMake (0, ([self FocusLine] -  CellWidth * 0.5), 0,  CellLocation_X  + ([self FocusLine] -  CellWidth * 0.5));
    [self ChangeFocusIndexByFunction: [[GlobalConfig LastFocusCellIndex] intValue]];
}


- (Boolean) isFocusCell: (SelectBarCell *) TargetCell
{
    UIScrollView * ControlView = self.GrooveCellListView;
    float CellViewStart = TargetCell.frame.origin.x + ControlView.frame.origin.x - ControlView.contentOffset.x;
    float CellViewEnd = TargetCell.frame.origin.x + TargetCell.frame.size.width + ControlView.frame.origin.x - ControlView.contentOffset.x;

    if (CellViewStart <= [self FocusLine] && CellViewEnd >= [self FocusLine])
    {
        return YES;
    }
    
    return NO;
}


- (void) SetFrameValueWhenStopSelect
{
    [UIView animateWithDuration:0.1
                          delay:0.0001
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         UIScrollView * ControlView = self.GrooveCellListView;
                         float CellWidth  = CELL_WIDTH;
                         ControlView.contentOffset = CGPointMake((CellWidth * 0.5 - [self FocusLine]) + CellWidth * self.FocusIndex, 0);
                     }
                     completion:^(BOOL finished){
                         self.Mode = SELECT_BAR_NONE;
                     }];
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
- (float) FocusLine
{
    if (_FocusLine == 0)
    {
        _FocusLine = self.FocusLineImage.frame.origin.x + self.FocusLineImage.frame.size.width /2;
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

    UIScrollView * ControlView = self.GrooveCellListView;

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
// delegate
//
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

// ============================
// UIScrollViewDelegate
//


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    [self CheckCurrentFocusCell];
    [self SetFrameValueWhenStopSelect];
}

- (void) CheckCurrentFocusCell
{
    UIScrollView * ControlView = self.GrooveCellListView;
    
    NSLog(@"subviews count %d", self.GrooveCellListView.subviews.count);
    for (int Index = 0; Index < self.GrooveCellListView.subviews.count; Index++)
    {
        SelectBarCell * TmpCell = ControlView.subviews[Index];
        
        if ([self isFocusCell:TmpCell])
        {
            NSLog(@"FocusIndex %d", Index);
            self.FocusIndex = Index;
        }
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
