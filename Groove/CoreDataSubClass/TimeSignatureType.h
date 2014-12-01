//
//  TimeSignatureType.h
//  Groove
//
//  Created by C-ty on 2014/12/2.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoCell;

@interface TimeSignatureType : NSManagedObject

@property (nonatomic, retain) NSString * timeSignature;
@property (nonatomic, retain) NSNumber * sortIndex;
@property (nonatomic, retain) NSSet *usingCell;
@end

@interface TimeSignatureType (CoreDataGeneratedAccessors)

- (void)addUsingCellObject:(TempoCell *)value;
- (void)removeUsingCellObject:(TempoCell *)value;
- (void)addUsingCell:(NSSet *)values;
- (void)removeUsingCell:(NSSet *)values;

@end
