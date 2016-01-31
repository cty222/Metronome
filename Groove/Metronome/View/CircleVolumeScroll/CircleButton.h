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

- (void) circleButtonValueChanged:(CircleButton*) circleButton;
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
    float maxIndex;
    float minIndex;
    float unitValue;
}CircleButtonRange;

@interface CircleButton : XibViewInterface

@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *signPicture;
@property (strong, nonatomic) IBOutlet UIImageView *twickPicture;


@property (getter = getIndexValue, setter = setIndexValue:) float indexValue;
@property (getter = getIndexRange, setter = setIndexRange:) CircleButtonRange indexRange;
@property (getter = getIndexValueSensitivity, setter = setIndexValueSensitivity:) double indexValueSensitivity;

@property (nonatomic, assign) id<CircleButtonProtocol> delegate;

- (void) twickLing;
- (void) resetHandle;

@end
