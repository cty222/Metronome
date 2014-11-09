//
//  UINSOperation.m
//  Groove
//
//  Created by C-ty on 2014/11/9.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "UINSOperation.h"

@implementation UINSOperation
{
    
}

- (id) initWithNumber: (NSInteger) sn
{
    if ((self = [super init]) != nil)
    {
        self.number = sn;
        self.interval = (double) (random() & 0x7f);
    }
    
    return self;
}

- (void) main {
    NSLog(@"Operation number: %ld", (long)self.number);
}
@end
