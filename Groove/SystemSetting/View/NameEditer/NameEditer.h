//
//  NameEditer.h
//  Groove
//
//  Created by C-ty on 2015/1/2.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "InputSubmitView.h"
#import "GlobalConfig.h"

@interface NameEditer : InputSubmitView

@property (strong, nonatomic) IBOutlet UILabel *NowTitle;
@property (strong, nonatomic) IBOutlet UILabel *NewTitle;
@property (strong, nonatomic) IBOutlet UILabel *CurrentName;
@property (strong, nonatomic) IBOutlet UITextField *NewName;
@property TempoList*  TempoList;

@end
