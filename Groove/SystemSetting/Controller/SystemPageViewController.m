//
//  SystemPageViewController.m
//  Groove
//
//  Created by C-ty on 2014/11/28.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SystemPageViewController.h"
@interface SystemPageViewController ()

@end

@implementation SystemPageViewController
{
    MPMediaPickerController *_MusicPicker;
    TempoList *_CurrentList;
    MusicProperties * _MusicProperty;
    
    NSArray * _TempoListDataTable;
    BOOL _TwickLingEnable;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self StartTwickLing];
    
    if (_MusicPicker == nil)
    {
        _MusicPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        _MusicPicker.allowsPickingMultipleItems = NO;
        _MusicPicker.showsCloudItems = NO;
        _MusicPicker.delegate = self;
    }
    
    // ===================
    // Setup music by model music info

    if (gPlayMusicChannel == nil)
    {
        gPlayMusicChannel = [PlayerForSongs alloc];
    }
    
    _TempoListDataTable = gMetronomeModel.TempoListDataTable;

    // ===================
    // UI state Sync
    [self SyncCurrentListFormGlobalConfig];
    
    [self SyncPageInfoByCurrentTempoList];
    [self SyncMetronomePrivateProperties];
    [self SyncMusicPropertyFromGlobalConfig];
    [self SyncStartAndEndTime];
    
    self.SubInputView.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect FullViewFrame = self.FullView.frame;
    
    NSNumber * DeviceType = [GlobalConfig DeviceType];
    switch (DeviceType.intValue) {
        case IPHONE_4S:
            FullViewFrame = CGRectMake(FullViewFrame.origin.x
                                       , FullViewFrame.origin.y
                                       , FullViewFrame.size.width
                                       , IPHONE_4S_HEIGHT
                                       );
            break;
        case IPHONE_5S:
            break;
        default:
            break;
    }
    
    self.FullView.frame = FullViewFrame;

    UITapGestureRecognizer *CloseSubInputViewRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CloseSubInputViewAction:)];
    [self.CancelSubInputView addGestureRecognizer:CloseSubInputViewRecognizer];
    
    self.SubInputView.hidden = YES;
    
    [self.MusicTimePicker removeFromSuperview];
    self.MusicTimePicker = [[MusicTimePicker alloc] initWithFrame:self.MusicTimePicker.frame];
    [self.SubInputView addSubview:self.MusicTimePicker];
    self.MusicTimePicker.delegate = self;
    
    // TODO: fill in global plist
    self.MusicTotalVolume.maximumValue = [[GlobalConfig MusicVolumeMax] floatValue];
    self.MusicTotalVolume.minimumValue = [[GlobalConfig MusicVolumeMin] floatValue];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PlayMusicStatusChangedCallBack:)
                                                 name:kPlayMusicStatusChangedEvent
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(VoiceStopByInterrupt:)
                                                 name:kVoiceStopByInterrupt
                                               object:nil];
   
    [self ChangeControllerEventInitialize];
    
    [self InitMusicPropertyButtonStateTextColor];
    
    [self LocalizedStringInitialize];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [gPlayMusicChannel Stop];
    [self StopTwickLing];
}

- (void) LocalizedStringInitialize
{
    self.SettingsTitle.text = NSLocalizedString(@"Settings", nil);
    self.BPMFloatEnableLabel.text = NSLocalizedString(@"BPMFloatEnable", nil);
    self.ListAutoRepeatLabel.text = NSLocalizedString(@"ListRepeat", nil);
    self.EnableMusicPlayLabel.text = NSLocalizedString(@"MusicPlayerOn", nil);
    self.DisableListWarmingLabel.text = NSLocalizedString(@"DisableListWarming", nil);
    self.StartTimeWordLabel.text = NSLocalizedString(@"StartTime", nil);
    self.EndTimeWordLabel.text = NSLocalizedString(@"StopTime", nil);
    self.PlayMetronomeWithMusicLabel.text = NSLocalizedString(@"PlayWithMusic", nil);
    self.MusicAutoRepeatLabel.text = NSLocalizedString(@"MusicReapeat", nil);
    self.MusicHalfSpeedLabel.text = NSLocalizedString(@"MusicSpeedHalf", nil);
    
    if ([self.DisableListWarmingLabel.text isEqualToString:@"(關閉列表播放器)"])
    {
        CGRect WarmingFrame = self.DisableListWarmingLabel.frame;
        self.DisableListWarmingLabel.frame = CGRectMake(WarmingFrame.origin.x - 45, WarmingFrame.origin.y
                                                        , WarmingFrame.size.width + 20,  WarmingFrame.size.height);
    }
}

