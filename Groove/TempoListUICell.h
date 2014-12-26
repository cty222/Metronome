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

@property (weak, nonatomic) IBOutlet UILabel *LblName;
@property (weak, nonatomic) IBOutlet UISwitch *DeleteEnableSwitch;
@property (strong, nonatomic) IBOutlet UIButton *DeleteCellButton;
@property (nonatomic, assign) id <TempoListUICellProtocol> delegate;
@property (getter=GetTempoList, setter=SetTempoList:)TempoList*  TempoList;
@end
