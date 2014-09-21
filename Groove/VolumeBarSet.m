//
//  VolumeBarSet.m
//  Groove
//
//  Created by C-ty on 2014/9/11.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "VolumeBarSet.h"

@implementation VolumeBarSet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        for (int Index =0; Index < 5; Index++)
        {
            CGRect TmpVerticalSliderRect = CGRectMake(50 * Index, 0, 40, 140);
            TmpVerticalSlider *TmpSlider = [[TmpVerticalSlider alloc] initWithFrame:TmpVerticalSliderRect];
            TmpSlider.SliderTag = Index;
            [self addSubview:TmpSlider];
            
            switch (Index) {
                case ACCENT_SLIDER:
                    self.SliderAccent = TmpSlider;
                    break;
                case FOUR_NOTE_SLIDER:
                    self.Slider4Note = TmpSlider;
                    break;
                case EIGHT_NOTE_SLIDER:
                    self.Slider8Note = TmpSlider;
                    break;
                case SIXTEEN_NOTE_SLIDER:
                    self.Slider16Note = TmpSlider;
                    break;
                case TRIPPLE_NOTE_SLIDER:
                    self.SliderTrippleNote = TmpSlider;
                    break;
                default:
                    break;
            }
        }
        self.backgroundColor = [UIColor blackColor];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
