//
//  VolumeBarSet.h
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"
#import "TmpVerticalSlider.h"

typedef enum {
    ACCENT_SLIDER,
    FOUR_NOTE_SLIDER,
    EIGHT_NOTE_SLIDER,
    SIXTEEN_NOTE_SLIDER,
    TRIPPLE_NOTE_SLIDER
} SLIDER_TAG;

@interface VolumeBarSet : XibViewInterface
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderAccent;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *Slider4Note;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *Slider8Note;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *Slider16Note;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderTrippleNote;

@end
