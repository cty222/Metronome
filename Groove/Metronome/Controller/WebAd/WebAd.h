//
//  WebAd.h
//  RockClick
//
//  Created by C-ty on 2015/7/15.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@protocol WebAdProtocol <NSObject>
@required

@optional

- (IBAction) closeWebAdEvent: (id) sender;
@end

@interface WebAd : XibViewInterface
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *adImageView;
@property (nonatomic, assign) id<WebAdProtocol> delegate;

@end
