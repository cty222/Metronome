//
//  TempoPrivateProperties.h
//  Groove
//
//  Created by C-ty on 2015/1/9.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoList;

@interface TempoPrivateProperties : NSManagedObject

@property (nonatomic, retain) NSNumber * doubleValueEnable;
@property (nonatomic, retain) NSNumber * tempoListLoopingEnable;
@property (nonatomic, retain) TempoList *owner;

@end
