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


- (void) ChangeSelectBarForcusIndex: (int) NewValue
{
    self.SelectGrooveBar.NoneHumanChangeFocusFlag = YES;
    self.SelectGrooveBar.FocusIndex = NewValue;
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



#if 0
- (IBAction) DeleteLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    int DeleteIndex;
    int NewIndex;
    // 不可以刪掉最後一個
    if (CurrentCellsDataTable.count == 1 )
    {
        return;
    }
    
    DeleteIndex = Parent.FocusIndex;
    
    if (Parent.FocusIndex == 0)
    {
        NewIndex = Parent.FocusIndex +1 ;
    }
    else
    {
        NewIndex = Parent.FocusIndex -1 ;
    }
    [Parent ChangeSelectBarForcusIndex:NewIndex];
    
    // 找到要刪除的
    TempoCell * DeletedCell = CurrentCellsDataTable[DeleteIndex];
    [gMetronomeModel DeleteTargetTempoCell:DeletedCell];
    
    // 重新顯示
    DeleteFillDataFlag = YES;
    
    // TODO:
    //self.BottomSubView.DeleteLoopCellButton.enabled = NO;
}
#endif

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
    NSLog(@"DeleteTargetIndexCell");
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
   
    // 不可以刪掉最後一個
    if (Parent.CurrentCellsDataTable.count == 1 )
    {
        return;
    }
    
    // 如果刪的是focus cell, 先改成focus前一個, 如果是最前面就改成focus後一個
    if (Index == Parent.FocusIndex)
    {
        if (Index - 1 > 0)
        {
            Parent.FocusIndex = Index -1;
        }
        else
        {
            Parent.FocusIndex = Index + 1;;
        }
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