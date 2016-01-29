//
//  TopPartOfMetronomeViewController.m
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "TopPartOfMetronomeViewController.h"

@interface TopPartOfMetronomeViewController ()
@property GlobalServices *globalServices;
@property TapFunction * tapFunction;
@property UIAlertView * tempoCellOverMaxCountAlert;

@end

@implementation TopPartOfMetronomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self playMusicStatusChangedCallBack:nil];
}

// ============================
// init
//

- (id) initWithGlobalServices: (GlobalServices *) globalServices{
    self = [super init];
    if (self) {
        self.globalServices = globalServices;
        
        // Initialization code
        [self initBPMPicker];
        self.bpmPickerViewController.delegate = self;
        [self.view addSubview:self.bpmPickerViewController.view];
        [self.view bringSubviewToFront:self.systemButton];
        
        [self initTimeSignaturePickerView];

        [self initVoiceTypePickerView];

        [self initLoopCellEditorView];

        [self initTapFunction];
        
        [self initNotifications];
    }
    return self;
}

- (void) initBPMPicker {
    self.bpmPickerViewController = [[BPMPickerViewController alloc] init];
}

- (void) initTimeSignaturePickerView
{
    [self.timeSignaturePickerView removeFromSuperview];
    self.timeSignaturePickerView = [[TimeSignaturePickerView alloc] initWithFrame:self.timeSignaturePickerView.frame];
    [self.view addSubview:self.timeSignaturePickerView];
    [self.view sendSubviewToBack:self.timeSignaturePickerView];
    self.timeSignaturePickerView.hidden = YES;
    
    // If nil, create data view
    NSArray *timeSignatureTypeArray = gMetronomeModel.TimeSignatureTypeDataTable;
    self.timeSignaturePickerView.OriginYOffset = self.optionScrollView.frame.origin.y - self.timeSignaturePickerView.frame.origin.y;
    self.timeSignaturePickerView.ArrowCenterLine = self.timeSigatureDisplayPickerButton.frame.origin.y + self.timeSigatureDisplayPickerButton.frame.size.height/2 - self.optionScrollView.contentOffset.y;
    self.timeSignaturePickerView.TriggerButton = self.timeSigatureDisplayPickerButton;
    self.timeSignaturePickerView.delegate = self;
    
    [self.timeSignaturePickerView DisplayPropertyCell:timeSignatureTypeArray: self.timeSigatureDisplayPickerButton];
}

- (void) initVoiceTypePickerView
{
    [self.voiceTypePickerView removeFromSuperview];
    self.voiceTypePickerView = [[VoiceTypePickerView alloc] initWithFrame:self.voiceTypePickerView.frame];
    [self.view addSubview:self.voiceTypePickerView];
    [self.view sendSubviewToBack:self.voiceTypePickerView];
    self.voiceTypePickerView.hidden = YES;
    
    NSArray *voiceTypeArray = gMetronomeModel.VoiceTypeDataTable;
    self.voiceTypePickerView.OriginYOffset = self.optionScrollView.frame.origin.y - self.voiceTypePickerView.frame.origin.y;
    self.voiceTypePickerView.ArrowCenterLine = self.voiceTypeDisplayPickerButton.frame.origin.y + self.voiceTypeDisplayPickerButton.frame.size.height/2 - self.optionScrollView.contentOffset.y;
    self.voiceTypePickerView.TriggerButton = self.voiceTypeDisplayPickerButton;
    self.voiceTypePickerView.delegate = self;
    
    [self.voiceTypePickerView DisplayPropertyCell:voiceTypeArray : self.voiceTypeDisplayPickerButton];
}