- (void) InitMusicPropertyButtonStateTextColor
{
    [self SetButtonStateTextColor: self.CurrentSelectedMusic];
    [self SetButtonStateTextColor: self.StartTimeLabel];
    [self SetButtonStateTextColor: self.EndTimeLabel];
}

- (void) SetButtonStateTextColor : (UIButton *) Button
{
    [Button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void) ChangeControllerEventInitialize
{
    // Change View Controller
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePageToTempoListView:)
                                                 name:kChangeToTempoListPickerView
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ChangePageBackToSystemView:)
                                                 name:kChangeBackToSystemPageView
                                               object:nil];
}

- (void) SyncCurrentListFormGlobalConfig
{
    _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:[GlobalConfig GetLastTempoListIndexUserSelected]];
    if (_CurrentList == nil)
    {
        NSLog(@"SystemPageViewController : FetchCurrentTempoListFromModel from LastTempoListIndexUserSelected Error");
        _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:@0];
        if (_CurrentList == nil)
        {
            NSLog(@"SystemPageViewController : FetchCurrentTempoListFromModel from 0 Error");
        }
        else
        {
            [GlobalConfig SetLastTempoListIndexUserSelected:0];
        }
    }
}

- (void) SyncPageInfoByCurrentTempoList
{
    if (_CurrentList == nil)
    {
        NSLog(@"SyncPageInfoByCurrentTempoList behavior Error!!!");
        [self SyncCurrentListFormGlobalConfig];
        return;
    }
    
    NSString *DisplayName = NSLocalizedString(@"TempoListName", nil);
    DisplayName = [DisplayName stringByAppendingString:_CurrentList.tempoListName];
    [self.CurrentSelectedTempoList setTitle:DisplayName forState:UIControlStateNormal];
    
    
    if (_CurrentList.musicInfo == nil)
    {
        _CurrentList.musicInfo = [gMetronomeModel CreateNewMusicInfo];
        [gMetronomeModel Save];
    }
    
    if (_CurrentList.musicInfo.persistentID != nil)
    {
        MPMediaItem *Item =  [gPlayMusicChannel GetFirstMPMediaItemFromPersistentID : _CurrentList.musicInfo.persistentID ];
        if (![gPlayMusicChannel isPlaying])
        {
            [self DoAllMusicSetupSteps: Item];
        }
        
        [self.MusicTotalVolume setValue:[_CurrentList.musicInfo.volume floatValue] animated:YES];
        gPlayMusicChannel.Volume = self.MusicTotalVolume.value;
    }
    else
    {
        [gPlayMusicChannel SetPrepareNotReady];
        [self FillSongInfo:nil];
    }
}

- (IBAction)ChooseMusic:(id)sender {

    if (self.CurrentSelectedMusic.enabled == NO)
    {
        return;
    }
    
    [self presentViewController:_MusicPicker animated:YES completion:nil];
}

- (IBAction) TapStartTime:(id)sender
{
    if (self.StartTimeLabel.enabled == NO)
    {
        return;
    }
    self.MusicTimePicker.ID = MUSIC_STAR_TIME_ID;
    self.MusicTimePicker.Value = gPlayMusicChannel.StartTime;
    self.MusicTimePicker.MusicDuration = gPlayMusicChannel.duration;
    [self ShowMusicPicker];
}

- (IBAction) TapEndTime:(id)sender
{
    if (self.EndTimeLabel.enabled == NO)
    {
        return;
    }
    self.MusicTimePicker.ID = MUSIC_END_TIME_ID;
    self.MusicTimePicker.Value = gPlayMusicChannel.StopTime;
    self.MusicTimePicker.MusicDuration = gPlayMusicChannel.duration;

    [self ShowMusicPicker];
}

- (IBAction)ResetStartAndStopTime:(id)sender
{
    _CurrentList.musicInfo.startTime = [NSNumber numberWithFloat:0.0f];
    _CurrentList.musicInfo.endTime = [NSNumber numberWithFloat:gPlayMusicChannel.duration];
    [self SyncStartAndEndTime];
    
    [gMetronomeModel Save];
}

- (void) ShowMusicPicker
{
    self.MusicTimePicker.DurationTime.text = self.DurationLabel.text;
    self.SubInputView.hidden = NO;
    self.MusicTimePicker.hidden = NO;
    [self.FullView bringSubviewToFront:self.SubInputView];
}

