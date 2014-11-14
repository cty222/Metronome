//
//  CircleButton.h
//  Groove
//
//  Created by C-ty on 2014/11/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@class CircleButton;

@protocol CircleButtonProtocol <NSObject>
@required

@optional

- (IBAction) CircleButtonValueChanged:(CircleButton*) ThisCircleButton;
@end

#define ROUNDING_BACK_SENSITIVITY   10
#define ROUNDING_START_SENSITIVITY  4
#define HALF_CIRCLE_DEGREE  180
#define CIRCLE_DEFAULT_MAX_VALUE 1
#define CIRCLE_DEFAULT_MIN_VALUE 0

typedef enum {
    CBM_NO_DATA_ARRAY,
    CBM_HAVE_DATA_ARRAY
} CIRCLE_BUTTON_MODE;

typedef struct {
    float MaxIndex;
    float MinIndex;
    float UnitValue;
}CIRCLEBUTTON_RANGE;

@interface CircleButton : XibViewInterface
@property (strong, nonatomic) IBOutlet UIView *SubView_Frame4;
@property (strong, nonatomic) IBOutlet UIView *SubView_Frame3;
@property (strong, nonatomic) IBOutlet UIView *SubView_Frame2_BlockValue;
@property (strong, nonatomic) IBOutlet UIView *SubView_Frame1_Value;
@property (strong, nonatomic) IBOutlet UIView *SubView_Frame0;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView_Frame0;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView_Frame1_Value;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView_Frame3;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView_Frame4;

@property (strong, nonatomic) IBOutlet UILabel *ValueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *SignPicture;

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetIndexValue, setter = SetIndexValue:) float IndexValue;
@property (getter = GetIndexRange, setter = SetIndexRange:) CIRCLEBUTTON_RANGE IndexRange;

@property (getter = GetIndexValueSensitivity, setter = SetIndexValueSensitivity:) double IndexValueSensitivity;

@property (nonatomic, assign) id<CircleButtonProtocol> delegate;

@end