- (void) initLoopCellEditorView
{
    [self.loopCellEditorView removeFromSuperview];
    self.loopCellEditorView = [[LoopCellEditerView alloc] initWithFrame:self.loopCellEditorView.frame];
    [self.view addSubview:self.loopCellEditorView];
    [self.view sendSubviewToBack:self.loopCellEditorView];
    self.loopCellEditorView.hidden = YES;
    
    self.loopCellEditorView.OriginYOffset = self.optionScrollView.frame.origin.y - self.timeSignaturePickerView.frame.origin.y;
    self.loopCellEditorView.ArrowCenterLine = self.loopCellDisplayEditorButton.frame.origin.y + self.loopCellDisplayEditorButton.frame.size.height/2 - self.optionScrollView.contentOffset.y;
    self.loopCellEditorView.TriggerButton = self.loopCellDisplayEditorButton;
    self.loopCellEditorView.delegate = self;
    
    
    // ValueScrollView
    self.loopCellEditorView.ValueScrollView.MaxLimit  = [[GlobalConfig TempoCellLoopCountMax] intValue];
    self.loopCellEditorView.ValueScrollView.MinLimit  = [[GlobalConfig TempoCellLoopCountMin] intValue];
    
}

- (void) initTapFunction{
    [self.tapAnimationImage removeFromSuperview];
    self.tapAnimationImage = [[TapAnimationImage alloc] initWithFrame:self.tapAnimationImage.frame];
    [[self view] addSubview:self.tapAnimationImage];
    self.tapFunction = [[TapFunction alloc] init];
    self.tapFunction.TapAlertImage = self.tapAnimationImage;
    
    self.tapAnimationImage.hidden = YES;
}

