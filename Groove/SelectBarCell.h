//
//  SelectBarCell.h
//  Groove
//
//  Created by C-ty on 2014/11/16.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "XibViewInterface.h"

@class SelectBarCell;


@protocol SelectBarCellProtocol <NSObject>
@required

@optional
- (void) CellLongPress: (SelectBarCell *) ThisCell;
- (void) CellShortPress: (SelectBarCell*) ThisCell;
@end

@interface SelectBarCell : XibViewInterface

@property int IndexNumber;
@property (getter = GetText, setter = SetText:) NSString *Text ;
@property (nonatomic, assign) id<SelectBarCellProtocol> delegate;

@end
