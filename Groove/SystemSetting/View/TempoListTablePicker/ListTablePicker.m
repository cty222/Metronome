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
    _TempoListArrayForBinding = [NSMutableArray arrayWithArray:NewDataTableArray];
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
 
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake( 0.0, 0.0, 50, 50);
    button.frame = frame;
    button.backgroundColor = [UIColor redColor];
    cell.accessoryView = button;
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];*/

    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event{
    NSLog(@"Tapping!!");
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
    return @"刪除";
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
            NSLog(@"%@", Subview.subviews);
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
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            NSLog(@"Delete!!");
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
