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
    UIImage *_RedPlayCurrentImage;
    UIImage *_BlackPlayCurrentImage;
    
    NSMutableArray * _CellValueToStringList;
}

- (void) InitlizePlayingItems
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    self.PlayCellListButton = Parent.TopSubView.PlayCellListButton;
    self.PlayCurrentCellButton = Parent.BottomSubView.PlayCurrentCellButton;
    
    // PlayLoopCellButton Initalize
    // red  playloop button
    UIGraphicsBeginImageContext(self.PlayCurrentCellButton.frame.size);
    [[UIImage imageNamed:@"LoopPlay_red"] drawInRect:self.PlayCurrentCellButton.bounds];
    _RedPlayCurrentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // bloak  playloop button
    UIGraphicsBeginImageContext(self.PlayCurrentCellButton.frame.size);
    [[UIImage imageNamed:@"LoopPlay_black"] drawInRect:self.PlayCurrentCellButton.bounds];
    _BlackPlayCurrentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_BlackPlayCurrentImage];

    [self.PlayCurrentCellButton addTarget:self
                                   action:@selector(PlayCurrentCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    // PlayCellListButton Initialize
    [self.PlayCellListButton addTarget:self
                                action:@selector(PlayCellListButtonClick:) forControlEvents:UIControlEventTouchDown];
}

- (void) InitializeLoopControlItem
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    self.SelectGrooveBar = Parent.BottomSubView.SelectGrooveBar;
    self.AddLoopCellButton = Parent.TopSubView.AddLoopCellButton;
    
    [self.AddLoopCellButton addTarget:self
                               action:@selector(AddLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    self.SelectGrooveBar.delegate = self;
}

- (void) ChangeButtonDisplayByPlayMode
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    switch (Parent.PlayingMode) {
        case STOP_PLAYING:
            self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_BlackPlayCurrentImage];
            [self.PlayCellListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case SINGLE_PLAYING:
            self.PlayCurrentCellButton.backgroundColor = [UIColor colorWithPatternImage:_RedPlayCurrentImage];
            break;
        case LIST_PLAYING:
            // TODO : 要改成Stop圖
            [self.PlayCellListButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            break;
    }
}


- (void) ChangeSelectBarForcusIndex: (int) NewIndex
{
    [self.SelectGrooveBar ChangeFocusIndexWithUIMoving: NewIndex];
}


- (void) CopyCellListToSelectBar : (NSArray *) CellDataTable
{
    _CellValueToStringList = [[NSMutableArray alloc]init];
    for (TempoCell *Cell in CellDataTable)
    {
        [_CellValueToStringList addObject:[NSString stringWithFormat:@"%d", [Cell.loopCount intValue]]];
    }
    self.SelectGrooveBar.GrooveCellValueStringList = _CellValueToStringList;
}

// =========================
// Action
//

- (IBAction) PlayCellListButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    if (Parent.PlayingMode == SINGLE_PLAYING)
    {
        Parent.PlayingMode = STOP_PLAYING;
    }
    
    if (Parent.PlayingMode == STOP_PLAYING)
    {
        Parent.PlayingMode = LIST_PLAYING;
    }
    else if(Parent.PlayingMode == LIST_PLAYING)
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


// Loop 增減
- (void) SetTargetCellLoopCountAdd: (int) Index AddValue:(int)Value
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    TempoCell * TargetCell = Parent.CurrentCellsDataTable[Index];
    
    
    int NewTotalValue = [TargetCell.loopCount intValue] + Value;
    
    if (NewTotalValue >= [[GlobalConfig LoopValueMin] intValue] && NewTotalValue <= [[GlobalConfig LoopValueMax] intValue])
    {
        TargetCell.loopCount = [NSNumber numberWithInt:NewTotalValue];
        
        // TODO : 不要save這麼頻繁
        [gMetronomeModel Save];
        
        [_CellValueToStringList replaceObjectAtIndex:Index withObject:[NSString stringWithFormat:@"%d", NewTotalValue]];
        
        [Parent FetchCurrentCellListFromModel];
        [Parent ReflashCellListAndFocusCellByCurrentData];
    }
}

- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    // 新增一筆進資料庫
    [gMetronomeModel AddNewTempoCell];
    
    // 重新顯示
    [Parent FetchCurrentCellListFromModel];
    [GlobalConfig SetLastFocusCellIndex: (int)(Parent.CurrentCellsDataTable.count - 1)];
    [Parent ReflashCellListAndFocusCellByCurrentData];
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
    [Parent FetchCurrentCellListFromModel];
    [Parent ReflashCellListAndFocusCellByCurrentData];
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

//
// =========================

@end
