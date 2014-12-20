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
        [self.MinuteValuePicker removeFromSuperview];
        self.MinuteValuePicker = [[TwoDigitsValuePicker alloc] initWithFrame:self.MinuteValuePicker.frame];
        [self addSubview:self.MinuteValuePicker];
        self.MinuteValuePicker.MaxLimit = 99;
        self.MinuteValuePicker.MinLimit = 0;
        
        [self.SecondValuePicker removeFromSuperview];
        self.SecondValuePicker = [[TwoDigitsValuePicker alloc] initWithFrame:self.SecondValuePicker.frame];
        [self addSubview:self.SecondValuePicker];
        self.SecondValuePicker.MaxLimit = 59;
        self.SecondValuePicker.MinLimit = 0;

        [self.CentisecondsPicker removeFromSuperview];
        self.CentisecondsPicker = [[TwoDigitsValuePicker alloc] initWithFrame:self.CentisecondsPicker.frame];
        [self addSubview:self.CentisecondsPicker];
        self.CentisecondsPicker.MaxLimit = 99;
        self.CentisecondsPicker.MinLimit = 0;
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
    int Minutes = ((int)(self.Value) / 60);
    if (Minutes > 60)
    {
        Minutes = 60;
    }
    int Seconds = (int)self.Value % 60;
    int Centiseconds = (int)((self.Value - (int)self.Value) * 100);

    
    self.MinuteValuePicker.Value = Minutes;
    self.SecondValuePicker.Value = Seconds;
    self.CentisecondsPicker.Value = Centiseconds;

}

- (void) SyncUIValue
{
    _Value = ((int)self.MinuteValuePicker.Value * 60 + (int)self.SecondValuePicker.Value + self.CentisecondsPicker.Value/100);
    NSLog(@"%f",_Value);

}

- (NSString *) ReturnCurrentValueString
{
    int Minutes = ((int)(self.Value) / 60);
    if (Minutes > 60)
    {
        Minutes = 60;
    }
    
    int Seconds = (int)self.Value % 60;
    int Centiseconds = (int)((self.Value - (int)self.Value) * 100);
    
    NSString * ReturnStr = [NSString stringWithFormat:@"%02d:%02d.%02d", Minutes, Seconds, Centiseconds];
    
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
