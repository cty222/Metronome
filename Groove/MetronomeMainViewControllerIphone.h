//
//  MetronomeMainViewControllerIphone.h
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>

// View
#import "MetronmoneTopSubViewIphone.h"
#import "MetronomeBottomSubViewIphone.h"
#import "MetronomeSelectBar.h"

// Model
#import "MetronomeModel.h"

@interface MetronomeMainViewControllerIphone : UIViewController
@property (strong, nonatomic) IBOutlet UIView *FullView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (nonatomic) MetronmoneTopSubViewIphone *TopSubView;
@property (nonatomic) MetronomeBottomSubViewIphone *BottomSubView;
@end
