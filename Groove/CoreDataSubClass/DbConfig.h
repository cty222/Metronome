//
//  DbConfig.h
//  Groove
//
//  Created by C-ty on 2014/9/25.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DbConfig : NSManagedObject

@property (nonatomic, retain) NSNumber * dbVersion;

@end
