//
//  BundleGrooveCell.h
//  Metronome_Ver1
//
//  Created by C-ty on 2014/8/21.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//


#import "XibTableViewCellInterface.h"
#import "TempoList.h"

@class TempoListUICell;

@protocol TempoListUICellProtocol <NSObject>
@required

@optional

- (IBAction)DeleteCell:(TempoListUICell *) Cell;
@end

@interface TempoListUICell : XibTableViewCellInterface

@property (nonatomic, assign) id <TempoListUICellProtocol> delegate;
@property (getter=GetTempoList, setter=SetTempoList:)TempoList*  TempoList;
@end
