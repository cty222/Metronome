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
        
        [self.SubPropertySelectorView removeFromSuperview];
        self.SubPropertySelectorView = [[SubPropertySelector alloc] initWithFrame:self.SubPropertySelectorView.frame];
        [self addSubview:self.SubPropertySelectorView];
        [self sendSubviewToBack:self.SubPropertySelectorView];
        [self.SubPropertySelectorView ChangeMode:SUB_PROPERTY_MODE_HIDDEN :0];
        
        [self.LoopCellEditBarView removeFromSuperview];
        self.LoopCellEditBarView = [[LoopCellEditBar alloc] initWithFrame:self.LoopCellEditBarView.frame];
        [self addSubview:self.LoopCellEditBarView];
        [self sendSubviewToBack:self.LoopCellEditBarView];
        [self.LoopCellEditBarView ChangeMode:LOOP_CELL_EDIT_BAR_MODE_HIDDEN :0];

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
