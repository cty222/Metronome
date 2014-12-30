//
//  BundleGrooveCell.m
//  Metronome_Ver1
//
//  Created by C-ty on 2014/8/21.
//  Copyright (c) 2014年 C-ty. All rights reserved.
//

#import "TempoListUICell.h"

@implementation TempoListUICell
{
    TempoList *_TempoList;
}
// Init and System
- (void)awakeFromNib
{
    // Initialization code
    //self.DeleteCellButton.hidden = YES;

}

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/

// ========================================
// property
//
-(TempoList *) GetTempoList
{
    return _TempoList;
}

-(void) SetTempoList : (TempoList *) NewTempoList
{
    _TempoList = NewTempoList;
    self.textLabel.text = _TempoList.tempoListName;
}
//
// ========================================

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)Delete:(UIButton *)DeleteSelfButton {
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(DeleteCell:)])
        {
            [self.delegate DeleteCell: self];
        }
    }
}

/*- (IBAction)DeleteEnbale:(UISwitch *)sender {
    if (sender.isOn)
    {
        if (self.DeleteCellButton.hidden == NO)
        {
            return;
        }
        
        CGRect CurrentLebalFrame = self.LblName.frame;
        self.LblName.frame = CGRectMake(CurrentLebalFrame.origin.x,
                                        CurrentLebalFrame.origin.y,
                                        190 ,
                                        CurrentLebalFrame.size.height);
        self.DeleteCellButton.hidden = NO;
    }
    else
    {
        if (self.DeleteCellButton.hidden == YES)
        {
            return;
        }
        
        CGRect CurrentLebalFrame = self.LblName.frame;
        self.LblName.frame = CGRectMake(CurrentLebalFrame.origin.x,
                                        CurrentLebalFrame.origin.y,
                                        250 ,
                                        CurrentLebalFrame.size.height);
        self.DeleteCellButton.hidden = YES;

    }
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
