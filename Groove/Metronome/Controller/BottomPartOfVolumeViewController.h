//
//  BottomPartOfVolumeViewController.h
//  RockClick
//
//  Created by C-ty on 2016-01-30.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetronomeSelectBar.h"
#import "GlobalConfig.h"
#import "CircleButton.h"
#import "UINSOperation.h"
#import "GlobalServices.h"

@interface BottomPartOfVolumeViewController : UIViewController <SelectBarProtocol, CircleButtonProtocol>
@property (strong, nonatomic) IBOutlet MetronomeSelectBar *grooveCellsSelector;

// Volume button
@property (strong, nonatomic) IBOutlet CircleButton *accentCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *quarterCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *eighthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *sixteenthNoteCircleVolumeButton;
@property (strong, nonatomic) IBOutlet CircleButton *trippleNoteCircleVolumeButton;

// loop button
@property (strong, nonatomic) IBOutlet UIButton *playCurrentCellButton;

- (id) initWithGlobalServices: (GlobalServices *) globalServices;
- (void) resetVolumeSets;
- (void) setVolumeBarVolume : (TempoCell *)cell;

@end
