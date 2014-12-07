//
//  VoiceTypePickerView.m
//  Groove
//
//  Created by C-ty on 2014/12/8.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "VoiceTypePickerView.h"

@implementation VoiceTypePickerView
{
    BOOL _hidden;
}


- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) DisplayPropertyCell : (NSArray *) FillInData : (UIView *) TriggerButton
{
    float Width  = TriggerButton.frame.size.width;
    float Height = TriggerButton.frame.size.height;
    float XOffset = Width / 2;
    float YOffset = Height / 2;
    float RightMargin = Width / 2;
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
        VoiceType * tmp = FillInData[Index];
        
        [TmpButton setBackgroundImage:[UIImage imageNamed:tmp.voiceType] forState:UIControlStateNormal];
        [TmpButton addTarget:self
                      action:@selector(ClickCell:)
            forControlEvents:UIControlEventTouchDown
         ];
        [self.ContentScrollView addSubview:TmpButton];
        LastCellLoationY = TmpButton.frame.origin.y;
    }
    self.ContentScrollView.contentInset = UIEdgeInsetsMake (0, 0, LastCellLoationY + Height, 0);
    self.ContentScrollView.contentOffset = CGPointMake(0, 0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
