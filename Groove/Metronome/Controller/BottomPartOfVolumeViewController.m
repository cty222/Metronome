//
//  BottomPartOfVolumeViewController.m
//  RockClick
//
//  Created by C-ty on 2016-01-30.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "BottomPartOfVolumeViewController.h"

@interface BottomPartOfVolumeViewController ()
@property GlobalServices* globalServices;

@end

@implementation BottomPartOfVolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self resetVolumeSets];
}

- (id) initWithGlobalServices: (GlobalServices *) globalServices
{
    self = [super init];
    if (self) {
        self.globalServices = globalServices;
        // Initialization code
        
        [self.grooveCellsSelector removeFromSuperview];
        self.grooveCellsSelector = [[MetronomeSelectBar alloc] initWithFrame:self.grooveCellsSelector.frame];
        [self.view addSubview:self.grooveCellsSelector];
        self.grooveCellsSelector.delegate = self;
        
        [self.accentCircleVolumeButton removeFromSuperview];
        self.accentCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.accentCircleVolumeButton.frame];
        self.accentCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"AccentNoteGary"];
        self.accentCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"AccentNoteRed"];
        [self.view addSubview:self.accentCircleVolumeButton];
        
        [self.quarterCircleVolumeButton removeFromSuperview];
        self.quarterCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.quarterCircleVolumeButton.frame];
        self.quarterCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"QuarterNoteGary"];
        self.quarterCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"QuarterNoteRed"];
        [self.view addSubview:self.quarterCircleVolumeButton];
        
        [self.eighthNoteCircleVolumeButton removeFromSuperview];
        self.eighthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.eighthNoteCircleVolumeButton.frame];
        self.eighthNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"8NoteGary"];
        self.eighthNoteCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"8NoteRed"];
        [self.view addSubview:self.eighthNoteCircleVolumeButton];
        
        [self.sixteenthNoteCircleVolumeButton removeFromSuperview];
        self.sixteenthNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.sixteenthNoteCircleVolumeButton.frame];
        self.sixteenthNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"16NoteGary"];
        self.sixteenthNoteCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"16NoteRed"];
        [self.view addSubview:self.sixteenthNoteCircleVolumeButton];
        
        [self.trippleNoteCircleVolumeButton removeFromSuperview];
        self.trippleNoteCircleVolumeButton = [[CircleButton alloc] initWithFrame:self.trippleNoteCircleVolumeButton.frame];
        self.trippleNoteCircleVolumeButton.SignPicture.image = [UIImage imageNamed:@"TrippleNoteGary"];
        self.trippleNoteCircleVolumeButton.TwickPicture.image = [UIImage imageNamed:@"TrippleNoteRed"];
        [self.view addSubview:self.trippleNoteCircleVolumeButton];
        
        [self initializeVolumeSets];
        
        [self initNotifications];
        
        [self.view bringSubviewToFront:self.grooveCellsSelector];
    }
    return self;
}

-(void) initializeVolumeSets
{
    self.accentCircleVolumeButton.delegate = self;
    self.quarterCircleVolumeButton.delegate = self;
    self.eighthNoteCircleVolumeButton.delegate = self;
    self.sixteenthNoteCircleVolumeButton.delegate = self;
    self.trippleNoteCircleVolumeButton.delegate = self;
    
    CIRCLEBUTTON_RANGE VolumeRange;
    VolumeRange.MaxIndex = 10.0;
    VolumeRange.MinIndex = 0;
    VolumeRange.UnitValue = 0.1;
    
    self.accentCircleVolumeButton.IndexRange = VolumeRange;
    self.accentCircleVolumeButton.IndexValueSensitivity = 1;
    self.accentCircleVolumeButton.tag = AccentCircle_Button;
    
    self.quarterCircleVolumeButton.IndexRange = VolumeRange;
    self.quarterCircleVolumeButton.IndexValueSensitivity = 1;
    self.quarterCircleVolumeButton.tag = QuarterCircle_Button;
    
    self.eighthNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.eighthNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.eighthNoteCircleVolumeButton.tag = EighthNoteCircle_Button;
    
    self.sixteenthNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.sixteenthNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.sixteenthNoteCircleVolumeButton.tag = SixteenthNoteCircle_Button;
    
    self.trippleNoteCircleVolumeButton.IndexRange = VolumeRange;
    self.trippleNoteCircleVolumeButton.IndexValueSensitivity = 1;
    self.trippleNoteCircleVolumeButton.tag = TrippleNoteCircle_Button;
}