- (void) CloseSubInputView
{
    self.SubInputView.hidden = YES;
}

- (IBAction) CloseSubInputViewAction : (UIView *) TargetView
{
    [self CloseSubInputView];
}

- (void) FillSongInfo : (MPMediaItem *) Item
{
    if (Item != nil)
    {
        self.DurationLabel.text = [gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.duration];
        
        NSString *SongName = [Item valueForProperty:MPMediaItemPropertyTitle];
        if (SongName == nil)
        {
            // for Appending
            SongName = @"";
        }
        
        NSString *ArtistName = [Item valueForProperty:MPMediaItemPropertyArtist];
        if (ArtistName == nil)
        {
            // for Appending
            ArtistName = @"";
        }

        NSString *CurrentSelectedMusicString = NSLocalizedString(@"MusicName", nil);
        CurrentSelectedMusicString = [CurrentSelectedMusicString stringByAppendingString:SongName];
        if(!([SongName isEqualToString:@""] || [ArtistName isEqualToString:@""]))
        {
            CurrentSelectedMusicString = [CurrentSelectedMusicString stringByAppendingString:@" - "];
        }
        CurrentSelectedMusicString= [CurrentSelectedMusicString stringByAppendingString:ArtistName];
        
        [self.CurrentSelectedMusic setTitle:CurrentSelectedMusicString forState:UIControlStateNormal];
    }
    else
    {
        self.DurationLabel.text = [gPlayMusicChannel ReturnTimeValueToString:0.0f];
        [self.CurrentSelectedMusic setTitle:NSLocalizedString(@"PleaseSelectASong", nil) forState:UIControlStateNormal];
    }
}

- (void) UpdateListCellMusicInfo : (MPMediaItem *) Item
{
    if (Item != nil)
    {
        NSNumber *NewPersistentID = [Item valueForProperty:MPMediaItemPropertyPersistentID];
        
        // 如果不一樣就代表換歌了, persistentID == nil 不能做 isEqualToNumber, 會crash
        // !!! 要小心 persistentID == nil的判斷要在前面
        if (_CurrentList.musicInfo.persistentID == nil
            || ![NewPersistentID isEqualToNumber: _CurrentList.musicInfo.persistentID])
        {
            _CurrentList.musicInfo.startTime = [NSNumber numberWithFloat:0.0f];
            _CurrentList.musicInfo.endTime = [NSNumber numberWithFloat:gPlayMusicChannel.duration];
        }
        _CurrentList.musicInfo.persistentID = NewPersistentID;

    }
    else
    {
        _CurrentList.musicInfo.persistentID = nil;
        _CurrentList.musicInfo.startTime = [NSNumber numberWithFloat:0.0f];
        _CurrentList.musicInfo.endTime = [NSNumber numberWithFloat:0.0f];
    }
    [gMetronomeModel Save];
}

- (void) DoAllMusicSetupSteps : (MPMediaItem *) Item
{
    [gPlayMusicChannel PrepareMusicToplay: Item];
    
    [self FillSongInfo:Item];
    
    [self UpdateListCellMusicInfo:Item];
    
}

- (void) SyncStartAndEndTime
{
    gPlayMusicChannel.StartTime = [_CurrentList.musicInfo.startTime floatValue];
    gPlayMusicChannel.StopTime = [_CurrentList.musicInfo.endTime floatValue];
    [self.StartTimeLabel setTitle:[gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.StartTime] forState:UIControlStateNormal];
    [self.EndTimeLabel setTitle:[gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.StopTime] forState:UIControlStateNormal];
}


- (void) MusicHalfRateEnable : (BOOL) NewValue
{
    if (NewValue)
    {
        [gPlayMusicChannel SetPlayRateToHalf];
    }
    else
    {
        [gPlayMusicChannel SetPlayRateToNormal];
    }
}

- (IBAction)MusicValueChange:(UISlider *)sender
{
    [self ChangeMusicVolume: sender.value];
}

- (void) ChangeMusicVolume : (float) NewVolume
{
    gPlayMusicChannel.Volume = NewVolume;
    _CurrentList.musicInfo.volume = [NSNumber numberWithFloat: gPlayMusicChannel.Volume];
    [gMetronomeModel Save];
}
// =============================
// Metronome behavior Property switch
//
- (void) SyncMetronomePrivateProperties
{
    [self.EnableBPMDoubleMode setOn: [_CurrentList.privateProperties.doubleValueEnable boolValue]];
    [self.EnableTempoListLooping setOn:  [_CurrentList.privateProperties.tempoListLoopingEnable boolValue]];
}

