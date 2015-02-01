//
//  ListTablePicker.m
//  Groove
//
//  Created by C-ty on 2014/12/23.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "ListTablePicker.h"


@implementation ListTablePicker
{
    NSMutableArray * _TempoListArrayForBinding;
    
    UIAlertView *_NoSelectedAlert;
    UIAlertView *_TempoListOverMaxCountAlert;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.TableView.delegate = self;
        self.TableView.dataSource = self;
        self.TableView.multipleTouchEnabled = NO;
        self.TableView.allowsSelectionDuringEditing = YES;
        self.TableView.separatorColor = [UIColor blackColor];
        self.TableView.backgroundColor = [UIColor grayColor];
        self.TableView.editing = NO;

        [self InitializeEditerView];
        
        [self LocalizedStringInitialize];
    }
    return self;
}

- (void) LocalizedStringInitialize
{
    [self.SaveButton setTitle:LocalStringSync(@"Done", nil) forState:UIControlStateNormal];
    [self.AddButton setTitle:LocalStringSync(@"Add", nil) forState:UIControlStateNormal];
}

- (void) InitializeEditerView
{
    [self.NameEditer removeFromSuperview];
    self.NameEditer = [[NameEditer alloc] initWithFrame:self.NameEditer.frame];
    [self.EditerView addSubview:self.NameEditer];
    self.NameEditer.delegate = self;
    
    [self CloseEditerView];
}

- (IBAction) EditTempListName : (TempoListUICell *) Cell
{
    self.NameEditer.ID = YES;
    if (Cell != nil)
    {
        self.NameEditer.TempoList = Cell.TempoList;
    }
    else
    {
       self.NameEditer.TempoList = nil;
    }

    self.EditerView.hidden = NO;
}

- (void) CloseEditerView
{
    [self.NameEditer.NewName resignFirstResponder];
    self.NameEditer.ID = NO;
    self.EditerView.hidden = YES;
}

// =============================
// property
//
- (NSArray *)GetTempoListArrayForBinding
{
    return _TempoListArrayForBinding;
}

- (void) SetTempoListArrayForBinding : (NSArray *)NewDataTableArray
{
#if WRONG_WAY_TO_RELOADDATA
    _TempoListArrayForBinding = [NSMutableArray arrayWithArray:NewDataTableArray];
    [self.TableView reloadData];
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        _TempoListArrayForBinding = [NSMutableArray arrayWithArray:NewDataTableArray];
        [self.TableView reloadData];
    });
#endif
}

//
// =============================
- (IBAction) AddNewItem: (UIButton *) AddButton
{
    if (_TempoListArrayForBinding.count >= [[GlobalConfig TempoListNumberCountMax] intValue])
    {
        if (_TempoListOverMaxCountAlert ==nil)
        {
            _TempoListOverMaxCountAlert = [[UIAlertView alloc]
                                           initWithTitle:LocalStringSync(@"Too many tempo lists", nil)
                                           message:LocalStringSync(@"You can't add more than 20 tempo lists !!", nil)
                                           delegate:nil
                                           cancelButtonTitle:LocalStringSync(@"OK, I know it.", nil)
                                           otherButtonTitles:nil, nil];
        }
        [_TempoListOverMaxCountAlert show];
        return;
    }
    // nil 代表要新增
    [self EditTempListName : nil];
}

- (IBAction) AddCell: (NSString *) CellName
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(AddNewItem:)])
        {
            [self.delegate AddNewItem: CellName];
        }
    }
}

- (IBAction) DeleteCell: (TempoListUICell *) Cell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(DeleteItem:)])
        {
            [self.delegate DeleteItem: Cell.TempoList];
        }
    }
}

- (IBAction) EditCell:(TempoListUICell *) Cell
{
    [self EditTempListName: Cell];
}

