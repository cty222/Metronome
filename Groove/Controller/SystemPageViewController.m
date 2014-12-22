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
    
    _CurrentList = [gMetronomeModel FetchCurrentTempoListFromModel:[GlobalConfig GetLastTempoListIndex]];
    if (_CurrentList == nil)
    {
        NSLog(@"SystemPageViewController : FetchCurrentTempoListFromModel from LastTempoListIndex Error");
        _CurrentList = [gMetronomeModel FetchCurrentTempoListFromModel:@0];
        if (_CurrentList == nil)
        {
            NSLog(@"SystemPageViewController : FetchCurrentTempoListFromModel from 0 Error");
        }
    }
    
    self.CurrentSelectedList.text = _CurrentList.tempoListName;
    
    
    // ===================
    // Setup music by model music info

    if (gPlayMusicChannel == nil)
    {
        gPlayMusicChannel = [PlayerForSongs alloc];
    }
    
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
    }
    // ===================
    // UI state Sync
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PlayMusicStatusChangedCallBack:)
                                                 name:kPlayMusicStatusChangedEvent
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [gPlayMusicChannel Stop];
}

- (IBAction)ReturnToMetronome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToMetronomeView object:nil];
}

- (IBAction)ChooseMusic:(id)sender {

    if (self.CurrentSelectedMusic.enabled == NO)
    {
        return;
    }
    
    [self presentViewController:_MusicPicker animated:YES completion:nil];
}

- (IBAction)TapStartTime:(id)sender
{
    if (self.StartTimeLabel.enabled == NO)
    {
        return;
    }
    self.MusicTimePicker.ID = MUSIC_STAR_TIME_ID;
    self.MusicTimePicker.TimeScrollBar.maximumValue = gPlayMusicChannel.duration;
    self.MusicTimePicker.TimeScrollBar.minimumValue = 0.0f;
    self.MusicTimePicker.Value = gPlayMusicChannel.StartTime;
    [self ShowMusicPicker];
}

- (IBAction)TapEndTime:(id)sender
{
    if (self.EndTimeLabel.enabled == NO)
    {
        return;
    }
    self.MusicTimePicker.ID = MUSIC_END_TIME_ID;
    self.MusicTimePicker.TimeScrollBar.maximumValue = gPlayMusicChannel.duration;
    self.MusicTimePicker.TimeScrollBar.minimumValue = 0.0f;
    self.MusicTimePicker.Value = gPlayMusicChannel.StopTime;
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
        self.CurrentSelectedMusic.text = [Item valueForProperty:MPMediaItemPropertyArtist];
        self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:@" - "];
        self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:[Item valueForProperty:MPMediaItemPropertyTitle]];
    }
    else
    {
        self.DurationLabel.text = [gPlayMusicChannel ReturnTimeValueToString:0.0f];
        self.CurrentSelectedMusic.text = @"";
    }
}

- (void) UpdateListCellPersistentID : (MPMediaItem *) Item
{
    if (Item != nil)
    {
        _CurrentList.musicInfo.persistentID = [Item valueForProperty:MPMediaItemPropertyPersistentID];
    }
    else
    {
        _CurrentList.musicInfo.persistentID = nil;
    }
    [gMetronomeModel Save];
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

- (void) DoAllMusicSetupSteps : (MPMediaItem *) Item
{
    [self UpdateListCellPersistentID:Item];
    
    [gPlayMusicChannel PrepareMusicToplay: Item];
    
    [self FillSongInfo:Item];
}

- (IBAction)MusicValueChange:(UISlider *)sender
{
    gPlayMusicChannel.Volume = sender.value;
}


// =============================
// Music Property switch
//

- (void) SyncMusicPropertyFromGlobalConfig
{
    _MusicProperty = [GlobalConfig GetMusicProperties];
    [self.EnableMusicFunction setOn: _MusicProperty.MusicFunctionEnable];
    [self.MusicRateToHalfSwitch setOn: _MusicProperty.MusicHalfRateEnable];
    [self.PlaySingleCellWithMusicSwitch setOn: _MusicProperty.PlaySingleCellWithMusicEnable];
    [self.ShowMusicButtonInMainViewSwitch setOn: _MusicProperty.ShowMusicButtonInMainViewEnable];
    
    [self ChangeMusicFunctionUIState:_MusicProperty.MusicFunctionEnable];
}

- (void) ChangeMusicFunctionUIState : (BOOL) MusicFunctionEnable
{
    if (MusicFunctionEnable)
    {
        self.ShowMusicButtonInMainViewSwitch.enabled = YES;
        self.PlayListWithMusicSwitch.enabled = YES;
        self.PlaySingleCellWithMusicSwitch.enabled = YES;
        self.MusicRateToHalfSwitch.enabled = YES;
        self.MusicTotalVolume.enabled = YES;
        self.CurrentSelectedMusic.enabled = YES;
        self.DurationLabel.enabled = YES;
        self.StartTimeLabel.enabled = YES;
        self.EndTimeLabel.enabled = YES;
        
    }
    else
    {
        self.ShowMusicButtonInMainViewSwitch.enabled = NO;
        self.PlayListWithMusicSwitch.enabled = NO;
        self.PlaySingleCellWithMusicSwitch.enabled = NO;
        self.MusicRateToHalfSwitch.enabled = NO;
        self.MusicTotalVolume.enabled = NO;
        self.CurrentSelectedMusic.enabled = NO;
        self.DurationLabel.enabled = NO;
        self.StartTimeLabel.enabled = NO;
        self.EndTimeLabel.enabled = NO;
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

- (IBAction) ShowPlayMusicButtonSwitched:(UISwitch *)sender {
    _MusicProperty.ShowMusicButtonInMainViewEnable = sender.isOn;
    [GlobalConfig SetMusicProperties:_MusicProperty];
    if (sender.isOn)
    {
    }
    else
    {
    }
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
        self.StartTimeLabel.text = [self.MusicTimePicker ReturnCurrentValueString];
        gPlayMusicChannel.StartTime = self.MusicTimePicker.Value;
        _CurrentList.musicInfo.startTime = [NSNumber numberWithFloat:self.MusicTimePicker.Value];
        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }

    }
    else if (self.MusicTimePicker.ID == MUSIC_END_TIME_ID)
    {
        self.EndTimeLabel.text = [self.MusicTimePicker ReturnCurrentValueString];
        gPlayMusicChannel.StopTime = self.MusicTimePicker.Value;
        _CurrentList.musicInfo.endTime = [NSNumber numberWithFloat:self.MusicTimePicker.Value];
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
        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }
        
    }
    else if (self.MusicTimePicker.ID == MUSIC_END_TIME_ID)
    {
        if (gPlayMusicChannel.isPlaying)
        {
            [gPlayMusicChannel Stop];
        }
    }
    
    [self CloseSubInputView];
}

- (IBAction) Liston : (UIButton *) ListonButton
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
        [self.MusicTimePicker.ListonButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [self.MusicTimePicker.ListonButton setTitle:@"Liston" forState:UIControlStateNormal];
    }
}

//
// ==========================


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
