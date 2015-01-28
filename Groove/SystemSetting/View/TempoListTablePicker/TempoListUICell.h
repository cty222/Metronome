//
//  BundleGrooveCell.h
//  Metronome_Ver1
//
//  Created by C-ty on 2014/8/21.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//


#import "XibTableViewCellInterface.h"
#import "TempoList.h"
#import "CustomerButton.h"
#import "GlobalConfig.h"

@class TempoListUICell;

@protocol TempoListUICellProtocol <NSObject>
@required

@optional

- (IBAction)DeleteCell:(TempoListUICell *) Cell;
- (IBAction)EditCell:(TempoListUICell *) Cell;
@end

@interface TempoListUICell : XibTableViewCellInterface <CustomerButtonProtocol>
@property (strong, nonatomic) IBOutlet CustomerButton *EditButton;
@property (strong, nonatomic) IBOutlet UILabel *NameLabel;

@property (nonatomic, assign) id <TempoListUICellProtocol> delegate;
@property (getter=GetTempoList, setter=SetTempoList:)TempoList*  TempoList;
@end
