//
//  CellParameterSettingControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ACCENT_VOLUME_BUTTON = 101,
    QUARTER_VOLUME_BUTTON,
    EIGHTH_NOTE_VOLUME_BUTTON,
    SIXTEENTH_NOTE_VOLUME_BUTTON,
    TRIPPLET_NOTE_VOLUME_BUTTON
} VOLUME_BUTTON_TAG;

typedef enum{
    VOICE_TYPE_BUTTON = 201,
} PARAMETER_BUTTON_TAG;

@interface CellParameterSettingControl : NSObject

@end
