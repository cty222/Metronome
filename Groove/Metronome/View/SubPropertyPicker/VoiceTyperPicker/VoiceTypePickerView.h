//
//  VoiceTypePickerView.h
//  Groove
//
//  Created by C-ty on 2014/12/8.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SubPropertySelector.h"
#import "VoiceType.h"

@interface VoiceTypePickerView : SubPropertySelector


- (id) ReturnTargetButton : (int) TagNumber;
- (void) DisplayPropertyCell : (NSArray *) FillInData : (UIView *) TriggerButton;
@end
