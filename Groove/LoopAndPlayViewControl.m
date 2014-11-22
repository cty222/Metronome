//
//  LoopAndPlayingControl.m
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LoopAndPlayViewControl.h"

@implementation LoopAndPlayViewControl
{
    // PlayCell Image
    UIImage *_SinglePlayImage;
    UIImage *_RedPlayloopImage;
    UIImage *_BlackPlayloopImage;
    
    NSMutableArray * _GrooveLoopList;
}

- (void) InitlizePlayingItems
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    self.PlayCurrentCellButton = Parent.TopSubView.PlayCurrentCellButton;
    self.PlayLoopCellButton = Parent.BottomSubView.PlayLoopCellButton;
    
    // PlayLoopCellButton Initalize
    // red  playloop button
    UIGraphicsBeginImageContext(self.PlayLoopCellButton.frame.size);
    [[UIImage imageNamed:@"LoopPlay_red"] drawInRect:self.PlayLoopCellButton.bounds];
    _RedPlayloopImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.PlayLoopCellButton.backgroundColor = [UIColor colorWithPatternImage:_RedPlayloopImage];
    
    // bloak  playloop button
    UIGraphicsBeginImageContext(self.PlayLoopCellButton.frame.size);
    [[UIImage imageNamed:@"LoopPlay_black"] drawInRect:self.PlayLoopCellButton.bounds];
    _BlackPlayloopImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Play Current cell button initialize
    UIGraphicsBeginImageContext(self.PlayCurrentCellButton.frame.size);
    [[UIImage imageNamed:@"SinglePlay"] drawInRect:self.PlayCurrentCellButton.bounds];
    _SinglePlayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
    
    [self.PlayCurrentCellButton addTarget:self
                                   action:@selector(PlayCurrentCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    
    // Play LoopCellButton Initialize
    [self.PlayLoopCellButton addTarget:self
                                action:@selector(PlayLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
}

- (void) InitializeLoopControlItem
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    self.SelectGrooveBar = Parent.BottomSubView.SelectGrooveBar;
    self.AddLoopCellButton = Parent.BottomSubView.AddLoopCellButton;
    
    [self.AddLoopCellButton addTarget:self
                               action:@selector(AddLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    self.SelectGrooveBar.delegate = self;
}

- (void) ChangeButtonDisplayByPlayMode
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    switch (Parent.PlayingMode) {
        case STOP_PLAYING:
            self.PlayLoopCellButton.backgroundColor = [UIColor colorWithPatternImage:_RedPlayloopImage];
            self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
            break;
        case SINGLE_PLAYING:
            // TODO : 要改成Stop圖
            self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
            break;
        case LOOP_PLAYING:
            self.PlayLoopCellButton.backgroundColor = [UIColor colorWithPatternImage:_BlackPlayloopImage];
            break;
    }
}


- (void) ChangeSelectBarForcusIndex: (int) NewIndex
{
    [self.SelectGrooveBar ChangeFocusIndexByFunction: NewIndex];
}


- (void) CopyGrooveLoopListToSelectBar : (NSArray *) CellDataTable
{
    _GrooveLoopList = [[NSMutableArray alloc]init];
    for (TempoCell *Cell in CellDataTable)
    {
        [_GrooveLoopList addObject:[NSString stringWithFormat:@"%d", [Cell.loopCount intValue]]];
    }
    self.SelectGrooveBar.GrooveCellValueStringList = _GrooveLoopList;
}

// =========================
// Action
//
- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    // 新增一筆進資料庫
    [gMetronomeModel AddNewTempoCell];
    
    // 重新顯示
    [Parent FillData];
}


- (IBAction) PlayLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    if (Parent.PlayingMode == SINGLE_PLAYING)
    {
        Parent.PlayingMode = STOP_PLAYING;
        
        self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_SinglePlayImage];
    }
    
    if (Parent.PlayingMode == STOP_PLAYING)
    {
        Parent.PlayingMode = LOOP_PLAYING;
    }
    else if(Parent.PlayingMode == LOOP_PLAYING)
    {
        Parent.PlayingMode = STOP_PLAYING;
    }
    
}

- (IBAction) PlayCurrentCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    if (Parent.PlayingMode == STOP_PLAYING)
    {
        Parent.PlayingMode = SINGLE_PLAYING;
    }
    else if (Parent.PlayingMode == SINGLE_PLAYING)
    {
        Parent.PlayingMode = STOP_PLAYING;
    }
}

//
// =========================

// =========================
// delegate
//
// 不會設下去到Bottom View UI
- (void) SetFocusIndex:(int) NewValue
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    Parent.FocusIndex = NewValue;
    
}

// Loop 增減
- (BOOL) SetTargetCellLoopCountAdd: (int) Index AddValue:(int)Value;
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    TempoCell * TargetCell = Parent.CurrentCellsDataTable[Index];
    
    
    int NewTotalValue = [TargetCell.loopCount intValue] + Value;

    if (NewTotalValue >= [[GlobalConfig LoopValueMin] intValue] && NewTotalValue <= [[GlobalConfig LoopValueMax] intValue])
    {
        TargetCell.loopCount = [NSNumber numberWithInt:NewTotalValue];
        
        // TODO : 不要save這麼頻繁
        [gMetronomeModel Save];
        
        [_GrooveLoopList replaceObjectAtIndex:Index withObject:[NSString stringWithFormat:@"%d", NewTotalValue]];

        return YES;
    }
    
    return NO;
}

- (void) DeleteTargetIndexCell: (int) Index
{

    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
   
    // 不可以刪掉最後一個, 或大於Count > 或負數Index
    if ((Parent.CurrentCellsDataTable.count <= 1 )
        || (Parent.CurrentCellsDataTable.count <= Index )
        || (Index <0 )
        )
    {
        return;
    }
    

    int NewIndex = -1;
    // 如果刪的是focus cell, 先改成focus前一個, 如果是最前面就改成focus後一個
    if (Index == Parent.FocusIndex)
    {
        if (Index - 1 >= 0)
        {
            NewIndex = Index -1;
        }
        else
        {
            NewIndex = Index + 1;;
        }
        [self ChangeSelectBarForcusIndex:NewIndex];
    }

    
    // 找到要刪除的
    TempoCell * DeletedCell = Parent.CurrentCellsDataTable[Index];
    [gMetronomeModel DeleteTargetTempoCell:DeletedCell];
    
    // 重新顯示
    [Parent FillData];
}
//
// =========================

@end
