//
//  LoopCellEditerView.h
//  Groove
//
//  Created by C-ty on 2014/12/8.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SubPropertySelector.h"

@interface LoopCellEditerView : SubPropertySelector
@property (strong, nonatomic) IBOutlet UIButton *CellCounterPlusButton;
@property (strong, nonatomic) IBOutlet UIButton *CellCounterMinusButton;
@property (strong, nonatomic) IBOutlet UIButton *CellDeleteButton;

@end
