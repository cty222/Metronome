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
        MusicPicker.delegate = self;
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
    }
    
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
}

- (IBAction)ReturnToMetronome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToMetronomeView object:nil];
}

- (IBAction)ChooseMusic:(id)sender {

    [self presentViewController:MusicPicker animated:YES completion:nil];
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicStatusChangedEvent object:nil];
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
