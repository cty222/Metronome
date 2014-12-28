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
#import "TempoListViewController.h"
#import "MusicTimePicker.h"
#import "ListTablePicker.h"

enum SYSTEM_INPUT_ID {
    NONE_ID,
    MUSIC_STAR_TIME_ID = 1,
    MUSIC_END_TIME_ID,
    TEMPO_LIST_PICKER_ID = 10,
};

@interface SystemPageViewController : UIViewController <MPMediaPickerControllerDelegate, AVAudioPlayerDelegate, MusicTimePickerProtocol>
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

@property (strong, nonatomic) IBOutlet UISwitch *EnableMusicFunction;
@property (strong, nonatomic) IBOutlet UISwitch *MusicRateToHalfSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *PlaySingleCellWithMusicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *PlayListWithMusicSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *PlayMusicLoopingSwitch;



@end
