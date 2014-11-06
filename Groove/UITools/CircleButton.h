//
//  CircleButton.h
//  Groove
//
//  Created by C-ty on 2014/11/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

typedef enum {
    CBM_NO_DATA_ARRAY,
    CBM_HAVE_DATA_ARRAY
} CIRCLE_BUTTON_MODE;

@interface CircleButton : XibViewInterface
@property (strong, nonatomic) IBOutlet UIView *FrontView;
@property (strong, nonatomic) IBOutlet UIView *BackView;

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetIndexValue, setter = SetIndexValue:) NSUInteger IndexValue;
@property NSUInteger MaxIndex;
@property NSUInteger MinIndex;

@property (getter = GetSensitivity, setter = SetSensitivity:) double Sensitivity;
@property (getter = GetDataStringArray, setter = SetDataStringArray:) NSMutableArray * DataStringArray;

@end
