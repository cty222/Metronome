//
//  MusicBindingInfo.h
//  Groove
//
//  Created by C-ty on 2014/12/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoList;

@interface MusicBindingInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * endTime;
@property (nonatomic, retain) NSNumber * persistentID;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) TempoList *owner;

@end
