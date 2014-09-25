//
//  MetronomeSelectBar.m
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeSelectBar.h"

#define CELL_WIDTH   40
#define FIRST_CELL_OFFSET_COUNT 2

@implementation MetronomeSelectBar
{
    NSMutableArray * _GrooveCellList;
    
    // Touch Event
    CGPoint OriginalLocation;
    BOOL _Touched;
    int _FocusIndex;
    int PermanentFrameMove;
    int CurrentMove;
    NSTimer *MoveToCenterTimer;
    int MoveToCenterCounter;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        PermanentFrameMove = -1 * (CELL_WIDTH * FIRST_CELL_OFFSET_COUNT);
        //self.GrooveCellList = [self SelectCellList];
        self.FocusIndex = 0;
        self.userInteractionEnabled = YES;
        

    }
    return self;
}


- (void) DisplayCellList
{
    UIView * ControlView = self;
    ControlView.bounds = CGRectMake(0, 0, 200, 80);
    
    // Clear all cell
    [[ControlView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int Index = 0; Index < self.GrooveCellList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake(Index * CELL_WIDTH - CurrentMove - PermanentFrameMove, 20, CELL_WIDTH, 40);
        UILabel * TmpLabel = [[UILabel alloc] initWithFrame:TmpFrame];
        TmpLabel.text = [NSString stringWithFormat:@"L%d", Index];
        [ControlView addSubview:TmpLabel];
    }
    
    [self SetFrameValueWhenStopSelect];
}

- (void) FlashDisplayFrame
{
    if (self.GrooveCellList == nil)
    {
        return;
    }
    
    Boolean NoFucus = YES;
    
    for (int Index = 0; Index < self.GrooveCellList.count; Index++)
    {
        CGRect TmpFrame = CGRectMake(Index * CELL_WIDTH - CurrentMove - PermanentFrameMove, 20, CELL_WIDTH, 40);
        UILabel * TmpLabel = self.subviews[Index];
        TmpLabel.frame = TmpFrame;
        if (TmpFrame.origin.x + TmpFrame.size.width > self.bounds.size.width ||
            TmpFrame.origin.x < self.bounds.origin.x
            )
        {
            // if cell is out of view frame, it will be hidden.
            TmpLabel.hidden = YES;
        }
        else
        {
            TmpLabel.hidden = NO;
        }
        
        if ([self isFocusCell:TmpLabel])
        {
            self.FocusIndex = Index;
            NoFucus = NO;
        }
    }
    
    // This is for first Cell and last Cell
    // it avoid user have no focus cell
    if (self.FocusIndex == 0 && NoFucus)
    {
        PermanentFrameMove += [self Sensitivity];
        [self FlashDisplayFrame];
    }
    else if (self.FocusIndex == (self.GrooveCellList.count -1) && NoFucus)
    {
        PermanentFrameMove -= [self Sensitivity];
        [self FlashDisplayFrame];
    }
}

- (Boolean) isFocusCell: (UILabel *) Label
{
    if ((Label.frame.origin.x + Label.frame.size.width > self.bounds.size.width/2)
        && Label.frame.origin.x < self.bounds.size.width/2
        )
    {
        return YES;
    }
    return NO;
}

- (void) SetFrameValueWhenStopSelect
{
    int NewPermanentFrameMove = -1 * (CELL_WIDTH * (FIRST_CELL_OFFSET_COUNT - self.FocusIndex));
    PermanentFrameMove += CurrentMove;
    CurrentMove = 0;
    MoveToCenterCounter = NewPermanentFrameMove - PermanentFrameMove;
    MoveToCenterTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(MoveFocusCellToCenterTick:)
                                                       userInfo:nil
                                                        repeats:YES];
}


- (void) MoveFocusCellToCenterTick: (NSTimer *) ThisTimer
{
    if (MoveToCenterCounter >0)
    {
        PermanentFrameMove++;
        MoveToCenterCounter--;
    }
    else if(MoveToCenterCounter <0)
    {
        PermanentFrameMove--;
        MoveToCenterCounter++;
    }
    [self FlashDisplayFrame];
    
    
    if (MoveToCenterCounter == 0)
    {
        [MoveToCenterTimer invalidate];
        MoveToCenterTimer = nil;
    }
}

// ============================
// Property
- (int) Sensitivity
{
    return 2;
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
        [self SetFrameValueWhenStopSelect];
    }
}

- (int) GetFocusIndex
{
    return _FocusIndex;
}

- (void) SetFocusIndex:(int) NewValue
{
    if (_GrooveCellList == nil || self.subviews.count == 0)
    {
        return;
    }
    
    // Reset old Label background color
    UILabel * OldFocusLabel = self.subviews[_FocusIndex];
    OldFocusLabel.backgroundColor = [UIColor whiteColor];
    
    // Set New label background color
    _FocusIndex = NewValue;
    UILabel * NewFocusLabel = self.subviews[_FocusIndex];
    NewFocusLabel.backgroundColor = [UIColor blueColor];
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
            {
                [self FlashDisplayFrame];
            }
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
