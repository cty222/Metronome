//
//  MetronomeSelectBar.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeSelectBar.h"

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
        // Initialization code
        self.Mode = SELECT_BAR_NONE;
        self.FocusIndex = 0;
        self.userInteractionEnabled = YES;
        
        self.GrooveCellListView.delegate = self;
    }
    return self;
}


- (void) DisplayUICellList: (int) FocusCellIndex
{
    UIScrollView * ControlView = self.GrooveCellListView;
    
    // Clear all cell
    [[ControlView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float CellWidth  = self.FocusLineImage.frame.size.width;
    float CellHeight = self.FocusLineImage.frame.size.height;
    float CellLocation_X = 0;
    float CellLocation_Y = (ControlView.bounds.size.height - CellHeight)/2 ;


    for (int Index = 0; Index < self.GrooveCellValueStringList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake(CellLocation_X, CellLocation_Y, CellWidth, CellHeight);
        CellLocation_X += CellWidth;
        
        SelectBarCell * TmpCell = [[SelectBarCell alloc] initWithFrame:TmpFrame];
        TmpCell.IndexNumber = Index;
        TmpCell.Text = (NSString *)self.GrooveCellValueStringList[Index];
        TmpCell.delegate = self;
        
        [ControlView addSubview:TmpCell];
    }
  
    ControlView.contentInset = UIEdgeInsetsMake (0, ([self FocusLine] -  CellWidth/2), 0,  CellWidth * (self.GrooveCellValueStringList.count -1)  + ([self FocusLine] +  CellWidth/2));
    
    
    [self ChangeFocusIndexWithUIMoving: FocusCellIndex];
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


- (void) MovingCellMatchFocusLineWithPassToController
{
    [UIView animateWithDuration:0.1
                          delay:0.0001
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         UIScrollView * ControlView = self.GrooveCellListView;
                         float CellWidth  = self.FocusLineImage.frame.size.width;
                         ControlView.contentOffset = CGPointMake((CellWidth * 0.5 - [self FocusLine]) + CellWidth * self.FocusIndex, 0);
                     }
                     completion:^(BOOL finished){
                         if (self.Mode == SELECT_BAR_UNCHANGED)
                         {
                             self.NoneHumanChangeFocusFlag = NO;
                         }
                         self.Mode = SELECT_BAR_NONE;
                         [self PassFocusIndexToDelegateControllor];
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
    [self PassFocusIndexToDelegateControllor];
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

    _FocusIndex = NewValue;
    
    // Set from code, not user touch, CurrentMove will be Zero.
    // (MoveToCenterTimer == nil) is for avoid recursive error.
    if (self.NoneHumanChangeFocusFlag)
    {
        self.Mode = SELECT_BAR_UNCHANGED;
        [self MovingCellMatchFocusLineWithPassToController];
        return;
    }
}

- (void) ChangeFocusIndexWithUIMoving : (int) NewIndex
{
    self.NoneHumanChangeFocusFlag = YES;
    self.FocusIndex = NewIndex;
}

- (void) PassFocusIndexToDelegateControllor
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(SetFocusIndex:)])
        {
            [self.delegate SetFocusIndex: self.FocusIndex];
        }
    }
}
//
// ============================


// ============================
// delegate
//
- (void) CellShortPress: (SelectBarCell*) ThisCell
{
    [self ChangeFocusIndexWithUIMoving:ThisCell.IndexNumber];
}
//
// ============================

// ============================
// UIScrollViewDelegate
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    [self FindCurrentFocusCellOnUIFrame];
    [self MovingCellMatchFocusLineWithPassToController];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self FindCurrentFocusCellOnUIFrame];
    [self MovingCellMatchFocusLineWithPassToController];
}

- (void) FindCurrentFocusCellOnUIFrame
{
    UIScrollView * ControlView = self.GrooveCellListView;
    
    for (int Index = 0; Index < self.GrooveCellListView.subviews.count; Index++)
    {
        NSString *SubViewClassName = NSStringFromClass([ControlView.subviews[Index] class]);
        if ([SubViewClassName isEqualToString:@"SelectBarCell"])
        {
            SelectBarCell * TmpCell = ControlView.subviews[Index];
            
            if ([self isFocusCell:TmpCell])
            {
                self.FocusIndex = Index;
            };
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
