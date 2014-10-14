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
            [TmpSlider addTarget:self action:@selector(VolumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:TmpSlider];
            
            switch (Index) {
                case ACCENT_SLIDER:
                    self.SliderAccent = TmpSlider;
                    break;
                case FOUR_NOTE_SLIDER:
                    self.SliderQuarterNote = TmpSlider;
                    break;
                case EIGHT_NOTE_SLIDER:
                    self.SliderEighthNote = TmpSlider;
                    break;
                case SIXTEEN_NOTE_SLIDER:
                    self.SliderSixteenNote = TmpSlider;
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

// ==================================
// property
//
- (float) GetMaxValue
{
    return self.SliderAccent.maximumValue;
}
-(void) SetMaxValue:(float) NewValue
{
    self.SliderAccent.maximumValue = NewValue;
    self.SliderQuarterNote.maximumValue = NewValue;
    self.SliderEighthNote.maximumValue = NewValue;
    self.SliderSixteenNote.maximumValue = NewValue;
    self.SliderTrippleNote.maximumValue = NewValue;
}

- (float) GetMinValue
{
    return self.SliderAccent.minimumValue;
}

-(void) SetMinValue:(float) NewValue
{
    self.SliderAccent.minimumValue = NewValue;
    self.SliderQuarterNote.minimumValue = NewValue;
    self.SliderEighthNote.minimumValue = NewValue;
    self.SliderSixteenNote.minimumValue = NewValue;
    self.SliderTrippleNote.minimumValue = NewValue;

}

- (IBAction)VolumeSliderValueChanged:(TmpVerticalSlider*) ThisVerticalSlider
{
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(VolumeSliderValueChanged:)])
        {
            [self.delegate VolumeSliderValueChanged: ThisVerticalSlider];
        }
    }
}

//
// ==================================

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
