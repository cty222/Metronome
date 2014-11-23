//
//  LargeBPMPicker.h
//  Groove
//
//  Created by C-ty on 2014/9/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "GlobalConfig.h"
#import "XibViewInterface.h"


#define DIGIT_ENABLE_FLAG 0

@ class LargeBPMPicker;

@protocol LargeBPMPickerProtocol <NSObject>
@required

@optional

- (void) SetBPMValue : (int) NewValue;
- (void) ShortPress: (LargeBPMPicker *) ThisPicker;
@end

@interface LargeBPMPicker : XibViewInterface

@property (getter = GetBPMValue, setter = SetBPMValue:) int BPMValue;
@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;

#if DIGIT_ENABLE_FLAG
@property (strong, nonatomic) IBOutlet UIView *DigitInHundreds;
@property (strong, nonatomic) IBOutlet UIView *DigitInTens;
@property (strong, nonatomic) IBOutlet UIView *DigitInOnces;
#else
@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;
#endif

@property (weak, nonatomic) IBOutlet UIImageView *UpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *DownArrow;

//
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;

@property (nonatomic, assign) id<LargeBPMPickerProtocol> delegate;

@end
