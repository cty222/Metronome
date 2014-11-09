//
//  CircleButton.h
//  Groove
//
//  Created by C-ty on 2014/11/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

#define ROUNDING_BACK_SENSITIVITY   10
#define ROUNDING_START_SENSITIVITY  4

typedef enum {
    CBM_NO_DATA_ARRAY,
    CBM_HAVE_DATA_ARRAY
} CIRCLE_BUTTON_MODE;

@interface CircleButton : XibViewInterface
@property (strong, nonatomic) IBOutlet UIView *SubView_F4;
@property (strong, nonatomic) IBOutlet UIView *SubView_F3;
@property (strong, nonatomic) IBOutlet UIView *SubView_F2_ValueHide;
@property (strong, nonatomic) IBOutlet UIView *SubView_F2_Value;
@property (strong, nonatomic) IBOutlet UIView *SubView_F1;
@property (strong, nonatomic) IBOutlet UIImageView *F1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *F2ImageValueView;
@property (strong, nonatomic) IBOutlet UIImageView *F3ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *F4ImageView;

@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetIndexValue, setter = SetIndexValue:) NSInteger IndexValue;
@property NSInteger MaxIndex;
@property NSInteger MinIndex;

@property (getter = GetSensitivity, setter = SetSensitivity:) double Sensitivity;
@property (getter = GetDataStringArray, setter = SetDataStringArray:) NSMutableArray * DataStringArray;

@end
