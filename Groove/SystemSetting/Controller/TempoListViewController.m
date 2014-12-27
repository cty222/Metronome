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
    _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:[GlobalConfig GetLastTempoListIndex]];
    if (_CurrentList == nil)
    {
        NSLog(@"TempoListViewController : FetchCurrentTempoListFromModel from LastTempoListIndex Error");
        _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:[GlobalConfig GetLastTempoListIndex]];
        if (_CurrentList == nil)
        {
            NSLog(@"TempoListViewController : FetchCurrentTempoListFromModel from 0 Error");
        }
    }
}

- (IBAction) Save: (UIButton *) SaveButton
{
    [GlobalConfig SetLastTempoListIndex:(int)[self.ListTablePicker GetSelectedIndex]];
    [gMetronomeModel Save];
    [self ChangeToTempoListPickerControllerView];
}

- (IBAction) AddNewItem: (UIButton *) AddButton
{
    [gMetronomeModel CreateNewDefaultTempoList:@"GG In In der"];
    [gMetronomeModel SyncTempoListDataTableWithModel];
    [self FillTempoListFromModel];
}

- (IBAction) DeletItem : (TempoList *) TargetTempoList;
{
    if (_TempoListDataTable.count <= 1 )
    {
        return;
    }
    
    [gMetronomeModel DeleteTempoList:TargetTempoList];
    [gMetronomeModel SyncTempoListDataTableWithModel];
    [self FillTempoListFromModel];
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
