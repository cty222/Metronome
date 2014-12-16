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
    
    // Delete Cell
    TempoCell * _DeletedCell;
}

- (void) InitlizePlayingItems
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    self.PlayCellListButton = Parent.TopSubView.PlayCellListButton;
    self.PlayCurrentCellButton = Parent.BottomSubView.PlayCurrentCellButton;
    self.PlayMusicButton = Parent.TopSubView.PlayMusicButton;
    
    
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

- (IBAction)PlayMusicButtonClick:(UIButton *)ThisClickedButton
{
    if (myPlayer.url == nil)
    {
        return;
    }
    
    if (!myPlayer.playing)
    {
        [myPlayer play];
    }
    else
    {
        [myPlayer stop];
        [myPlayer setCurrentTime:0.0];
    }
    [self PlayMusicStatusChangedCallBack:nil];
}

- (void) PlayMusicStatusChangedCallBack:(NSNotification *)Notification
{
    if (myPlayer.playing)
    {
        [self.PlayMusicButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.PlayMusicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


// Loop 增減
- (void) SetTargetCellLoopCountAdd: (int) Index Value:(int)NewValue
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    TempoCell * TargetCell = Parent.CurrentCellsDataTable[Index];
    
    
    if (NewValue < [[GlobalConfig LoopValueMin] intValue])
    {
        NewValue = [[GlobalConfig LoopValueMin] intValue];
    }
    else if (NewValue > [[GlobalConfig LoopValueMax] intValue])
    {
        NewValue = [[GlobalConfig LoopValueMax] intValue];
    }
    
    TargetCell.loopCount = [NSNumber numberWithInt:NewValue];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
    
    [_CellValueToStringList replaceObjectAtIndex:Index withObject:[NSString stringWithFormat:@"%d", NewValue]];
    
    [Parent FetchCurrentCellListFromModel];
    [Parent ReflashCellListAndFocusCellByCurrentData];

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

- (void) DeleteTargetIndexCell: (int) CurrentFocusIndex
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
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
    [Parent FetchCurrentCellListFromModel];
    
    // 如果刪掉的是最後一個
    // 向前移一個
    if (CurrentFocusIndex >= Parent.CurrentCellsDataTable.count)
    {
        CurrentFocusIndex = (int)(Parent.CurrentCellsDataTable.count -1);
    }
    Parent.FocusIndex = CurrentFocusIndex;
    
    [GlobalConfig SetLastFocusCellIndex: Parent.FocusIndex];

    // 重新顯示
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