- (void) initNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tapChangeBPMCallBack:)
                                                 name:kTapChangeBPMValue
                                               object:nil];
    // PlayCellListButton Initialize
    [self.playCellListButton addTarget:self
                                action:@selector(PlayCellListButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    // PlayCellListButton Initialize
    [self.playMusicButton addTarget:self
                             action:@selector(PlayMusicButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.addLoopCellButton addTarget:self
                               action:@selector(AddLoopCellButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playMusicStatusChangedCallBack:)
                                                 name:kPlayMusicStatusChangedEvent
                                               object:nil];
}

//
// ============================

// ============================
// IBAction
//
- (IBAction) switchMainWindowToSystemView: (id) Button
{
    [self.globalServices.notificationCenter switchMainWindowToSystemView];
}

-(IBAction) timeSigaturePickerClick:(UIView *)sender
{
    self.timeSignaturePickerView.hidden = !self.timeSignaturePickerView.hidden;
}

-(IBAction) voiceTypePickerClick:(UIView *)sender
{
    self.voiceTypePickerView.hidden = !self.voiceTypePickerView.hidden;
}

-(IBAction) loopCellEditerClick:(UIButton *)sender
{
    TempoCell * TargetCell = self.globalServices.engine.currentCell;
    
    if ([TargetCell.loopCount intValue] != ROUND_NO_DECOMAL_FROM_DOUBLE(self.loopCellEditorView.ValueScrollView.Value))
    {
        self.loopCellEditorView.ValueScrollView.Value =  ROUND_ONE_DECOMAL_FROM_DOUBLE([TargetCell.loopCount intValue]);
    }
    
    self.loopCellEditorView.hidden = !self.loopCellEditorView.hidden;
}

//
// ============================

// ============================
// private methods
//
- (void) changeVoiceType:(UIButton *)TriggerItem
{
    NSArray *voiceTypeArray = gMetronomeModel.VoiceTypeDataTable;
    
    if (voiceTypeArray.count <= TriggerItem.tag) {
        return;
    }
    
    // Because 0 is no voice
    NSInteger VoiceIndex = TriggerItem.tag;
    self.globalServices.engine.currentCell.voiceType = (VoiceType *)voiceTypeArray[TriggerItem.tag];
    
    [self.voiceTypeDisplayPickerButton setBackgroundImage:[TriggerItem backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    
    self.globalServices.engine.currentVoice = [self.globalServices.engine.clickVoiceList objectAtIndex:VoiceIndex];
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
}

- (void) changeVoiceTypePickerImage: (int) TagNumber
{
    UIButton * TriggerItem = [self.voiceTypePickerView ReturnTargetButton:TagNumber];
    if (TriggerItem != nil)
    {
        [self.voiceTypeDisplayPickerButton setBackgroundImage:[TriggerItem backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    }
}


- (void) changeTimeSignature:(UIButton *)TriggerItem
{
    NSArray *timeSignatureTypeArray = gMetronomeModel.TimeSignatureTypeDataTable;
    
    if (timeSignatureTypeArray.count <= TriggerItem.tag)
    {
        return;
    }
    
    self.globalServices.engine.currentCell.timeSignatureType = (TimeSignatureType *)timeSignatureTypeArray[TriggerItem.tag];
    self.globalServices.engine.currentTimeSignature = TriggerItem.titleLabel.text;
    
    [gMetronomeModel Save];
    
    [self.timeSigatureDisplayPickerButton setTitle:TriggerItem.titleLabel.text forState:UIControlStateNormal];
}

- (void) changeCellCounter:(id)TriggerItem
{
    if (self.loopCellEditorView.ValueScrollView == TriggerItem) {
        [self.globalServices.notificationCenter changeCellCounter: self.loopCellEditorView.ValueScrollView.Value];
    }
    else if (self.loopCellEditorView.CellDeleteButton == TriggerItem) {
        [self.globalServices.notificationCenter deleteTargetIndexCell];
    }
}
//
// =========================

// =========================
// delegate
//
- (IBAction)ChangeValue: (id)rootSuperView : (UIButton *) chooseCell;
{
    if (rootSuperView == self.voiceTypePickerView){
        [self changeVoiceType: chooseCell];
    }
    else if (rootSuperView == self.timeSignaturePickerView){
        [self changeTimeSignature: chooseCell];
    }
    else if (rootSuperView == self.loopCellEditorView){
        [self changeCellCounter: chooseCell];
    }
}

- (void) ShortPress: (id) ThisPicker
{
    [self.tapFunction TapAreaBeingTap];
}

- (void) SetBPMValue : (id) Picker
{
    if (Picker == self.bpmPickerViewController){
        // BPM Save
        self.globalServices.engine.currentCell.bpmValue = [NSNumber numberWithFloat:self.bpmPickerViewController.Value];
        
        // TODO : 不要save這麼頻繁
        [gMetronomeModel Save];
        
        [self.globalServices.notificationCenter setBPMValue];
    }
}


//
// =========================

// =========================
// notification callback
//

- (void) tapChangeBPMCallBack :(NSNotification *)notification
{
    self.bpmPickerViewController.Value = [self.tapFunction GetNewValue];
}

- (IBAction) PlayCellListButtonClick: (UIButton *)ThisClickedButton
{
    [self.globalServices.notificationCenter playCellListButtonClick];
}

- (IBAction)PlayMusicButtonClick:(UIButton *)ThisClickedButton
{
    if (gPlayMusicChannel.URL == nil){
        return;
    }
    
    if (!gPlayMusicChannel.Playing){
        [gPlayMusicChannel Play];
    }else{
        [gPlayMusicChannel Stop];
    }
    
    [self playMusicStatusChangedCallBack:nil];
}

- (void) playMusicStatusChangedCallBack:(NSNotification *)Notification
{
    if (gPlayMusicChannel.Playing){
        [self.playMusicButton setBackgroundImage:[UIImage imageNamed:@"PlayMusic_Red"] forState:UIControlStateNormal];
    }else{
        [self.playMusicButton setBackgroundImage:[UIImage imageNamed:@"PlayMusic"] forState:UIControlStateNormal];
    }
}

- (IBAction) AddLoopCellButtonClick: (UIButton *) ThisClickedButton
{
    if (self.globalServices.engine.tempoCells.count >= [[GlobalConfig TempoCellNumberMax] integerValue]){
        // 超過了
        if (self.tempoCellOverMaxCountAlert ==nil){
            self.tempoCellOverMaxCountAlert = [[UIAlertView alloc]
                                           initWithTitle:LocalStringSync(@"Too many tempo items", nil)
                                           message:LocalStringSync(@"You can't add more than 20 tempo items in one tempo list !!", nil)
                                           delegate:nil
                                           cancelButtonTitle:LocalStringSync(@"OK, I know it.", nil)
                                           otherButtonTitles:nil, nil];
        }
        [self.tempoCellOverMaxCountAlert show];
        return;
    }
    
    [self.globalServices.notificationCenter addLoopCellButtonClick];
}
//
// =========================
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
