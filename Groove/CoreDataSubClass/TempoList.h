//
//  TempoList.h
//  Groove
//
//  Created by C-ty on 2015/1/9.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MusicBindingInfo, TempoCell, TempoPrivateProperties;

@interface TempoList : NSManagedObject

@property (nonatomic, retain) NSNumber * focusCellIndex;
@property (nonatomic, retain) NSNumber * sortIndex;
@property (nonatomic, retain) NSString * tempoListName;
@property (nonatomic, retain) NSSet *cellsArray;
@property (nonatomic, retain) MusicBindingInfo *musicInfo;
@property (nonatomic, retain) TempoPrivateProperties *privateProperties;
@end

@interface TempoList (CoreDataGeneratedAccessors)

- (void)addCellsArrayObject:(TempoCell *)value;
- (void)removeCellsArrayObject:(TempoCell *)value;
- (void)addCellsArray:(NSSet *)values;
- (void)removeCellsArray:(NSSet *)values;

@end
