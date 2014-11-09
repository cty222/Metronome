//
//  UINSOperation.h
//  Groove
//
//  Created by C-ty on 2014/11/9.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINSOperation : NSOperation
@property NSInteger number;
@property NSTimeInterval interval;

- (id) initWithNumber: (NSInteger) sn;

@end
