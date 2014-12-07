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
            self.PlayLoopCellButton.frame = CGRectMake(self.PlayLoopCellButton.frame.origin.x,
                                                      self.PlayLoopCellButton.frame.origin.y + Margin,
                                                      self.PlayLoopCellButton.frame.size.width,
                                                      self.PlayLoopCellButton.frame.size.height
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

#if 0
        [self.SubPropertySelectorView removeFromSuperview];
        self.SubPropertySelectorView = [[SubPropertySelector alloc] initWithFrame:self.SubPropertySelectorView.frame];
        [self addSubview:self.SubPropertySelectorView];
        [self sendSubviewToBack:self.SubPropertySelectorView];
        [self.SubPropertySelectorView ChangeMode:SUB_PROPERTY_MODE_HIDDEN
                                                :0
                                                : nil];
#endif
        self.TapAlertImage.hidden = YES;
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