- (IBAction)EnableBPMDoubleModeAction :(UISwitch *)sender {
    _CurrentList.privateProperties.doubleValueEnable = [NSNumber numberWithBool:sender.isOn];
    [gMetronomeModel Save];
}

- (IBAction)EnableTempoListLoopingAction :(UISwitch *)sender {
    _CurrentList.privateProperties.tempoListLoopingEnable = [NSNumber numberWithBool:sender.isOn];
    [gMetronomeModel Save];
}

//
// =============================

// =============================
// Music Property switch
//

- (void) SyncMusicPropertyFromGlobalConfig
{
    _MusicProperty = [GlobalConfig GetMusicProperties];
    [self.EnableMusicFunction setOn: _MusicProperty.MusicFunctionEnable];
    [self.MusicRateToHalfSwitch setOn: _MusicProperty.MusicHalfRateEnable];
    [self.PlaySingleCellWithMusicSwitch setOn: _MusicProperty.PlaySingleCellWithMusicEnable];
    [self.PlayMusicLoopingSwitch setOn: _MusicProperty.PlayMusicLoopingEnable];
    
    [self ChangeMusicFunctionUIState:_MusicProperty.MusicFunctionEnable];
}

- (void) ChangeMusicFunctionUIState : (BOOL) MusicFunctionEnable
{
    if (MusicFunctionEnable)
    {
        self.CurrentSelectedMusic.enabled = YES;
    }
    else
    {
        self.CurrentSelectedMusic.enabled = NO;
    }

    if (MusicFunctionEnable && gPlayMusicChannel.IsReadyToPlay)
    {
        self.PlayMusicLoopingSwitch.enabled = YES;
        self.PlaySingleCellWithMusicSwitch.enabled = YES;
        self.MusicRateToHalfSwitch.enabled = YES;
        self.MusicTotalVolume.enabled = YES;
        self.DurationLabel.enabled = YES;
        self.StartTimeLabel.enabled = YES;
        self.EndTimeLabel.enabled = YES;
        self.ResetTimeRepeatButton.enabled = YES;
        
        // TempoList behavior switch will change too
        self.EnableTempoListLooping.enabled = NO;
    }
    else
    {
        self.PlayMusicLoopingSwitch.enabled = NO;
        self.PlaySingleCellWithMusicSwitch.enabled = NO;
        self.MusicRateToHalfSwitch.enabled = NO;
        self.MusicTotalVolume.enabled = NO;
        self.DurationLabel.enabled = NO;
        self.StartTimeLabel.enabled = NO;
        self.EndTimeLabel.enabled = NO;
        self.ResetTimeRepeatButton.enabled = NO;

        // TempoList behavior switch will change too
        self.EnableTempoListLooping.enabled = YES;
    }
}

- (IBAction)EnableMusicFunction:(UISwitch *)sender {
    _MusicProperty.MusicFunctionEnable = sender.isOn;
    [GlobalConfig SetMusicProperties:_MusicProperty];
    [self ChangeMusicFunctionUIState:sender.isOn];
}

- (IBAction)PlayRateToHaveSwitched:(UISwitch *)sender {
    _MusicProperty.MusicHalfRateEnable = sender.isOn;
    [GlobalConfig SetMusicProperties:_MusicProperty];
    [self MusicHalfRateEnable: sender.isOn];
}

- (IBAction)PlaySingleCellWithMusicSwitched:(UISwitch *)sender {
    _MusicProperty.PlaySingleCellWithMusicEnable = sender.isOn;
    [GlobalConfig SetMusicProperties:_MusicProperty];
}

- (IBAction) PlayMusicLoopingEnableSwitched:(UISwitch *)sender {
    _MusicProperty.PlayMusicLoopingEnable = sender.isOn;
    [GlobalConfig SetMusicProperties:_MusicProperty];
    [gPlayMusicChannel SetPlayMusicLoopingEnable: _MusicProperty.PlayMusicLoopingEnable];
}

//
// ==========================

