//
//  LoopCellEditerView.m
//  Groove
//
//  Created by C-ty on 2014/12/8.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "LoopCellEditerView.h"

@implementation LoopCellEditerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)PlusChange:(id)sender {
    [self ChangeValue:self :sender];

}
- (IBAction)MinusChange:(id)sender {
    [self ChangeValue:self :sender];
}
- (IBAction)CellDeleteChange:(id)sender {
    [self ChangeValue:self :sender];
}

@end
