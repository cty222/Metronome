//
//  TempoCell.h
//  Groove
//
//  Created by C-ty on 2014/11/27.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoList, TimeSignatureType, VoiceType;

@interface TempoCell : NSManagedObject

@property (nonatomic, retain) NSNumber * accentVolume;
@property (nonatomic, retain) NSNumber * bpmValue;
@property (nonatomic, retain) NSNumber * eighthNoteVolume;
@property (nonatomic, retain) NSNumber * loopCount;
@property (nonatomic, retain) NSNumber * quarterNoteVolume;
@property (nonatomic, retain) NSNumber * sixteenNoteVolume;
@property (nonatomic, retain) NSNumber * trippleNoteVolume;
@property (nonatomic, retain) TempoList *listOwner;
@property (nonatomic, retain) TimeSignatureType *timeSignatureType;
@property (nonatomic, retain) VoiceType *voiceType;

@end
