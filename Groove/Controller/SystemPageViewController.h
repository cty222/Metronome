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
#import "MusicTimePicker.h"

enum SYSTEM_INPUT_ID {
    MUSIC_STAR_TIME_ID,
    MUSIC_END_TIME_ID
};

@interface SystemPageViewController : UIViewController <MPMediaPickerControllerDelegate, AVAudioPlayerDelegate, InputSubmitViewProtocol>
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (strong, nonatomic) IBOutlet UIButton *ReturnButton;

@property (strong, nonatomic) IBOutlet UILabel *CurrentSelectedList;

@property (strong, nonatomic) IBOutlet UILabel *CurrentSelectedMusic;
@property (strong, nonatomic) IBOutlet UISlider *MusicTotalVolume;

@property (strong, nonatomic) IBOutlet UILabel *StartTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *EndTimeLabel;


@property (strong, nonatomic) IBOutlet UIView *SubInputView;
@property (strong, nonatomic) IBOutlet MusicTimePicker *MusicTimePicker;
@property (strong, nonatomic) IBOutlet UIView *CancelSubInputView;
@property (strong, nonatomic) IBOutlet UILabel *DurationLabel;


@property (strong, nonatomic) IBOutlet UISwitch *MusicRateToHalfSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *PlayCellListWithMusicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *PlaySingleCellWithMusicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *ShowMusicButtonInMainViewSwitch;

@end
