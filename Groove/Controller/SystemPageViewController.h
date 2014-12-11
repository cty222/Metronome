//
//  SystemPageViewController.h
//  Groove
//
//  Created by C-ty on 2014/11/28.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerForSongs.h"
#import "GlobalConfig.h"
#import "MetronomeModel.h"

@interface SystemPageViewController : UIViewController <MPMediaPickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (strong, nonatomic) IBOutlet UIButton *ReturnButton;

@property (strong, nonatomic) IBOutlet UILabel *CurrentSelectedList;
@property (strong, nonatomic) IBOutlet UIButton *ListSelector;
@property (strong, nonatomic) IBOutlet UISlider *ClickTotalValume;

@property (strong, nonatomic) IBOutlet UIButton *MusicSelector;
@property (strong, nonatomic) IBOutlet UILabel *CurrentSelectedMusic;
@property (strong, nonatomic) IBOutlet UISlider *MusicTotalVolume;

@end
