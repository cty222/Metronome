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
    MPMediaPickerController *MusicPicker;
    TempoList *_CurrentList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _CurrentList = [GlobalConfig GetCurrentListCell];
    
    self.CurrentSelectedList.text = _CurrentList.tempoListName;
    
    if (MusicPicker == nil)
    {
        MusicPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        MusicPicker.allowsPickingMultipleItems = NO;
        MusicPicker.showsCloudItems = NO;
    }
    
    if (_CurrentList.musicInfo == nil)
    {
        _CurrentList.musicInfo = [gMetronomeModel CreateNewMusicInfo];
        [gMetronomeModel Save];
    }

    if (_CurrentList.musicInfo.persistentID != nil)
    {
        MPMediaItem *Item =  [self GetFirstMPMediaItemFromPersistentID : _CurrentList.musicInfo.persistentID ];
        [self DoAllMusicSetupSteps: Item];
        [self SyncStartAndEndTime];

    }

    self.SubInputView.hidden = YES;
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
}

- (IBAction)ReturnToMetronome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToMetronomeView object:nil];
}

- (IBAction)ChooseMusic:(id)sender {

    [self presentViewController:MusicPicker animated:YES completion:nil];
}

- (IBAction)TapStartTime:(id)sender
{
    self.MusicTimePicker.ID = MUSIC_STAR_TIME_ID;
    self.MusicTimePicker.Value = gPlayMusicChannel.StartTime;
    [self ShowMusicPicker];
}

- (IBAction)TapEndTime:(id)sender
{
    self.MusicTimePicker.ID = MUSIC_END_TIME_ID;
    self.MusicTimePicker.Value = gPlayMusicChannel.EndTime;
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

- (MPMediaItem *) GetFirstMPMediaItemFromPersistentID : (NSNumber *)PersistentID
{
    MPMediaPropertyPredicate * Predicate = [MPMediaPropertyPredicate predicateWithValue:PersistentID forProperty:MPMediaItemPropertyPersistentID];
    
    MPMediaQuery *songQuery = [[MPMediaQuery alloc] init];
    [songQuery addFilterPredicate: Predicate];
    if (songQuery.items.count > 0)
    {
        //song exists
        return [songQuery.items objectAtIndex:0];
    }
    return nil;
}

- (void) FillSongInfo : (MPMediaItem *) Item
{
    if (Item == nil) {
        self.CurrentSelectedMusic.text = @"";
        return;
    }
    
    self.CurrentSelectedMusic.text = [Item valueForProperty:MPMediaItemPropertyArtist];
    self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:@" - "];
    self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:[Item valueForProperty:MPMediaItemPropertyTitle]];
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

- (void) PrepareMusicToplay : (MPMediaItem *) Item
{
    NSURL *url = [Item valueForProperty:MPMediaItemPropertyAssetURL];
    
    if (gPlayMusicChannel != nil)
    {
        [gPlayMusicChannel Stop];
    }
    else
    {
        gPlayMusicChannel = [PlayerForSongs alloc];
        gPlayMusicChannel.delegate = self;
    }
    
    [gPlayMusicChannel initWithContentsOfURL:url Info:nil];
}

- (void) SyncStartAndEndTime
{
    NSLog(@"%@", _CurrentList.musicInfo);
   
    gPlayMusicChannel.StartTime = [_CurrentList.musicInfo.startTime floatValue];
    gPlayMusicChannel.EndTime = [_CurrentList.musicInfo.endTime floatValue];
    
    self.StartTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.StartTime];
    self.EndTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.EndTime];

    
}

- (void) DoAllMusicSetupSteps : (MPMediaItem *) Item
{
    [self FillSongInfo:Item];
    [self UpdateListCellPersistentID:Item];
    if (Item == Nil)
    {
        return;
    }
    
    [self PrepareMusicToplay: Item];
}

- (IBAction)MusicValueChange:(UISlider *)sender
{

    gPlayMusicChannel.Volume = sender.value;
}


- (IBAction)PlayRateToHave:(UISwitch *)sender {
    if (sender.isOn)
    {
        [gPlayMusicChannel SetPlayRateToHalf];
    }
    else
    {
        [gPlayMusicChannel SetPlayRateToNormal];
    }
}

- (IBAction)PlaySingleCellWithMusic:(UISwitch *)sender {
    if (sender.isOn)
    {
        
    }
    else
    {
        
    }
}

- (IBAction)PlayCellListWithMusic:(UISwitch *)sender {
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
    
    [self DoAllMusicSetupSteps: Item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    self.CurrentSelectedMusic.text = @"";
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

    }
    else if (self.MusicTimePicker.ID == MUSIC_END_TIME_ID)
    {
        
        self.EndTimeLabel.text = [self.MusicTimePicker ReturnCurrentValueString];
        gPlayMusicChannel.EndTime = self.MusicTimePicker.Value;
        _CurrentList.musicInfo.endTime = [NSNumber numberWithFloat:self.MusicTimePicker.Value];
    }
    
    [gMetronomeModel Save];
    [self CloseSubInputView];
}

- (IBAction) Cancel : (UIButton *) CancelButton
{
    NSLog(@"Cancel");
    [self CloseSubInputView];
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
