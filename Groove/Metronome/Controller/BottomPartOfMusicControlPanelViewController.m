//
//  BottomPartOfMusicControlPanelViewController.m
//  RockClick
//
//  Created by C-ty on 2016-01-30.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "BottomPartOfMusicControlPanelViewController.h"

@interface BottomPartOfMusicControlPanelViewController ()

@property GlobalServices * globalServices;

@end

@implementation BottomPartOfMusicControlPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (id) initWithGlobalServices: (GlobalServices *) globalServices{
    self = [super init];
    
    if (self){
        self.globalServices = globalServices;
    }
    
    return self;
}

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