- (IBAction) Save: (UIButton *) SaveButton
{
    if (self.NameEditer.ID)
    {
        //Always change the dataSource and reloadData in the mainThread. What's more, reloadData should be called immediately after the dataSource change.
        //If dataSource is changed but tableView's reloadData method is not called immediately, the tableView may crash if it's in scrolling.
        //Crash Reason: There is still a time gap between the dataSource change and reloadData. If the table is scrolling during the time gap, the app may Crash!!!!
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.NameEditer.TempoList != nil)
            {
                self.NameEditer.TempoList.tempoListName = self.NameEditer.NewName.text;
                self.NameEditer.TempoList = nil;
                [gMetronomeModel Save];
            }
            else
            {
                [self AddCell: self.NameEditer.NewName.text];
            }
        
           [self.TableView reloadData];
        });
        
        [self CloseEditerView];
        return;
    }
    
    if ([self GetSelectedIndex] <0)
    {
        if (_NoSelectedAlert == nil)
        {
            _NoSelectedAlert = [[UIAlertView alloc]
                                initWithTitle:LocalStringSync(@"Selected Warming", nil)
                                message:LocalStringSync(@"No Selected Item", nil)
                                delegate:nil
                                cancelButtonTitle:LocalStringSync(@"OK, I know it.", nil)
                                otherButtonTitles:nil, nil];
        }
        [_NoSelectedAlert show];
        return;
    }
    
    [super Save:SaveButton];
}

- (IBAction) Cancel : (UIButton *) CancelButton
{
    if (self.NameEditer.ID)
    {
        [self CloseEditerView];
        return;
    }
}

//================================
//TableView protocol function
//

//回傳有幾筆資料要呈現
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.TempoListArrayForBinding.count;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//在繪製每一列時會呼叫的方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"tableidentifier"; //設定一個就算離開畫面也還是抓得到的辨識目標

    TempoListUICell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[TempoListUICell alloc] init];
        TempoList * CellList = [self.TempoListArrayForBinding objectAtIndex:indexPath.row];
        
        cell.TempoList = CellList;
        cell.delegate = self;
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    TempoList * CellListSource = _TempoListArrayForBinding[sourceIndexPath.row];
    TempoList * CellListDestination = _TempoListArrayForBinding[destinationIndexPath.row];
    NSNumber * SrcSortIndex = CellListSource.sortIndex;
    NSNumber * DstSortIndex = CellListDestination.sortIndex;
    CellListSource.sortIndex = DstSortIndex;
    CellListDestination.sortIndex = SrcSortIndex;
    [gMetronomeModel Save];
    
    [_TempoListArrayForBinding exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LocalStringSync(@"Delete", nil);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tap  accessoryButton");
}
//
// select cell
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 舊的不用換成未選取, 因為沒有開multipleTouchEnabled
    
    // 新的換成選取
    TempoListUICell * NewSelectedUITempoList = (TempoListUICell *)[tableView cellForRowAtIndexPath:indexPath];
    if (NewSelectedUITempoList != nil)
    {
        // 改成selected
        NewSelectedUITempoList.selected = YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self HideDeleteIcon: cell];
}

- (void) HideDeleteIcon : (UITableViewCell *)Cell
{
    for (UIView *Subview in Cell.subviews) {
        if ([NSStringFromClass([Subview class]) isEqualToString:@"UITableViewCellScrollView"])
        {
            for (UIView *ControlView in Subview.subviews) {
                if ([NSStringFromClass([ControlView class]) isEqualToString:@"UITableViewCellEditControl"])
                {
                    ControlView.hidden = YES;
                    return;
                }
            }
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TempoListUICell * UITempoList = (TempoListUICell *)[tableView cellForRowAtIndexPath:indexPath];

    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            [self DeleteCell:UITempoList];
            break;
        default:
            break;
    }
}

- (NSInteger) GetSelectedIndex
{
    NSInteger SelectedIndex = -1;
    
    NSArray * VisableArray = [self.TableView visibleCells];
    
    for (NSInteger Index = 0; Index < VisableArray.count; Index++)
    {
        TempoListUICell * TempUITempoList = VisableArray[Index];
        if (TempUITempoList.selected)
        {
            SelectedIndex = Index;
            break;
        }
    }

    return SelectedIndex;
}

- (void) SetSelectedCell : (TempoList *) TargetTempoList
{
    NSArray * VisableArray = [self.TableView visibleCells];
    
    for (NSInteger Index = 0; Index < VisableArray.count; Index++)
    {
        TempoListUICell * TempUITempoList = VisableArray[Index];
        if (TempUITempoList.TempoList == TargetTempoList)
        {
            NSIndexPath *pathToRow = [NSIndexPath indexPathForRow:Index inSection:0];

            // 用這才不會有multipleTouchEnabled 的問題
            [self.TableView selectRowAtIndexPath:pathToRow animated:YES  scrollPosition:UITableViewScrollPositionBottom];
            break;
        }
    }
}

// ========================================

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
