//
//  MetronomeSelectBar.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeSelectBar.h"

@implementation MetronomeSelectBar
{
    NSMutableArray * _GrooveCellList;
    
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    int _FocusIndex;
    int CurrentMove;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.GrooveCellList = [self SelectCellList];
        self.FocusIndex = 0;
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void) DisplayCellList
{
    UIView * ControlView = self;
    ControlView.bounds = CGRectMake(0, 0, 200, 80);
    
    [[ControlView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int Index = 0; Index < self.GrooveCellList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake((Index - self.FocusIndex)  * 40, 20, 40, 40);
        UILabel * TmpLabel = [[UILabel alloc] initWithFrame:TmpFrame];
        TmpLabel.text = [NSString stringWithFormat:@"L%d", Index];
        [ControlView addSubview:TmpLabel];
    }
    
    [self FlashDisplayFrame];
}

- (void) FlashDisplayFrame
{
    for (int Index = 0; Index < self.GrooveCellList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake((Index - self.FocusIndex)  * 40 - CurrentMove, 20, 40, 40);
        UILabel * TmpLabel = self.subviews[Index];
        TmpLabel.frame = TmpFrame;
        if (TmpFrame.origin.x + TmpFrame.size.width > self.bounds.size.width ||
            TmpFrame.origin.x < self.bounds.origin.x
            )
        {
            TmpLabel.hidden = YES;
        }
        else
        {
            TmpLabel.hidden = NO;
        }
    }
}

- (int) NowFocusCellIndex
{
    Boolean HaveFocus = false;
    
    int Index = 0;
    for (Index = 0 ; Index < self.subviews.count; Index++)
    {
        UILabel * TmpLabel = self.subviews[Index];
        NSLog(@"%@", TmpLabel);
        if (TmpLabel.frame.origin.x - CurrentMove <= 0 &&
            (TmpLabel.frame.origin.x - CurrentMove + TmpLabel.frame.size.width) >= 40
            )
        {
            HaveFocus = YES;
            break;
        }
    }
    
    if (!HaveFocus)
    {
        Index = 0;
    }
    
    return Index;

}

// ============================
// Property
- (int) Sensitivity
{
    return 1;
}


- (NSMutableArray *) GetGrooveCellList
{
    return _GrooveCellList;
}

-(void) SetGrooveCellList: (NSMutableArray *) NewValue
{
    if (NewValue != _GrooveCellList)
    {
        _GrooveCellList = NewValue;
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

    }
    else
    {

        self.FocusIndex = [self NowFocusCellIndex];
        
        [self FlashDisplayFrame];
    }
}

- (int) GetFocusIndex
{
    return _FocusIndex;
}

- (void) SetFocusIndex:(int) NewValue
{
    NSLog(@"OldIndex : %d", _FocusIndex);
    NSLog(@"FocusIndex : %d", NewValue);
    
    // Reset old Label background color
    UILabel * OldFocusLabel = self.subviews[_FocusIndex];
    OldFocusLabel.backgroundColor = [UIColor whiteColor];
    
    // Set New label background color
    _FocusIndex = NewValue;
    UILabel * NewFocusLabel = self.subviews[_FocusIndex];
    NewFocusLabel.backgroundColor = [UIColor blueColor];
    
    //CurrentMove = 0;
}
//
// ============================


// ============================
// TODO:
- (NSMutableArray *) SelectCellList
{
    NSMutableArray * TmpDataBaseData = [[NSMutableArray alloc] init];
    for (int Index = 0 ; Index < 10; Index++)
    {
        [TmpDataBaseData addObject:[NSString stringWithFormat:@"%d", Index]];
    }
    
    return TmpDataBaseData;
}

- (Boolean) InsertCell
{
    return false;
}

- (Boolean) DeleteCell
{
    return false;
}

//
// ============================


// ============================
//
- (void) TouchBeginEvent : (CGPoint) TouchLocation
{
    OriginalLocation.x = TouchLocation.x;
    OriginalLocation.y = TouchLocation.y;
    self.Touched = YES;
}

- (void) TouchEndEvent : (CGPoint) TouchLocation
{
    self.Touched = NO;
}

- (void) TouchMoveEvent : (CGPoint) TouchLocation
{
    if (self.Touched)
    {
        int MoveLeft = (OriginalLocation.x - TouchLocation.x) / [self Sensitivity];
        if (MoveLeft != 0)
        {
            CurrentMove = MoveLeft;

            //self.FocusIndex = [self NowFocusCellIndex];
            
            
            {
                [self FlashDisplayFrame];
            }
            NSLog(@"%d",CurrentMove);
        }
    }
}

- (void) TouchCancellEvent : (CGPoint) TouchLocation
{
    self.Touched = NO;
}
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