// ==========================
// delegate
//

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{

    MPMediaItem * Item = mediaItemCollection.items[0];
    
    [self DoAllMusicSetupSteps:Item];
    
    [self SyncStartAndEndTime];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// InputSubmitViewProtocol
- (IBAction) Save: (UIButton *) SaveButton
{
    if (self.MusicTimePicker.ID == MUSIC_STAR_TIME_ID)
    {
        self.MusicTimePicker.ID = NONE_ID;
        [self.StartTimeLabel setTitle:[self.MusicTimePicker ReturnCurrentValueString] forState:UIControlStateNormal];
        gPlayMusicChannel.StartTime = ROUND_FILL_DOUBLE_IN_MODEL(self.MusicTimePicker.Value);
        _CurrentList.musicInfo.startTime = [NSNumber numberWithFloat:ROUND_FILL_DOUBLE_IN_MODEL(self.MusicTimePicker.Value)];
        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }

    }
    else if (self.MusicTimePicker.ID == MUSIC_END_TIME_ID)
    {
        self.MusicTimePicker.ID = NONE_ID;
        [self.EndTimeLabel setTitle:[self.MusicTimePicker ReturnCurrentValueString] forState:UIControlStateNormal];
        gPlayMusicChannel.StopTime = ROUND_FILL_DOUBLE_IN_MODEL(self.MusicTimePicker.Value);
        _CurrentList.musicInfo.endTime = [NSNumber numberWithFloat:ROUND_FILL_DOUBLE_IN_MODEL(self.MusicTimePicker.Value)];
        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }
    }
    
    [gMetronomeModel Save];
    [self CloseSubInputView];
}

- (IBAction) Cancel : (UIButton *) CancelButton
{
    if (self.MusicTimePicker.ID == MUSIC_STAR_TIME_ID)
    {
        self.MusicTimePicker.ID = NONE_ID;

        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }
        
    }
    else if (self.MusicTimePicker.ID == MUSIC_END_TIME_ID)
    {
        self.MusicTimePicker.ID = NONE_ID;

        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }
    }
 
    [self CloseSubInputView];
}

- (IBAction) Listen : (UIButton *) ListenButton
{
    if (gPlayMusicChannel.isPlaying)
    {
        [gPlayMusicChannel Stop];
    }
    else
    {
        [gPlayMusicChannel PlayWithTempStartAndStopTime:[self.MusicTimePicker GetUIValue] :gPlayMusicChannel.duration];
    }
}

- (void) VoiceStopByInterrupt: (NSNotification *)Notification
{
    if (gPlayMusicChannel.isPlaying)
    {
        [gPlayMusicChannel Stop];
    }
}

- (void) PlayMusicStatusChangedCallBack:(NSNotification *)Notification
{
    if (gPlayMusicChannel.Playing)
    {
        [self.MusicTimePicker.ListenButton setBackgroundImage:[UIImage imageNamed:@"PlayRed"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.MusicTimePicker.ListenButton setBackgroundImage:[UIImage imageNamed:@"MusicListen"] forState:UIControlStateNormal];
    }
}


// ===============================
// Change Controller event
//
- (void) ChangePageToTempoListView:(NSNotification *)Notification
{
    [self presentViewController:[GlobalConfig TempoListController] animated:YES completion:nil];
}

- (void) ChangePageBackToSystemView:(NSNotification *)Notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) ChangeToTempoListPickerControllerView : (id) Button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToTempoListPickerView object:nil];
}

- (IBAction)ReturnToMetronome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackToMetronomeView object:nil];
}

//
// ===============================

// ===============================
//

- (void) StartTwickLing
{
    _TwickLingEnable = YES;
    [self TwickLingToRed];
}

- (void) StopTwickLing
{
    _TwickLingEnable = NO;
}


- (void) TwickLingToRed
{
    if (!_TwickLingEnable)
    {
        return;
    }

    [UIView animateWithDuration:5
                          delay:0.01
                        options: UIViewAnimationOptionCurveLinear
                                |UIViewKeyframeAnimationOptionAllowUserInteraction
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [self TwickLingToBlack];
                     }];
}

- (void) TwickLingToBlack
{
    if (!_TwickLingEnable)
    {
        return;
    }
    [UIView animateWithDuration:7
                          delay:0.01
                        options: UIViewAnimationOptionCurveLinear
                                |UIViewKeyframeAnimationOptionAllowUserInteraction
                     animations:^{
                         self.view.backgroundColor = [UIColor blackColor];
                     }
                     completion:^(BOOL finished){
                         [self TwickLingToRed];
                     }];
}

//
// ===============================

- (BOOL)shouldAutorotate {
    //打開旋轉
    return YES;
}

// 支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations {
    //垂直與倒過來
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

// 一开始的屏幕旋转方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}


- (void)didReceiveMemoryWarning
{
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
