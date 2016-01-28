//
//  BPMPickerViewController.h
//  RockClick
//
//  Created by C-ty on 2016-01-28.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "GlobalConfig.h"
#import <UIKit/UIKit.h>

#define DIGIT_ENABLE_FLAG 0

typedef enum{
    BPM_PICKER_INT_MODE,
    BPM_PICKER_DOUBLE_MODE
} BPM_PICKER_MODE;

@protocol LargeBPMPickerProtocol <NSObject>
@required

@optional

- (void) SetBPMValue : (id) ThisPicker;
- (void) ShortPress: (id) ThisPicker;
@end

@interface BPMPickerViewController : UIViewController

@property (getter = GetMode, setter = SetMode:) BPM_PICKER_MODE Mode;
@property (getter = GetValue, setter = SetValue:) double Value;
@property (getter = GetShortPressSecond, setter = SetShortPressSecond:) float ShortPressSecond;

@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;

@property (weak, nonatomic) IBOutlet UIImageView *UpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *DownArrow;
@property (strong, nonatomic) IBOutlet UIView *UpValueFrameView;
@property (strong, nonatomic) IBOutlet UIView *DownValueFrameView;

//
@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;

@property (nonatomic, assign) id<LargeBPMPickerProtocol> delegate;

@end
