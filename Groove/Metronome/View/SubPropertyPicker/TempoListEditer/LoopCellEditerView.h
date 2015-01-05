//
//  LoopCellEditerView.h
//  Groove
//
//  Created by C-ty on 2014/12/8.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SubPropertySelector.h"
#import "ValueScrollView.h"

@interface LoopCellEditerView : SubPropertySelector <ValuePickerTemplateProtocol>
@property (strong, nonatomic) IBOutlet UIButton *CellDeleteButton;
@property (strong, nonatomic) IBOutlet UIImageView *DeleteUnLock;
@property (strong, nonatomic) IBOutlet ValueScrollView *ValueScrollView;


// 4S
@property (strong, nonatomic) IBOutlet UIButton *CellDeleteButton4S;
@property (strong, nonatomic) IBOutlet UIImageView *DeleteUnLock4S;
@property (strong, nonatomic) IBOutlet ValueScrollView *ValueScrollView4S;

@end
