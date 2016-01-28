//
//  TopPartOfMetronomeViewController.m
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "TopPartOfMetronomeViewController.h"

@interface TopPartOfMetronomeViewController ()

@end

@implementation TopPartOfMetronomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) initBPMPicker {
    self.bPMPickerViewController = [[BPMPickerViewController alloc] init];
}

- (id) init{
    self = [super init];
    if (self) {
        // Initialization code
        [self initBPMPicker];
        [self.view addSubview:self.bPMPickerViewController.view];
        [self.view bringSubviewToFront:self.SystemButton];
        
        [self.TimeSignaturePickerView removeFromSuperview];
        self.TimeSignaturePickerView = [[TimeSignaturePickerView alloc] initWithFrame:self.TimeSignaturePickerView.frame];
        [self.view addSubview:self.TimeSignaturePickerView];
        [self.view sendSubviewToBack:self.TimeSignaturePickerView];
        
        [self.VoiceTypePickerView removeFromSuperview];
        self.VoiceTypePickerView = [[VoiceTypePickerView alloc] initWithFrame:self.VoiceTypePickerView.frame];
        [self.view addSubview:self.VoiceTypePickerView];
        [self.view sendSubviewToBack:self.VoiceTypePickerView];
        
        [self.LoopCellEditerView removeFromSuperview];
        self.LoopCellEditerView = [[LoopCellEditerView alloc] initWithFrame:self.LoopCellEditerView.frame];
        [self.view addSubview:self.LoopCellEditerView];
        [self.view sendSubviewToBack:self.LoopCellEditerView];
        
        [self.TapAnimationImage removeFromSuperview];
        self.TapAnimationImage = [[TapAnimationImage alloc] initWithFrame:self.TapAnimationImage.frame];
        [[self view] addSubview:self.TapAnimationImage];
        
        self.TapAnimationImage.hidden = YES;
        self.TimeSignaturePickerView.hidden = YES;
        self.VoiceTypePickerView.hidden = YES;
        self.LoopCellEditerView.hidden = YES;
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
