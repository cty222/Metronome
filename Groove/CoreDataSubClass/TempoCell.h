//
//  TempoCell.h
//  Groove
//
//  Created by C-ty on 2014/9/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TempoList, TimeSignatureType;

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

@end
