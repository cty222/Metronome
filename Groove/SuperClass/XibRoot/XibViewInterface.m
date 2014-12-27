//
//  XibViewInterface.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/7/12.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "XibViewInterface.h"

@implementation XibViewInterface
{
    UINib* _ThisNib;
    dispatch_once_t _ThisNibToken;
}

// =============================
// Discription: 
// 1. Using Alloc
// 2. Using init or initWithFrame
// 3. When call instantiateWithOwner will entering initWithCoder
// 4. After finish initWithCoder will call awakeFromNib
// 5. After finish instantiateWithOwner will get all UIViews in nib's
// 6. If We just have one UIView in nib, we can get it by using lastObject
// 7. If we using initWithFrame, we need to set frame and bound with correct size and location.
// =============================
- (UINib*) ThisNib
{
    dispatch_once(&_ThisNibToken, ^{
        _ThisNib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    });
    
    return _ThisNib;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
}

- (id) init {
    self = [super init];
    if (self)
    {
        NSArray* array;
        array = [[self ThisNib] instantiateWithOwner:nil
                                  options:nil];
        self = [array lastObject];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        // Initialization code
        NSArray* UIViewsInNibArray = [[self ThisNib] instantiateWithOwner:nil
                                  options:nil];

        self = [UIViewsInNibArray lastObject];
        self.frame = frame;
        self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
