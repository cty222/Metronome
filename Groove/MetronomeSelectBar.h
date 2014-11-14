//
//  MetronomeSelectBar.h
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@protocol SelectBarProtocol <NSObject>
@required

@optional

- (void) SetFocusIndex: (int) FocusIndex;
@end


@interface MetronomeSelectBar : XibViewInterface
@property (getter = GetGrooveCellList, setter = SetGrooveCellList:)NSMutableArray* GrooveCellList;

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;

@property (nonatomic, assign) id<SelectBarProtocol> delegate;

@end
