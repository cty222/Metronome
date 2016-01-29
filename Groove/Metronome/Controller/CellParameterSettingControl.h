//
//  CellParameterSettingControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeMainViewController.h"
#import "VolumeSetsControl.h"

typedef enum{
    VOICE_TYPE_BUTTON = 201,
} PARAMETER_BUTTON_TAG;

@interface CellParameterSettingControl : NSObject

@property UIViewController *ParrentController;

// Tmp volumeset
@property VolumeSetsControl * VolumeSetsControl;


- (void) MainViewWillAppear;
- (void) initlizeCellParameterControlItems;

@end
