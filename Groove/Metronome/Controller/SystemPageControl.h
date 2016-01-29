//
//  SystemPageControl.h
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetronomeMainViewController.h"

@interface SystemPageControl : NSObject <ADBannerViewDelegate>

@property UIViewController *ParrentController;

// (5) System Button
@property(nonatomic,retain)IBOutlet ADBannerView *adView;

- (id) initWithGlobalServices: (GlobalServices *) globalServices;

@end
