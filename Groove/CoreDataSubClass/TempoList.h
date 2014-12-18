//
//  TempoList.h
//  Groove
//
//  Created by C-ty on 2014/12/19.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MusicBindingInfo, TempoCell;

@interface TempoList : NSManagedObject

@property (nonatomic, retain) NSString * tempoListName;
@property (nonatomic, retain) NSNumber * focusCellIndex;
@property (nonatomic, retain) NSNumber * sortIndex;
@property (nonatomic, retain) NSSet *cellBelongTo;
@property (nonatomic, retain) MusicBindingInfo *musicInfo;
@end

@interface TempoList (CoreDataGeneratedAccessors)

- (void)addCellBelongToObject:(TempoCell *)value;
- (void)removeCellBelongToObject:(TempoCell *)value;
- (void)addCellBelongTo:(NSSet *)values;
- (void)removeCellBelongTo:(NSSet *)values;

@end
