//
//  MetronmoneTopSubViewIphone.m
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronmoneTopSubViewIphone.h"

@implementation MetronmoneTopSubViewIphone
{
    
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    NSNumber * DeviceType = [GlobalConfig DeviceType];
    switch (DeviceType.intValue) {
        case IPHONE_4S:
            self.OptionScrollView.autoresizesSubviews = NO;
            self.OptionScrollView.autoresizingMask = UIViewAutoresizingNone;
            self.SystemButton.autoresizesSubviews = NO;
            self.SystemButton.autoresizingMask = UIViewAutoresizingNone;
            self.TapAlertImage.autoresizingMask = UIViewAutoresizingNone;
            float Margin = 5;
            float OptionScrollViewLocationX = self.SystemButton.frame.origin.x + (self.SystemButton.frame.size.width - self.OptionScrollView.frame.size.width)/2;
            self.OptionScrollView.frame = CGRectMake(OptionScrollViewLocationX,
                                                     0,
                                                     self.OptionScrollView.frame.size.width,
                                                     self.OptionScrollView.frame.size.height
                                                     );
            self.SystemButton.frame = CGRectMake(OptionScrollViewLocationX - self.VoiceTypePicker.frame.size.width - Margin,
                                                 Margin,
                                                 self.VoiceTypePicker.frame.size.width,
                                                 self.VoiceTypePicker.frame.size.height
                                                 );
            self.AddLoopCellButton.frame = CGRectMake(self.AddLoopCellButton.frame.origin.x,
                                                      self.AddLoopCellButton.frame.origin.y + Margin,
                                                      self.AddLoopCellButton.frame.size.width,
                                                      self.AddLoopCellButton.frame.size.height
                                                      );
            self.PlayCellListButton.frame = CGRectMake(self.PlayCellListButton.frame.origin.x,
                                                      self.PlayCellListButton.frame.origin.y + Margin,
                                                      self.PlayCellListButton.frame.size.width,
                                                      self.PlayCellListButton.frame.size.height
                                                      );
            self.TapAlertImage.frame = CGRectMake(self.TapAlertImage.frame.origin.x,
                                                  Margin,
                                                  self.TapAlertImage.frame.size.width,
                                                  self.TapAlertImage.frame.size.height
                                                  );
            break;
        case IPHONE_5S:
            break;
        default:
            break;
    }

}

- (id)initWithFrame:(CGRect)frame
{

    
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
        [self.BPMPicker removeFromSuperview];
        self.BPMPicker = [[LargeBPMPicker alloc] initWithFrame:self.BPMPicker.frame];
        [self addSubview:self.BPMPicker];
        [self sendSubviewToBack:self.BPMPicker];

        [self.TimeSignaturePickerView removeFromSuperview];
        self.TimeSignaturePickerView = [[TimeSignaturePickerView alloc] initWithFrame:self.TimeSignaturePickerView.frame];
        [self addSubview:self.TimeSignaturePickerView];
        [self sendSubviewToBack:self.TimeSignaturePickerView];

        [self.VoiceTypePickerView removeFromSuperview];
        self.VoiceTypePickerView = [[VoiceTypePickerView alloc] initWithFrame:self.VoiceTypePickerView.frame];
        [self addSubview:self.VoiceTypePickerView];
        [self sendSubviewToBack:self.VoiceTypePickerView];
        
        [self.LoopCellEditerView removeFromSuperview];
        self.LoopCellEditerView = [[LoopCellEditerView alloc] initWithFrame:self.LoopCellEditerView.frame];
        [self addSubview:self.LoopCellEditerView];
        [self sendSubviewToBack:self.LoopCellEditerView];
        
        self.TapAlertImage.hidden = YES;
        self.TimeSignaturePickerView.hidden = YES;
        self.VoiceTypePickerView.hidden = YES;
        self.LoopCellEditerView.hidden = YES;
        
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
