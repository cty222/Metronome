//
//  VoiceType.h
//  Groove
//
//  Created by C-ty on 2015/1/7.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoCell;

@interface VoiceType : NSManagedObject

@property (nonatomic, retain) NSNumber * sortIndex;
@property (nonatomic, retain) NSString * voiceType;
@property (nonatomic, retain) NSSet *usingCell;
@end

@interface VoiceType (CoreDataGeneratedAccessors)

- (void)addUsingCellObject:(TempoCell *)value;
- (void)removeUsingCellObject:(TempoCell *)value;
- (void)addUsingCell:(NSSet *)values;
- (void)removeUsingCell:(NSSet *)values;

@end
