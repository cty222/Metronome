//
//  LargeBPMPicker.h
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "GlobalConfig.h"
#import "XibViewInterface.h"

@ class LargeBPMPicker;

@protocol LargeBPMPickerProtocol <NSObject>
@required

@optional

- (void) SetBPMValue : (int) NewValue;
@end

@interface LargeBPMPicker : XibViewInterface
@property (weak, nonatomic) IBOutlet UILabel *LebalBPMValue;

@property (getter = GetBPMValue, setter = SetBPMValue:) int BPMValue;

@property (weak, nonatomic) IBOutlet UIImageView *UpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *DownArrow;

//
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;

- (void) TouchBeginEvent : (CGPoint) TouchLocation;
- (void) TouchEndEvent : (CGPoint) TouchLocation;
- (void) TouchMoveEvent : (CGPoint) TouchLocation;
- (void) TouchCancellEvent : (CGPoint) TouchLocation;
//

@property (nonatomic, assign) id<LargeBPMPickerProtocol> delegate;

@end
