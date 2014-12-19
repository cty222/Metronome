//
//  InputSubmitView.h
//  Groove
//
//  Created by C-ty on 2014/12/19.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"


@protocol InputSubmitViewProtocol <NSObject>
@required

@optional
- (IBAction) Save: (UIButton *) SaveButton;
- (IBAction) Cancel : (UIButton *) CancelButton;
@end

@interface InputSubmitView : XibViewInterface

@property int ID;
- (IBAction) Save: (UIButton *) SaveButton;
- (IBAction) Cancel : (UIButton *) CancelButton;

@property (nonatomic, assign) id<InputSubmitViewProtocol> delegate;

@end
