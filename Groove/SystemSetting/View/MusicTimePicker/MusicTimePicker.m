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
    NSTimeInterval _MusicDuration;
    NSTimer * _ScollValueUpdateTimer;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(PlayMusicStatusChangedCallBack:)
                                                     name:kPlayMusicStatusChangedEvent
                                                   object:nil];
    }
    return self;
}

- (IBAction) Save: (UIButton *) SaveButton
{
    [self SyncValueFormUIValue];
    [super Save:SaveButton];
}

- (IBAction) Cancel : (UIButton *) CancelButton
{
    [super Cancel:CancelButton];
}

- (IBAction) Listen : (UIButton *) ListenButton
{
    // 播放前要先reset
    if (!gPlayMusicChannel.isPlaying)
    {
        self.ScrollTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:[self GetUIValue]];
    }

    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(Listen:)])
        {
            [self.delegate Listen: ListenButton];
        }
    }
}

- (IBAction)TimeScrollValueChangedByHuman:(id)sender {
    // 這只有手動會進來, 用code改值不會進來
    self.ScrollTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:self.TimeScrollBar.value];
}

- (IBAction)UpdateScrollValueToUIValuePicker:(id)sender {
    [self SetUIValue: self.TimeScrollBar.value];
}

- (NSTimeInterval) GetMusicDuration
{
    return _MusicDuration;
}

- (void)SetMusicDuration:(NSTimeInterval)NewValue
{
    _MusicDuration = NewValue;
    int Minutes = ((int)(_MusicDuration) / 60);
    self.MinuteValuePicker.MaxLimit = Minutes + 0.5;
    
    self.TimeScrollBar.maximumValue = _MusicDuration;
    self.TimeScrollBar.minimumValue = 0.0f;
}

- (NSTimeInterval) GetValue
{
    return ROUND_TWO_DECOMAL_FROM_DOUBLE(_Value);
}

- (void) SetValue: (NSTimeInterval) NewValue
{
    if (self.MusicDuration > 0 && NewValue > self.MusicDuration)
    {
        NewValue = self.MusicDuration;
    }
    _Value = NewValue;

    [self SetUIValue:_Value];
    self.TimeScrollBar.value = _Value;
    self.ScrollTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:_Value];
}

- (void) SetUIValue: (NSTimeInterval) NewValue
{
    int Minutes = ((int)(NewValue) / 60);
    if (Minutes > 60)
    {
        Minutes = 60;
    }
    int Seconds = (int)NewValue % 60;
    int Centiseconds = (int)((NewValue - (int)NewValue) * 100);
    
    
    self.MinuteValuePicker.Value = Minutes;
    self.SecondValuePicker.Value = Seconds;
    self.CentisecondsPicker.Value = Centiseconds;
}

- (NSTimeInterval) GetUIValue
{
    NSTimeInterval TempValue = ((int)self.MinuteValuePicker.Value * 60 + (int)self.SecondValuePicker.Value + self.CentisecondsPicker.Value/100);
    return TempValue;
}

- (void) SyncValueFormUIValue
{
    self.Value = [self GetUIValue];
}


- (NSString *) ReturnCurrentValueString
{
    int Minutes = ((int)(self.Value) / 60);
    if (Minutes > 60)
    {
        Minutes = 60;
    }
    
    int Seconds = (int)self.Value % 60;
    int Centiseconds = floorf(((self.Value - floorf(self.Value)) * 100));
    
    NSString * ReturnStr = [NSString stringWithFormat:@"%02d:%02d.%02d", Minutes, Seconds, Centiseconds];
    
    return ReturnStr;
}

// =======================
// Timer
//
- (void) PlayMusicStatusChangedCallBack:(NSNotification *)Notification
{
    if ([gPlayMusicChannel isPlaying])
    {
        [self StartScollValueUpdateTimer];
    }
    else
    {
        [self StopScollValueUpdateTimer];
    }
}

- (void) StopScollValueUpdateTimer
{
    [_ScollValueUpdateTimer invalidate];
    _ScollValueUpdateTimer = nil;
}

- (void) StartScollValueUpdateTimer
{
    if(_ScollValueUpdateTimer != nil)
    {
        [self StopScollValueUpdateTimer];
    }
    
    [self ScollValueUpdateTicker: nil];
    
    _ScollValueUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(ScollValueUpdateTicker:)
                                                            userInfo:nil
                                                             repeats:YES];
}

- (void) ScollValueUpdateTicker: (NSTimer *) ThisTimer
{
    if (![gPlayMusicChannel isPlaying])
    {
        [ThisTimer invalidate];
        return;
    }
    self.TimeScrollBar.value = gPlayMusicChannel.CurrentTime;
    self.ScrollTimeLabel.text = [gPlayMusicChannel ReturnTimeValueToString:gPlayMusicChannel.CurrentTime];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
