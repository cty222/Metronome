//
//  TapFuction.m
//  Groove
//
//  Created by C-ty on 2015/1/27.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "TapFunction.h"

// Private property
@interface TapFunction ()

// Tap Trigger ounter
@property (getter = GetTapTriggerCounter, setter = SetTapTriggerCounter:) int TapTriggerCounter;

@end

@implementation TapFunction
{
    // Tap Fuction
    double _LastRecordTime_ms;
    NSDate * _Date;;
    int _TapTriggerCounter;
    NSMutableArray * _TapQueue;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(TapResetNotificationCallBack:)
                                                     name:kTapResetNotification
                                                   object:nil];
    }
    return self;
}

// =========================
// Property
//
- (int) GetTapTriggerCounter
{
    return _TapTriggerCounter;
}

- (void) SetTapTriggerCounter: (int) NewValue
{
    // TODO: Open A Timer or animation to show Tap icon when Second Tap
    if(NewValue >=1 && NewValue <  [self TapTriggerNumber])
    {
        // check icon
        // Show normal Icon
        self.TapAlertImage.hidden = NO;
    }
    else if (NewValue >= [self TapTriggerNumber])
    {
        // show
        self.TapAlertImage.Mode = TAP_START_RED;
        self.TapAlertImage.hidden = NO;
    }
    else
    {
        // check icon
        // Hidden Icon
        self.TapAlertImage.hidden = YES;
        if (_TapQueue != nil)
        {
            [_TapQueue removeAllObjects];
        }
    }
    
    _TapTriggerCounter = NewValue;
}

//
// =========================

// =========================
// Action
//
- (int) TapTriggerNumber
{
    return 3;
}

- (void) TapAreaBeingTap
{
    if (_Date == nil)
    {
        _Date = [NSDate date];
    }
    
    if (_TapQueue == nil)
    {
        _TapQueue = [[NSMutableArray alloc] init];
    }
    
    if (_LastRecordTime_ms != 0)
    {
        double CurrentRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
        NSNumber *NewBPMvalue = [NSNumber numberWithDouble:((double)60000)/(CurrentRecordTime_ms -_LastRecordTime_ms)];
        
        // 如果速度低於BPMMinValue, 就重算
        if( [NewBPMvalue doubleValue] >= [[GlobalConfig BPMMinValue] intValue])
        {
            // 因為self.TapTriggerCounter = 0不會進來
            // 沒有 _LastRecordTime_ms, 所以實際上記錄的是 1 2 3, 4 5 6
            if (_TapQueue.count < [self TapTriggerNumber])
            {
                [_TapQueue addObject:NewBPMvalue];
            }
            else
            {
                int ObjectIndex = (self.TapTriggerCounter % [self TapTriggerNumber]);
                [_TapQueue replaceObjectAtIndex:ObjectIndex withObject:NewBPMvalue];
                
                // 和上一次Tap成功平均
                self.NewValue = [self GetAvarageTapValue];
                [[NSNotificationCenter defaultCenter] postNotificationName:kTapChangeBPMValue object:nil];
            }
        }
        else
        {
            self.TapTriggerCounter = 0;
        }
    }
    
    _LastRecordTime_ms = [_Date timeIntervalSinceNow] * -1000.0;
    self.TapTriggerCounter++;
}

- (double) GetAvarageTapValue
{
    double ValueSum = 0;
    for(NSNumber *Value in _TapQueue)
    {
        ValueSum += [Value doubleValue];
    }
    return (ValueSum / _TapQueue.count);
}

// If using scroll or single step to change BPM value, need to clean TapTriggerCounter
- (void) TapResetNotificationCallBack :(NSNotification *)Notification
{
    [self TapResetTicker:nil];
}

- (void) TapResetTicker: (NSTimer *) theTimer
{
    if (_Date != nil)
    {
        _Date = nil;
    }
    _LastRecordTime_ms = 0;
    self.TapTriggerCounter = 0;
}



//
// =========================

@end
