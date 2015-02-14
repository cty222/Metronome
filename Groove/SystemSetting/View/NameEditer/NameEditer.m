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

    self.AlertTextLabel.text = LocalStringSync(@"(25 charactors max)", nil);
    [self.SaveButton setTitle:LocalStringSync(@"Save", nil) forState:UIControlStateNormal];
    [self.CancelButton setTitle:LocalStringSync(@"Cancel", nil) forState:UIControlStateNormal];
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
        self.NewTitle.text = LocalStringSync(@"Edit: ", nil);
        self.NowTitle.text = LocalStringSync(@"Now: ", nil);
        self.NewName.text = _TempoList.tempoListName;
        self.CurrentName.text = _TempoList.tempoListName;
    }
    else
    {
        self.NewTitle.text = LocalStringSync(@"New: ", nil);
        self.NowTitle.text = LocalStringSync(@"Now: ", nil);
        self.CurrentName.text = LocalStringSync(@"None", nil);
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
                               initWithTitle:LocalStringSync(@"Name Error", nil)
                               message:LocalStringSync(@"No Name !!", nil)
                               delegate:nil
                               cancelButtonTitle:LocalStringSync(@"OK, I know it.", nil)
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
                               initWithTitle:LocalStringSync(@"Name Error", nil)
                               message:LocalStringSync(@"Name is too long, it can't over 25 character.", nil)
                               delegate:nil
                               cancelButtonTitle:LocalStringSync(@"OK, I know it.", nil)
                               otherButtonTitles:nil, nil];
        }
        [_NameTooLongAlert show];
        return;
    }

    
    [super Save:sender];
}


@end
