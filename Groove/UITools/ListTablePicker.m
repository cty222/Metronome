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
    NSArray * _TempoListArrayForBinding;
    
    UIAlertView *_NoSelectedAlert;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.TableView.delegate = self;
        self.TableView.dataSource = self;
        self.TableView.multipleTouchEnabled = NO;
    }
    return self;
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
    _TempoListArrayForBinding = NewDataTableArray;
    [self.TableView reloadData];
}

//
// =============================
- (IBAction) AddNewItem: (UIButton *) AddButton
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(AddNewItem:)])
        {
            [self.delegate AddNewItem: AddButton];
        }
    }
}

- (IBAction)DeleteCell: (TempoListUICell *) Cell
{
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(DeletItem:)])
        {
            [self.delegate DeletItem: Cell.TempoList];
        }
    }
}


- (IBAction) Save: (UIButton *) SaveButton
{
    if ([self GetSelectedIndex] <0)
    {
        if (_NoSelectedAlert == nil)
        {
            _NoSelectedAlert = [[UIAlertView alloc]
                                initWithTitle:@"Selected Warming"
                                message:@"No Selected Item"
                                delegate:nil
                                cancelButtonTitle:@"OK, I know it."
                                otherButtonTitles:nil, nil];
        }
        [_NoSelectedAlert show];
        return;
    }
    
    [super Save:SaveButton];
}

//================================
//TableView protocol function
//
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.TempoListArrayForBinding.count; //回傳有幾筆資料要呈現
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

static NSString *Identifier = @"tableidentifier"; //設定一個就算離開畫面也還是抓得到的辨識目標
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //在繪製每一列時會呼叫的方法
    
    TempoListUICell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[TempoListUICell alloc] init];
        TempoList * CellList = [self.TempoListArrayForBinding objectAtIndex:indexPath.row];
        
        cell.TempoList = CellList;
        cell.delegate = self;
       // cell.SwitchMute
    }
    
    return cell;
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
