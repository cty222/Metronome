//
//  MetronomeSelectBar.h
//  Groove
//
//  Created by C-ty on 2014/9/21.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@interface MetronomeSelectBar : XibViewInterface
@property (getter = GetGrooveCellList, setter = SetGrooveCellList:)NSMutableArray* GrooveCellList;

@property (getter = GetTouched, setter = SetTouched:) BOOL Touched;
@property (getter = GetFocusIndex, setter = SetFocusIndex:) int FocusIndex;

- (void) TouchBeginEvent : (CGPoint) TouchLocation;
- (void) TouchEndEvent : (CGPoint) TouchLocation;
- (void) TouchMoveEvent : (CGPoint) TouchLocation;
- (void) TouchCancellEvent : (CGPoint) TouchLocation;
@end
