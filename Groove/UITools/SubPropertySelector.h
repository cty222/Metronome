//
//  SubPropertySelector.h
//  Groove
//
//  Created by C-ty on 2014/11/26.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"
#import "UIWindowWithHook.h"

@protocol SubPropertySelectorProtocol <NSObject>
@required

@optional

- (IBAction)ChangeValue: (id)RootSuperView : (id) ChooseCell;
@end

@interface SubPropertySelector : XibViewInterface
@property (strong, nonatomic) IBOutlet UIImageView *ArrowView;
@property (strong, nonatomic) IBOutlet UIScrollView *ContentScrollView;
@property (strong, nonatomic) id TriggerButton;
@property (strong, nonatomic) IBOutlet UIImageView *BackgroundView;

@property float OriginYOffset;
@property float ArrowCenterLine;
@property (nonatomic, assign) id<SubPropertySelectorProtocol> delegate;

@property (getter = GetHidden, setter = SetHidden:) BOOL hidden;
- (IBAction)ClickCell: (id) sender;
- (IBAction)ChangeValue: (id)RootSuperView : (id) ChooseCell;
- (BOOL) IsIncludeTargetView: (UIView *) TargetView;
- (void) SetHidden:(BOOL)hidden;

@end
