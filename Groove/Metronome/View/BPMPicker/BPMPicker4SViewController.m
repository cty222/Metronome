//
//  BPMPicker4SViewController.m
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "BPMPicker4SViewController.h"

@interface BPMPicker4SViewController ()

@end

@implementation BPMPicker4SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) SetMode: (BPM_PICKER_MODE) NewValue
{
    [super SetMode:NewValue];
 
    if (self.Mode == BPM_PICKER_INT_MODE) {
        self.ValueLabel.font = [self.ValueLabel.font  fontWithSize:110];
    }
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
