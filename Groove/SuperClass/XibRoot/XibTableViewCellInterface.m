//
//  XibTableViewCellInterface.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/8/2.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "XibTableViewCellInterface.h"

@implementation XibTableViewCellInterface

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) init {
    self = [super init];
    
    if (self)
    {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        
        NSArray* array;
        array = [nib instantiateWithOwner:nil
                                  options:nil];
        self = [array lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
