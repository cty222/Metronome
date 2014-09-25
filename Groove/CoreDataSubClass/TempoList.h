//
//  TempoList.h
//  Groove
//
//  Created by C-ty on 2014/9/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoCell;

@interface TempoList : NSManagedObject

@property (nonatomic, retain) NSString * tempoListName;
@property (nonatomic, retain) NSSet *cellBelongTo;
@end

@interface TempoList (CoreDataGeneratedAccessors)

- (void)addCellBelongToObject:(TempoCell *)value;
- (void)removeCellBelongToObject:(TempoCell *)value;
- (void)addCellBelongTo:(NSSet *)values;
- (void)removeCellBelongTo:(NSSet *)values;

@end
