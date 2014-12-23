//
//  MetronomeModel.h
//  Groove
//
//  Created by C-ty on 2014/9/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//
#include "DebugHeader.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TempoCell.h"
#import "TempoList.h"
#import "TimeSignatureType.h"
#import "VoiceType.h"
#import "MusicBindingInfo.h"
#import "DbConfig.h"

@class MetronomeModel;

MetronomeModel * gMetronomeModel;

@interface MetronomeModel : NSObject

@property NSArray* TempoListDataTable;
@property NSArray* TimeSignatureTypeDataTable;
@property NSArray* VoiceTypeDataTable;
@property NSArray* DbVersionDataTable;

- (NSArray *) FetchTempoCellFromTempoListWithSort : (TempoList *) listOwner;
- (void) SyncTimeSignatureTypeDataTableWithModel;
- (void) SyncVoiceTypeWithModel;
- (void) SyncTempoListDataTableWithModel;


- (void) InitializeCoreData : (NSManagedObjectContext *) ManagedObjectContext
         ManagedObjectModel : (NSManagedObjectModel *) ManagedObjectModel
                  DbVersion : (NSNumber *) DbVersion;

- (TempoList *) PickTargetTempoListFromDataTable : (NSNumber * ) TempoListIndex;

- (void) Save;
- (void) AddNewTempoCell : (TempoList *) CellOwner;
- (void) DeleteTargetTempoCell : (TempoCell *) TargetCell;
- (MusicBindingInfo *) CreateNewMusicInfo;

@end
