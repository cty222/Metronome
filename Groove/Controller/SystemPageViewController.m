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
    NSNumber *LastSelecedtListIndex = [GlobalConfig LastSelecedtListIndex];
    TempoList * CurrentList = gMetronomeModel.TempoListDataTable[[LastSelecedtListIndex intValue]];
    self.CurrentSelectedList.text = CurrentList.tempoListName;
    
    if (MusicPicker == nil)
    {
        MusicPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        MusicPicker.delegate = self;
        MusicPicker.allowsPickingMultipleItems = NO;
        MusicPicker.showsCloudItems = NO;
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
    
    myPlayer.delegate = self;
    
}
- (IBAction)ReturnToMetronome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToMetronomeView object:nil];
}

- (IBAction)ChooseMusic:(id)sender {

    [self presentViewController:MusicPicker animated:YES completion:nil];
}

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    MPMediaItem * Item = mediaItemCollection.items[0];
    if (Item != nil)
    {
        
        self.CurrentSelectedMusic.text = [Item valueForProperty:MPMediaItemPropertyArtist];
        self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:@" - "];
        self.CurrentSelectedMusic.text = [self.CurrentSelectedMusic.text stringByAppendingString:[Item valueForProperty:MPMediaItemPropertyTitle]];
    }
    else
    {
        self.CurrentSelectedMusic.text = @"";
    }
    
    NSURL *url = [Item valueForProperty:MPMediaItemPropertyAssetURL];
    

    myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    self.CurrentSelectedMusic.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MusicValueChange:(UISlider *)sender {

    [myPlayer setVolume:sender.value];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayMusicStatusChangedEvent object:nil];
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
