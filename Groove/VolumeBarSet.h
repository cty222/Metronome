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

@protocol VolumeBarSetProtocol <NSObject>
@required

@optional

- (IBAction)VolumeSliderValueChanged:(TmpVerticalSlider*) ThisVerticalSlider;
@end

@interface VolumeBarSet : XibViewInterface
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderAccent;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderQuarterNote;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderEighthNote;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderSixteenNote;
@property (strong, nonatomic) IBOutlet TmpVerticalSlider *SliderTrippleNote;

@property (getter=GetMaxValue, setter=SetMaxValue:)float MaxValue;
@property (getter=GetMinValue, setter=SetMinValue:)float MinValue;

@property (nonatomic, assign) id<VolumeBarSetProtocol> delegate;

@end