- (void) initNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twicklingCircleButton:)
                                                 name:kCircleButtonTwickLing
                                               object:nil];
}
// ==========================
// public methods
//
- (void) setVolumeBarVolume : (TempoCell *)cell
{
    NSLog(@"setVolumeBarVolume %@", cell);
    self.accentCircleVolumeButton.IndexValue = [cell.accentVolume floatValue];
    self.quarterCircleVolumeButton.IndexValue = [cell.quarterNoteVolume floatValue];
    self.eighthNoteCircleVolumeButton.IndexValue = [cell.eighthNoteVolume floatValue];
    self.sixteenthNoteCircleVolumeButton.IndexValue = [cell.sixteenNoteVolume floatValue];
    self.trippleNoteCircleVolumeButton.IndexValue = [cell.trippleNoteVolume floatValue];
}

//
// ==========================

// ==========================
// private methods
//

- (void) resetVolumeSets
{
    [self.accentCircleVolumeButton ResetHandle];
    [self.quarterCircleVolumeButton ResetHandle];
    [self.eighthNoteCircleVolumeButton ResetHandle];
    [self.sixteenthNoteCircleVolumeButton ResetHandle];
    [self.trippleNoteCircleVolumeButton ResetHandle];
}

//
// ==========================

// ==========================
// notification callback
//
- (void)twicklingCircleButton:(NSNotification *)notification {
    __CIRCLE_BUTTON btnTag = [((NSNumber *)notification.object) intValue];
    switch (btnTag) {
        case AccentCircle_Button:
            [self.accentCircleVolumeButton TwickLing];
            break;
        case QuarterCircle_Button:
            [self.quarterCircleVolumeButton TwickLing];
            break;
        case EighthNoteCircle_Button:
            [self.eighthNoteCircleVolumeButton TwickLing];
            break;
        case SixteenthNoteCircle_Button:
            [self.sixteenthNoteCircleVolumeButton TwickLing];
            break;
        case TrippleNoteCircle_Button:
            [self.trippleNoteCircleVolumeButton TwickLing];
            break;
    }
}
//
// ==========================


// ==========================
// action
//
- (IBAction) PlayCurrentCellButtonClick: (UIButton *) ThisClickedButton
{
    [self.globalServices.notificationCenter playCurrentCellButtonClick];
}

//
// ==========================

// =========================
// delegate
//
- (void) setFocusIndex:(int) newValue
{
    NSLog(@"??");
    [self.globalServices.notificationCenter changeCurrentCell: newValue];
}

- (IBAction) circleButtonValueChanged:(CircleButton*) thisCircleButton;
{
    NSLog(@"circleButtonValueChanged");
    float Value = thisCircleButton.IndexValue;
    switch (thisCircleButton.tag) {
        case AccentCircle_Button:
            self.globalServices.engine.currentCell.accentVolume = [NSNumber numberWithFloat:Value];
            break;
        case QuarterCircle_Button:
            self.globalServices.engine.currentCell.quarterNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case EighthNoteCircle_Button:
            self.globalServices.engine.currentCell.eighthNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case SixteenthNoteCircle_Button:
            self.globalServices.engine.currentCell.sixteenNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        case TrippleNoteCircle_Button:
            self.globalServices.engine.currentCell.trippleNoteVolume = [NSNumber numberWithFloat:Value];
            break;
        default:
            break;
    }
    
    // TODO : 不要save這麼頻繁
    [gMetronomeModel Save];
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
