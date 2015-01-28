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
    UIAlertView *_TempoCellOverMaxCountAlert;

}

- (void) MainViewWillAppear
{
    [self PlayMusicStatusChangedCallBack:nil];
}

- (void) InitlizePlayingItems
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    self.PlayCellListButton = Parent.TopSubView.PlayCellListButton;
    self.PlayCurrentCellButton = Parent.BottomSubView.PlayCurrentCellButton;
    self.PlayMusicButton = Parent.TopSubView.PlayMusicButton;
    
    
    // PlayLoopCellButton Initalize
    // black  playloop button
    [self.PlayCurrentCellButton addTarget:self
                                   action:@selector(PlayCurrentCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    // PlayCellListButton Initialize
    [self.PlayCellListButton addTarget:self
                                action:@selector(PlayCellListButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    // PlayCellListButton Initialize
    [self.PlayMusicButton addTarget:self
                                action:@selector(PlayMusicButtonClick:) forControlEvents:UIControlEventTouchDown];
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PlayMusicStatusChangedCallBack:)
                                                 name:kPlayMusicStatusChangedEvent
                                               object:nil];
    
    
}

- (void) InitializeLoopControlItem
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    self.SelectGrooveBar = Parent.BottomSubView.SelectGrooveBar;
    self.AddLoopCellButton = Parent.TopSubView.AddLoopCellButton;
    
    [self.AddLoopCellButton addTarget:self
                               action:@selector(AddLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    self.SelectGrooveBar.delegate = self;
}

- (void) ChangeButtonDisplayByPlayMode
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    switch (Parent.PlayingMode) {
        case STOP_PLAYING:
            [self.PlayCurrentCellButton setBackgroundImage:[UIImage imageNamed:@"PlayBlack"] forState:UIControlStateNormal];
            [self.PlayCellListButton setBackgroundImage:[UIImage imageNamed:@"PlayList"] forState:UIControlStateNormal];
            break;
        case SINGLE_PLAYING:
            [self.PlayCurrentCellButton setBackgroundImage:[UIImage imageNamed:@"PlayRed"] forState:UIControlStateNormal];
            break;
        case LIST_PLAYING:
            // TODO : 要改成Stop圖
            [self.PlayCurrentCellButton setBackgroundImage:[UIImage imageNamed:@"PlayRed"] forState:UIControlStateNormal];
            [self.PlayCellListButton setBackgroundImage:[UIImage imageNamed:@"PlayList_Red"] forState:UIControlStateNormal];
            break;
    }
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
    
    [self.SelectGrooveBar DisplayUICellList: [Parent GetFocusCellWithCurrentTempoList]];

}

// =========================
// Action
//

- (IBAction) PlayCellListButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

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
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    if (Parent.PlayingMode == STOP_PLAYING)
    {
        Parent.PlayingMode = SINGLE_PLAYING;
    }
    else if (Parent.PlayingMode == SINGLE_PLAYING)
    {
        Parent.PlayingMode = STOP_PLAYING;
    }
}

- (IBAction)PlayMusicButtonClick:(UIButton *)ThisClickedButton
{
    if (gPlayMusicChannel.URL == nil)
    {
        return;
    }
    
    if (!gPlayMusicChannel.Playing)
    {
        [gPlayMusicChannel Play];
    }
    else
    {
        [gPlayMusicChannel Stop];
    }
    
    [self PlayMusicStatusChangedCallBack:nil];
}

- (void) PlayMusicStatusChangedCallBack:(NSNotification *)Notification
{
    if (gPlayMusicChannel.Playing)
    {
        [self.PlayMusicButton setBackgroundImage:[UIImage imageNamed:@"PlayMusic_Red"] forState:UIControlStateNormal];
    }
    else
    {
        [self.PlayMusicButton setBackgroundImage:[UIImage imageNamed:@"PlayMusic"] forState:UIControlStateNormal];
    }
}


// Loop 增減
- (void) SetTargetCellLoopCountAdd: (int) Index Value:(int)NewValue
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    TempoCell * TargetCell = Parent.CurrentCellsDataTable[Index];
    
    
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
    
    [Parent SyncCurrentTempoListFromModel];
    
    [Parent SyncCurrentTempoCellDatatableWithModel];
    
    [Parent ReflashCellListAndFocusCellByCurrentData];

}

- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    if (Parent.CurrentCellsDataTable.count >= [[GlobalConfig TempoCellNumberMax] integerValue])
    {
        // TODO: 警告數量超過了
        // 超過了
        if (_TempoCellOverMaxCountAlert ==nil)
        {
            _TempoCellOverMaxCountAlert = [[UIAlertView alloc]
                                           initWithTitle:LocalStringSync(@"Too many tempo items", nil)
                                           message:LocalStringSync(@"You can't add more than 20 tempo items in one tempo list !!", nil)
                                           delegate:nil
                                           cancelButtonTitle:LocalStringSync(@"OK, I know it.", nil)
                                           otherButtonTitles:nil, nil];
        }
        [_TempoCellOverMaxCountAlert show];
        return;
    }
    
    // 新增一筆進資料庫
    [gMetronomeModel AddNewTempoCell: Parent.CurrentTempoList];
    
    // 重新顯示
    [Parent SyncCurrentTempoListFromModel];
    
    [Parent SyncCurrentTempoCellDatatableWithModel];
    
    TempoList * CurrentListCell = Parent.CurrentTempoList;
    
    // TODO : 嚴重 同步問題！！！
    CurrentListCell.focusCellIndex = [NSNumber numberWithInt:(int)(Parent.CurrentCellsDataTable.count - 1)];
    [gMetronomeModel Save];
    
    
    [Parent ReflashCellListAndFocusCellByCurrentData];
}

- (void) DeleteTargetIndexCell: (int) CurrentFocusIndex
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    // 不可以刪掉最後一個, 或大於Count > 或負數Index
    if ((Parent.CurrentCellsDataTable.count <= 1 )
        || (Parent.CurrentCellsDataTable.count <= CurrentFocusIndex )
        || (CurrentFocusIndex <0 )
        )
    {
        return;
    }

    // 找到要刪除的
    _DeletedCell = Parent.CurrentCellsDataTable[CurrentFocusIndex];
    
    // 刪掉資料庫對應資料
    [gMetronomeModel DeleteTargetTempoCell:_DeletedCell];
    _DeletedCell = nil;

    // 重讀資料庫
    [Parent SyncCurrentTempoListFromModel];
    
    [Parent SyncCurrentTempoCellDatatableWithModel];
    
    // 如果刪掉的是最後一個
    // 向前移一個
    if (CurrentFocusIndex >= Parent.CurrentCellsDataTable.count)
    {
        CurrentFocusIndex = (int)(Parent.CurrentCellsDataTable.count -1);
    }
    Parent.FocusIndex = CurrentFocusIndex;
    
    // TODO : 嚴重 同步問題！！！
    TempoList * CurrentListCell = Parent.CurrentTempoList;
    CurrentListCell.focusCellIndex = [NSNumber numberWithInt:Parent.FocusIndex];
    [gMetronomeModel Save];
    // ================
    
    // 重新顯示
    [Parent ReflashCellListAndFocusCellByCurrentData];

}

//
// =========================

// =========================
// delegate
//
- (void) SetFocusIndex:(int) NewValue
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    Parent.FocusIndex = NewValue;
    
}

//
// =========================

@end
