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
    NSMutableArray * _CellValueToStringList;
    
    // Delete Cell
    TempoCell * _DeletedCell;
}

- (void) InitlizePlayingItems
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    self.PlayCurrentCellButton = Parent.volumeBottomSubview.PlayCurrentCellButton;
    
    // PlayLoopCellButton Initalize
    // black  playloop button
    [self.PlayCurrentCellButton addTarget:self
                                   action:@selector(PlayCurrentCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
}

- (void) InitializeLoopControlItem
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    self.SelectGrooveBar = Parent.volumeBottomSubview.SelectGrooveBar;
    
    self.SelectGrooveBar.delegate = self;
}


- (void) ChangeSelectBarForcusIndex: (int) NewIndex
{
    [self.SelectGrooveBar ChangeFocusIndexWithUIMoving: NewIndex];
}


- (void) CopyCellListToSelectBar : (NSArray *) CellDataTable
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    _CellValueToStringList = [[NSMutableArray alloc]init];
    for (TempoCell *Cell in CellDataTable)
    {
        [_CellValueToStringList addObject:[NSString stringWithFormat:@"%d", [Cell.loopCount intValue]]];
    }
    self.SelectGrooveBar.GrooveCellValueStringList = _CellValueToStringList;
    
    [self.SelectGrooveBar DisplayUICellList: [Parent getCurrentCellFromTempoList]];

}

// =========================
// Action
//
- (IBAction) PlayCurrentCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    if (Parent.currentPlayingMode == STOP_PLAYING)
    {
        Parent.currentPlayingMode = SINGLE_PLAYING;
    }
    else if (Parent.currentPlayingMode == SINGLE_PLAYING)
    {
        Parent.currentPlayingMode = STOP_PLAYING;
    }
}


// Loop 增減
- (void) SetTargetCellLoopCountAdd: (int) Index Value:(int)NewValue
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    TempoCell * TargetCell = Parent.engine.tempoCells[Index];
    
    
    if (NewValue < [[GlobalConfig TempoCellLoopCountMin] intValue])
    {
        NewValue = [[GlobalConfig TempoCellLoopCountMin] intValue];
    }
    else if (NewValue > [[GlobalConfig TempoCellLoopCountMax] intValue])
    {
        NewValue = [[GlobalConfig TempoCellLoopCountMax] intValue];
    }
    
    TargetCell.loopCount = [NSNumber numberWithInt:NewValue];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [_CellValueToStringList replaceObjectAtIndex:Index withObject:[NSString stringWithFormat:@"%d", NewValue]];
    
    [Parent syncTempoListWithModel];
    
    [Parent syncTempoCellDatatableWithModel];
    
    [Parent reflashCellListAndCurrentCellByCurrentData];

}

- (void) DeleteTargetIndexCell: (int) CurrentFocusIndex
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    // 不可以刪掉最後一個, 或大於Count > 或負數Index
    if ((Parent.engine.tempoCells.count <= 1 )
        || (Parent.engine.tempoCells.count <= CurrentFocusIndex )
        || (CurrentFocusIndex <0 )
        )
    {
        return;
    }

    // 找到要刪除的
    _DeletedCell = Parent.engine.tempoCells[CurrentFocusIndex];
    
    // 刪掉資料庫對應資料
    [gMetronomeModel DeleteTargetTempoCell:_DeletedCell];
    _DeletedCell = nil;

    // 重讀資料庫
    [Parent syncTempoListWithModel];
    
    [Parent syncTempoCellDatatableWithModel];
    
    // 如果刪掉的是最後一個
    // 向前移一個
    if (CurrentFocusIndex >= Parent.engine.tempoCells.count)
    {
        CurrentFocusIndex = (int)(Parent.engine.tempoCells.count -1);
    }
    Parent.currentSelectedCellIndex = CurrentFocusIndex;
    
    // TODO : 嚴重 同步問題！！！
    TempoList * CurrentListCell = Parent.engine.currentTempoList;
    CurrentListCell.focusCellIndex = [NSNumber numberWithInt:Parent.currentSelectedCellIndex];
    [gMetronomeModel Save];
    // ================
    
    // 重新顯示
    [Parent reflashCellListAndCurrentCellByCurrentData];

}

//
// =========================

// =========================
// delegate
//
- (void) SetFocusIndex:(int) NewValue
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    Parent.currentSelectedCellIndex = NewValue;
    
}

//
// =========================

@end
