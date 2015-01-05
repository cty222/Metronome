//
//  NameEditer.m
//  Groove
//
//  Created by C-ty on 2015/1/2.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "NameEditer.h"

@interface NameEditer ()
@property (strong, nonatomic) IBOutlet UILabel *NowTitle;
@property (strong, nonatomic) IBOutlet UILabel *NewTitle;
@property (strong, nonatomic) IBOutlet UILabel *AlertTextLabel;

@end

@implementation NameEditer
{
    TempoList *_TempoList;

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
        self.AlertTextLabel.textColor = [UIColor whiteColor];
        
        [self LocalizedStringInitialize];
    }
    return self;
}

- (void) LocalizedStringInitialize
{
    self.NewTitle.text = NSLocalizedString(@"Edit: ", nil);
    self.NowTitle.text = NSLocalizedString(@"New: ", nil);
    self.AlertTextLabel.text = NSLocalizedString(@"(25 charactors max)", nil);
    [self.SaveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [self.CancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
}

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

    if (NewTempoList != nil)
    {
        self.NewName.text = _TempoList.tempoListName;
        self.CurrentName.text = _TempoList.tempoListName;
    }
    else
    {
        self.CurrentName.text = NSLocalizedString(@"None", nil);
        self.NewName.text = @"";
    }
}
//
// ========================================

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
