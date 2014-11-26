//
//  VoiceType.h
//  Groove
//
//  Created by C-ty on 2014/11/27.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoCell;

@interface VoiceType : NSManagedObject

@property (nonatomic, retain) NSString * voiceType;
@property (nonatomic, retain) TempoCell *usingCell;

@end
