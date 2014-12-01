//
//  VoiceType.h
//  Groove
//
//  Created by C-ty on 2014/12/2.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoCell;

@interface VoiceType : NSManagedObject

@property (nonatomic, retain) NSString * voiceType;
@property (nonatomic, retain) NSNumber * sortIndex;
@property (nonatomic, retain) TempoCell *usingCell;

@end
