//
//  LocalizedMutilanguage.h
//  Groove
//
//  Created by C-ty on 2015/1/29.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalStringSync(x,y) [LocalizedMutilanguage LocalizedMutilanguage:(x) replaceValue:(y)]

@interface LocalizedMutilanguage : NSObject
+ (NSString *)LocalizedMutilanguage:(NSString *)key replaceValue:(NSString *)comment;

@end
