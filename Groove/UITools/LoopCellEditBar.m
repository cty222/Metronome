//
//  LoopCellEditBar.m
//  Groove
//
//  Created by C-ty on 2014/12/3.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LoopCellEditBar.h"

@implementation LoopCellEditBar
{
    LOOP_CELL_EDIT_BAR_MODE _Mode;
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // addObserver: selector 所在
        // selector 名稱
        // name 訊息名, 相同的才接收
        // object 接收對象 nil為隨意
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(SelectorHiddenNotificationCallBack:)
                                                     name:kLoopCellEditBarHiddenNotification
                                                   object:nil];
    }
    return self;
}

- (void)SelectorHiddenNotificationCallBack:(NSNotification*) notification
{
    NSDictionary *UserInfoDictionary = [notification userInfo];
    NSNumber *Mode = (NSNumber *)[UserInfoDictionary valueForKey:Key_LoopCellEditBarMode];
    NSNumber *TriggerViewCenterLine = (NSNumber *)[UserInfoDictionary valueForKey:Key_LoopCellEditBarTriggerViewCenterLine];
    
    if(Mode == nil || TriggerViewCenterLine == nil)
    {
        return;
    }
    
    [self ChangeMode:[Mode intValue] : [TriggerViewCenterLine floatValue]];
}

- (LOOP_CELL_EDIT_BAR_MODE) GetMode
{
    return _Mode;
}

- (void) ChangeMode: (LOOP_CELL_EDIT_BAR_MODE) ModeValue : (float) TriggerViewCenterLineValue
{
    _Mode = ModeValue;
    if (self.Mode == LOOP_CELL_EDIT_BAR_MODE_HIDDEN)
    {
        self.hidden = YES;
    }
    else if (self.Mode == LOOP_CELL_EDIT_BAR_MODE_SHOW)
    {
        if (self.superview != nil)
        {
            self.hidden = NO;
            self.ArrowView.frame = CGRectMake(self.ArrowView.frame.origin.x, (TriggerViewCenterLineValue - self.ArrowView.frame.size.height/2 + self.OriginYOffset), self.ArrowView.frame.size.width, self.ArrowView.frame.size.height);
            [self.superview bringSubviewToFront:self];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
