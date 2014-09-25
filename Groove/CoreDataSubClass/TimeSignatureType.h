//
//  TimeSignatureType.h
//  Groove
//
//  Created by C-ty on 2014/9/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeSignatureType : NSManagedObject

@property (nonatomic, retain) NSString * timeSignature;
@property (nonatomic, retain) NSSet *usingCell;
@end

@interface TimeSignatureType (CoreDataGeneratedAccessors)

- (void)addUsingCellObject:(NSManagedObject *)value;
- (void)removeUsingCellObject:(NSManagedObject *)value;
- (void)addUsingCell:(NSSet *)values;
- (void)removeUsingCell:(NSSet *)values;

@end
