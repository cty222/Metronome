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
    MetronomeBehaviorProperties * _MetronomeBehaviorProperties;
    
    NSArray * _TempoListDataTable;
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
    [self SyncMetronomePropertiesFromGlobalConfig];
    [self SyncPageInfoByCurrentTempoList];
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
    
    self.CurrentSelectedList.userInteractionEnabled = YES;
    self.CurrentSelectedMusic.userInteractionEnabled = YES;

    UITapGestureRecognizer *TabSelectedMusic =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChooseMusic:)];
    [self.CurrentSelectedMusic addGestureRecognizer:TabSelectedMusic];
    
    
    UITapGestureRecognizer *TapStartTimeRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapStartTime:)];
    [self.StartTimeLabel addGestureRecognizer:TapStartTimeRecognizer];
    
    UITapGestureRecognizer *TapEndTimeRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapEndTime:)];
    [self.EndTimeLabel addGestureRecognizer:TapEndTimeRecognizer];
    
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

    UITapGestureRecognizer *TapSelectTempoListRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChangeToTempoListPickerControllerView:)];
    [self.CurrentSelectedList addGestureRecognizer:TapSelectTempoListRecognizer];
    
    [self ChangeControllerEventInitialize];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [gPlayMusicChannel Stop];
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

- (void) SyncPageInfoByCurrentTempoList
{
    _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:[GlobalConfig GetLastTempoListIndexUserSelected]];
    if (_CurrentList == nil)
    {
        NSLog(@"SystemPageViewController : FetchCurrentTempoListFromModel from LastTempoListIndexUserSelected Error");
        _CurrentList = [gMetronomeModel PickTargetTempoListFromDataTable:[GlobalConfig GetLastTempoListIndexUserSelected]];
        if (_CurrentList == nil)
        {
            NSLog(@"SystemPageViewController : FetchCurrentTempoListFromModel from 0 Error");
        }
    }
    
    self.CurrentSelectedList.text = _CurrentList.tempoListName;
    
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
        
        // TODO: 如果有其他的值
        [self.MusicTotalVolume setValue:[_CurrentList.musicInfo.volume floatValue] animated:YES];
        gPlayMusicChannel.Volume = self.MusicTotalVolume.value;
    }
    else
    {
        // TODO: 如果沒有歌曲
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

- (void) ShowMusicPicker
{
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

        self.CurrentSelectedMusic.text = SongName;
        if(!([SongName isEqualToString:@""] || [ArtistName isEqualToString:@""]))
        {
            self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:@" - "];
        }
        self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:ArtistName];
    }
    else
    {
        self.DurationLabel.text = [gPlayMusicChannel ReturnTimeValueToString:0.0f];
        self.CurrentSelectedMusic.text = @"Please select a song";
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
    
    self.StartTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.StartTime];
    self.EndTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.StopTime];
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
- (void) SyncMetronomePropertiesFromGlobalConfig
{
    _MetronomeBehaviorProperties = [GlobalConfig GetMetronomeBehaviorProperties];
    [self.EnableBPMDoubleMode setOn: _MetronomeBehaviorProperties.BPMDoubleEnable];
    [self.EnableTempoListLooping setOn: _MetronomeBehaviorProperties.TempoListLoopingEnable];
}

- (IBAction)EnableBPMDoubleModeAction :(UISwitch *)sender {
    _MetronomeBehaviorProperties.BPMDoubleEnable = sender.isOn;
    [GlobalConfig SetMetronomeBehaviorProperties:_MetronomeBehaviorProperties];
}

- (IBAction)EnableTempoListLoopingAction :(UISwitch *)sender {
    _MetronomeBehaviorProperties.TempoListLoopingEnable = sender.isOn;
    [GlobalConfig SetMetronomeBehaviorProperties:_MetronomeBehaviorProperties];
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
        
        // TempoList will change too
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
        
        // TempoList will change too
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
    if (sender.isOn)
    {
        
    }
    else
    {
        
    }
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
        self.StartTimeLabel.text = [self.MusicTimePicker ReturnCurrentValueString];
        gPlayMusicChannel.StartTime = self.MusicTimePicker.Value;
        _CurrentList.musicInfo.startTime = [NSNumber numberWithFloat:ROUND_FILL_DOUBLE_IN_MODEL(self.MusicTimePicker.Value)];
        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }

    }
    else if (self.MusicTimePicker.ID == MUSIC_END_TIME_ID)
    {
        self.MusicTimePicker.ID = NONE_ID;
        self.EndTimeLabel.text = [self.MusicTimePicker ReturnCurrentValueString];
        gPlayMusicChannel.StopTime = self.MusicTimePicker.Value;
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


- (void) PlayMusicStatusChangedCallBack:(NSNotification *)Notification
{
    if (gPlayMusicChannel.Playing)
    {
        [self.MusicTimePicker.ListenButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [self.MusicTimePicker.ListenButton setTitle:@"Listen" forState:UIControlStateNormal];
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
