//
//  CellParameterSettingControl.m
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "CellParameterSettingControl.h"

// Private property
@interface CellParameterSettingControl ()

@end

@implementation CellParameterSettingControl
{
 
}

- (void) MainViewWillAppear
{
    [self.VolumeSetsControl ResetVolumeSets];
}

- (void) initNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twicklingCircleButton:)
                                                 name:kCircleButtonTwickLing
                                               object:nil];
}

- (void)twicklingCircleButton:(NSNotification *)notification {
    __CIRCLE_BUTTON btnTag = [((NSNumber *)notification.object) intValue];
    switch (btnTag) {
        case AccentCircle_Button:
            [self.VolumeSetsControl.AccentCircleVolumeButton TwickLing];
            break;
        case QuarterCircle_Button:
            [self.VolumeSetsControl.QuarterCircleVolumeButton TwickLing];
            break;
        case EighthNoteCircle_Button:
            [self.VolumeSetsControl.EighthNoteCircleVolumeButton TwickLing];
            break;
        case SixteenthNoteCircle_Button:
            [self.VolumeSetsControl.SixteenthNoteCircleVolumeButton TwickLing];
            break;
        case TrippleNoteCircle_Button:
            [self.VolumeSetsControl.TrippleNoteCircleVolumeButton TwickLing];
            break;
    }
}

- (void) initlizeCellParameterControlItems
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;

    // Init Volumesets
    self.VolumeSetsControl = [[VolumeSetsControl alloc] init: Parent];
    
    [self initNotifications];
    
}



@end
