//
//  MusicTimePicker.m
//  Groove
//
//  Created by C-ty on 2014/12/19.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MusicTimePicker.h"
#import "PlayerForSongs.h"

@implementation MusicTimePicker
{
    NSTimeInterval _Value;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.HourValuePicker removeFromSuperview];
        self.HourValuePicker = [[SmallLeftValuePicker alloc] initWithFrame:self.HourValuePicker.frame];
        [self addSubview:self.HourValuePicker];
        self.HourValuePicker.MaxLimit = 24;
        self.HourValuePicker.MinLimit = 0;
        
        [self.MinuteValuePicker removeFromSuperview];
        self.MinuteValuePicker = [[SmallLeftValuePicker alloc] initWithFrame:self.MinuteValuePicker.frame];
        [self addSubview:self.MinuteValuePicker];
        self.MinuteValuePicker.MaxLimit = 60;
        self.MinuteValuePicker.MinLimit = 0;
        
        [self.SecondValuePicker removeFromSuperview];
        self.SecondValuePicker = [[SmallLeftValuePicker alloc] initWithFrame:self.SecondValuePicker.frame];
        [self addSubview:self.SecondValuePicker];
        self.SecondValuePicker.MaxLimit = 60;
        self.SecondValuePicker.MinLimit = 0;


    }
    return self;
}


- (IBAction) Save: (UIButton *) SaveButton
{
    [self SyncUIValue];
    [super Save:SaveButton];
}

- (IBAction) Cancel : (UIButton *) CancelButton
{
    [super Cancel:CancelButton];
}

- (IBAction)PlayMusic: (UIButton *) PlayButton
{
    if (gPlayMusicChannel.Playing)
    {
        [gPlayMusicChannel Stop];
    }
    else
    {
        [gPlayMusicChannel Play];
    }
    
    if (gPlayMusicChannel.Playing)
    {
        [PlayButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    }
    else
    {
        [PlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (NSTimeInterval) GetValue
{
    return _Value;
}

- (void) SetValue: (NSTimeInterval) NewValue
{
    NSLog(@"SetValue!!!");
    _Value = NewValue;
    int Hours = (_Value / 60) / 60;
    int Minutes = (int)(self.Value - Hours * 60 * 60) / 60;
    int Seconds = (int)self.Value % 60;
    
    self.HourValuePicker.Value = Hours;
    self.MinuteValuePicker.Value = Minutes;
    self.SecondValuePicker.Value = Seconds;
}

- (void) SyncUIValue
{
    _Value = ((int)self.HourValuePicker.Value * 60 * 60 + (int)self.MinuteValuePicker.Value * 60 + (int)self.SecondValuePicker.Value);
    NSLog(@"%f",_Value);

}

- (NSString *) ReturnCurrentValueString
{

    int Hours =  (self.Value / 60) / 60;
    int Minutes = (int)(self.Value - Hours * 60 * 60) / 60;
    int Seconds = (int)self.Value % 60;

    NSString * ReturnStr = [NSString stringWithFormat:@"%d:%02d:%02d",Hours, Minutes, Seconds];
    
    return ReturnStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
