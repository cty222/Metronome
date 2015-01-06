//
//  TempoListViewController.m
//  Groove
//
//  Created by C-ty on 2014/12/28.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "TempoListViewController.h"

@interface TempoListViewController ()

@end

@implementation TempoListViewController
{
    NSArray * _TempoListDataTable;
    TempoList *_CurrentList;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self InitializeListTablePicker];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self FillTempoListFromModel];
    [self SyncCurrentListFromModel];
    [self.ListTablePicker SetSelectedCell : _CurrentList];
}

- (void) InitializeListTablePicker
{
    [self.ListTablePicker removeFromSuperview];
    self.ListTablePicker = [[ListTablePicker alloc] initWithFrame:self.ListTablePicker.frame];
    [self.view addSubview:self.ListTablePicker];
    
    self.ListTablePicker.delegate = self;
}

- (void) SyncCurrentListFromModel
{
    _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:[GlobalConfig GetLastTempoListIndexUserSelected]];
    if (_CurrentList == nil)
    {
        NSLog(@"TempoListViewController : FetchCurrentTempoListFromModel from LastTempoListIndexUserSelected Error");
        _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:@0];
        if (_CurrentList == nil)
        {
            NSLog(@"TempoListViewController : FetchCurrentTempoListFromModel from 0 Error");
        }
        else
        {
            // 修正嚴重錯誤
            [GlobalConfig SetLastTempoListIndexUserSelected:0];
        }
    }
}

- (IBAction) Save: (UIButton *) SaveButton
{
    int NewIndex = (int)[self.ListTablePicker GetSelectedIndex];
    if (NewIndex < 0)
    {
        NSLog(@"Error: 有錯誤");
        NewIndex = 0;
    }
    [GlobalConfig SetLastTempoListIndexUserSelected:NewIndex];
    [self ChangeToTempoListPickerControllerView];
}

- (IBAction) AddNewItem: (NSString *) ItemName
{
    [gMetronomeModel CreateNewDefaultTempoList:ItemName];
    [gMetronomeModel SyncTempoListDataTableWithModel];
    [self FillTempoListFromModel];
}

- (IBAction) DeletItem : (TempoList *) TargetTempoList;
{
    if (_TempoListDataTable.count <= 1 )
    {
        return;
    }
    
    if ([_CurrentList isEqual:TargetTempoList])
    {
        for (TempoList * TmpList in gMetronomeModel.TempoListDataTable)
        {
            if (![TmpList isEqual:TargetTempoList])
            {
                _CurrentList = TmpList;
                break;
            }
        }
    }
    
    [gMetronomeModel DeleteTempoList:TargetTempoList];
    [gMetronomeModel SyncTempoListDataTableWithModel];
    [self FillTempoListFromModel];
    
    // 重要??
    [self.ListTablePicker SetSelectedCell: _CurrentList];
    int NewSelectIndex = (int)[self.ListTablePicker GetSelectedIndex];
    [GlobalConfig SetLastTempoListIndexUserSelected:NewSelectIndex];
}

- (void) FillTempoListFromModel
{
    _TempoListDataTable = gMetronomeModel.TempoListDataTable;
    self.ListTablePicker.TempoListArrayForBinding = _TempoListDataTable;
}


// ===============================
// Change Controller event
//

- (void) ChangeToTempoListPickerControllerView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackToSystemPageView object:nil];
}

//
// ===============================

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
