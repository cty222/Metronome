//
//  NameEditer.m
//  Groove
//
//  Created by C-ty on 2015/1/2.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "NameEditer.h"

@implementation NameEditer
{
    UIAlertView * _NameErrorAlert;
    UIAlertView * _NameTooLongAlert;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.NowTitle.textColor = [UIColor whiteColor];
        self.CurrentName.textColor = [UIColor whiteColor];
        self.NewTitle.textColor = [UIColor whiteColor];

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)TextFieldEnd:(UITextField *)sender {
    // 要打開才有用
}

- (IBAction)Save:(id)sender {
    if (self.NewName.text == nil || [self.NewName.text isEqualToString:@""])
    {
        if (_NameErrorAlert == nil)
        {
            _NameErrorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Name Error"
                               message:@"No Name !!"
                               delegate:nil
                               cancelButtonTitle:@"OK, I know it."
                               otherButtonTitles:nil, nil];
        }
        [_NameErrorAlert show];
        
        return;
    }
    
    if ([self.NewName.text length] >= 25)
    {
        if (_NameTooLongAlert == nil)
        {
            _NameTooLongAlert = [[UIAlertView alloc]
                               initWithTitle:@"Name Error"
                               message:@"Name is too long, it can't over 25 character."
                               delegate:nil
                               cancelButtonTitle:@"OK, I know it."
                               otherButtonTitles:nil, nil];
        }
        [_NameTooLongAlert show];
        return;
    }

    
    [super Save:sender];
}


@end
