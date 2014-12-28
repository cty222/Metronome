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
            [self.SystemButton setBackgroundImage:[UIImage imageNamed:@"SystemButton_4S"] forState:UIControlStateNormal];
            
            self.TapAnimationImage.autoresizingMask = UIViewAutoresizingNone;
            self.TimeSigaturePicker.autoresizingMask = UIViewAutoresizingNone;
            self.VoiceTypePicker.autoresizingMask = UIViewAutoresizingNone;
            self.LoopCellEditer.autoresizingMask = UIViewAutoresizingNone;
            
            self.TimeSignaturePickerView.autoresizingMask = UIViewAutoresizingNone;
            self.VoiceTypePickerView.autoresizingMask = UIViewAutoresizingNone;
            self.LoopCellEditerView.autoresizingMask = UIViewAutoresizingNone;

        
            float Margin = 3;
            float OptionScrollViewLocationX = self.SystemButton.frame.origin.x + (self.SystemButton.frame.size.width - self.OptionScrollView.frame.size.width)/2;
            self.OptionScrollView.frame = CGRectMake(OptionScrollViewLocationX,
                                                     15,
                                                     self.OptionScrollView.frame.size.width,
                                                     self.OptionScrollView.frame.size.height - 15
                                                     );
            self.TimeSigaturePicker.frame = CGRectMake(self.TimeSigaturePicker.frame.origin.x,
                                                     self.TimeSigaturePicker.frame.origin.y - 6,
                                                     self.TimeSigaturePicker.frame.size.width,
                                                     self.TimeSigaturePicker.frame.size.height
                                                     );
            self.VoiceTypePicker.frame = CGRectMake(self.VoiceTypePicker.frame.origin.x,
                                                       self.VoiceTypePicker.frame.origin.y - 7,
                                                       self.VoiceTypePicker.frame.size.width,
                                                       self.VoiceTypePicker.frame.size.height
                                                       );
            self.LoopCellEditer.frame = CGRectMake(self.LoopCellEditer.frame.origin.x,
                                                       self.LoopCellEditer.frame.origin.y - 8,
                                                       self.LoopCellEditer.frame.size.width,
                                                       self.LoopCellEditer.frame.size.height
                                                       );
            
            self.AddLoopCellButton.frame = CGRectMake(self.AddLoopCellButton.frame.origin.x,
                                                      self.AddLoopCellButton.frame.origin.y -19,
                                                      self.AddLoopCellButton.frame.size.width,
                                                      self.AddLoopCellButton.frame.size.height + 20
                                                      );

            
            self.SystemButton.frame = CGRectMake(OptionScrollViewLocationX - self.VoiceTypePicker.frame.size.width - Margin *2,
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
            
            self.PlayMusicButton.frame = CGRectMake(self.PlayMusicButton.frame.origin.x,
                                                       self.PlayMusicButton.frame.origin.y + Margin,
                                                       self.PlayMusicButton.frame.size.width,
                                                       self.PlayMusicButton.frame.size.height
                                                       );
            
            self.TapAnimationImage.frame = CGRectMake(self.TapAnimationImage.frame.origin.x,
                                                  Margin,
                                                  self.TapAnimationImage.frame.size.width,
                                                  self.TapAnimationImage.frame.size.height
                                                  );
            
            // ================
            // 三個位置要用相同的
            self.TimeSignaturePickerView.frame = CGRectMake(self.TimeSignaturePickerView.frame.origin.x,
                                                            7,
                                                            self.TimeSignaturePickerView.frame.size.width,
                                                            134
                                                            );
            
            self.VoiceTypePickerView.frame = CGRectMake(self.TimeSignaturePickerView.frame.origin.x,
                                                        self.TimeSignaturePickerView.frame.origin.y,
                                                        self.TimeSignaturePickerView.frame.size.width,
                                                        self.TimeSignaturePickerView.frame.size.height
                                                        );
            
            self.LoopCellEditerView.frame = CGRectMake(self.TimeSignaturePickerView.frame.origin.x,
                                                       self.TimeSignaturePickerView.frame.origin.y,
                                                       self.TimeSignaturePickerView.frame.size.width,
                                                       self.TimeSignaturePickerView.frame.size.height
                                                       );
            //
            // ================
            self.AddLoopCellButton.frame = CGRectMake(self.SystemButton.frame.origin.x - 3 * Margin,
                                                      self.AddLoopCellButton.frame.origin.y,
                                                      self.AddLoopCellButton.frame.size.width,
                                                      self.AddLoopCellButton.frame.size.height
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
        
        [self.TapAnimationImage removeFromSuperview];
        self.TapAnimationImage = [[TapAnimationImage alloc] initWithFrame:self.TapAnimationImage.frame];
        [self addSubview:self.TapAnimationImage];
        
        self.TapAnimationImage.hidden = YES;
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
