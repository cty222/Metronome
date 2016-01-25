//
//  TempoListViewController.h
//  Groove
//
//  Created by C-ty on 2014/12/28.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConfig.h"
#import "ListTablePicker.h"
#import "GlobalServices.h"

@interface TempoListViewController : UIViewController<ListTablePickerProtocol>
@property (strong, nonatomic) IBOutlet ListTablePicker *ListTablePicker;

- (id) initWithGlobalServices: (GlobalServices *) globalService;

@end
