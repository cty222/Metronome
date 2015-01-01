//
//  TimeSignaturePickerView.m
//  Groove
//
//  Created by C-ty on 2014/12/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "TimeSignaturePickerView.h"
#import "GlobalConfig.h"

@implementation TimeSignaturePickerView


- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSNumber * DeviceType = [GlobalConfig DeviceType];
        switch (DeviceType.intValue) {
            case IPHONE_4S:
                self.BackgroundView.image = [UIImage imageNamed:@"PropertyDialog_4S"];
                break;
            case IPHONE_5S:
                break;
            default:
                break;
        }
    }
    return self;
}

- (void) DisplayPropertyCell : (NSArray *) FillInData : (UIView *) TriggerButton
{
    float Width  = TriggerButton.frame.size.width;
    float Height = TriggerButton.frame.size.height;
    float XOffset = Width * 0.8;
    float YOffset = Height / 2;
    float RightMargin = Width * 0.6;
    float DownMargin = Height / 2;
    
    int MaxColumn = (self.frame.size.width - XOffset)/ (Width + RightMargin);
    float LastCellLoationY = 0;
    
    for (int Index = 0; Index < FillInData.count; Index ++)
    {
        CGRect NewFrame = CGRectMake(XOffset + (Index % MaxColumn) * (Width + RightMargin),
                                     YOffset + (Index / MaxColumn) * (Height + DownMargin),
                                     Width,
                                     Height
                                     );
        UIButton * TmpButton = [[UIButton alloc] initWithFrame:NewFrame];
        TmpButton.tag = Index;
        [TmpButton setBackgroundImage:[UIImage imageNamed:@"ScrollViewCellBackGround"] forState:UIControlStateNormal];
        [TmpButton setTitleColor:[TimeSignaturePickerView TextFontColor] forState:UIControlStateNormal];
        TimeSignatureType * tmp = FillInData[Index];
        
        [TmpButton setTitle:tmp.timeSignature forState:UIControlStateNormal];
        [TmpButton addTarget:self
                      action:@selector(ClickCell:)
            forControlEvents:UIControlEventTouchDown
         ];
        
        [self.ContentScrollView addSubview:TmpButton];
        LastCellLoationY = TmpButton.frame.origin.y;
    }
    
    self.ContentScrollView.contentInset = UIEdgeInsetsMake (0, 0, LastCellLoationY + Height*2, 0);
    self.ContentScrollView.contentOffset = CGPointMake(0, Height);
}

+ (UIColor *) TextFontColor
{
    return [UIColor colorWithWhite:0.2 alpha:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
