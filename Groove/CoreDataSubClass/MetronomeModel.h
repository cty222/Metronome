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
#import "DbConfig.h"

@class MetronomeModel;

MetronomeModel * gMetronomeModel;

@interface MetronomeModel : NSObject

@property NSFetchRequest* TempoCellEntityFetch;
@property NSFetchRequest* TempoCellEntitySigleOwnerFetch;
@property NSFetchRequest* TempoListEntityFetch;
@property NSFetchRequest* TimeSignatureTypeEntityFetch;
@property NSFetchRequest* DbConfigEntityFetch;

@property NSArray* TempoCellDataTable;
@property NSArray* TempoListDataTable;
@property NSArray* TimeSignatureTypeDataTable;
@property NSArray* DbVersionDataTable;

- (NSArray *) FetchTempoCellWhereListName : (NSString *) listOwner;


- (void) InitializeCoreData : (NSManagedObjectContext *) ManagedObjectContext
         ManagedObjectModel : (NSManagedObjectModel *) ManagedObjectModel
                  DbVersion : (NSNumber *) DbVersion;
@end