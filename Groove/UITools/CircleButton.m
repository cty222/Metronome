//
//  CircleButton.m
//  Groove
//
//  Created by C-ty on 2014/11/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton
{
    UIImage * _ImageFrame1;
    UIImage * _ImageFrame2;
    UIImage * _ImageFrame3;
    UIImage * _ImageFrame4;
    UIImage * _ImageFrame4Touched;

    
    BOOL _Touched;
    CGPoint OriginalLocation;
    
    NSUInteger _IndexValue;
    NSMutableArray * _DataStringArray;

    NSUInteger _Sensitivity;
    NSTimer *_TouchedTimer;

}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

-(void) Initialize
{
    _DataStringArray = nil;
    
    UIGraphicsBeginImageContext(self.SubView_F1.frame.size);
    [[UIImage imageNamed:@"NewCircle_F1"] drawInRect:self.SubView_F1.bounds];
    _ImageFrame1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.SubView_F1.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame1];
    
    UIGraphicsBeginImageContext(self.SubView_F2_Value.frame.size);
    [[UIImage imageNamed:@"NewCircle_F2"] drawInRect:self.SubView_F2_Value.bounds];
    _ImageFrame2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.SubView_F2_Value.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame2];
    self.SubView_F2_ValueHide.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame1];

    
    UIGraphicsBeginImageContext(self.SubView_F3.frame.size);
    [[UIImage imageNamed:@"NewCircle_F3"] drawInRect:self.SubView_F3.bounds];
    _ImageFrame3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.SubView_F3.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame3];
    
    UIGraphicsBeginImageContext(self.SubView_F4.frame.size);
    [[UIImage imageNamed:@"NewCircle_F4"] drawInRect:self.SubView_F4.bounds];
    _ImageFrame4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.SubView_F4.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame4];
    
    UIGraphicsBeginImageContext(CGSizeMake(120, 120));
    [[UIImage imageNamed:@"NewCircle_F4"] drawInRect:CGRectMake(0, 0, 120, 120)];
    _ImageFrame4Touched = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self bringSubviewToFront:self.SubView_F3];
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self Initialize];

    }
    
    return self;
}

// TODO : 
- (void) ValueColorChangeWithIndexValue
{
    NSUInteger Scale = self.MaxIndex - self.MinIndex;
    if (Scale == 0) {
        Scale = 1;
    }
    
    double DisplayPersentage = (double)(self.IndexValue - self.MinIndex)/ (double) Scale;
    
    self.SubView_F2_ValueHide.frame = CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height * (1 - DisplayPersentage));
    
}

- (double) GetSensitivity
{
    if (_Sensitivity<= 0)
    {
        _Sensitivity = 1;
    }
    return _Sensitivity;
}

-(void) SetSensitivity: (double) NewValue
{
    _Sensitivity = NewValue;
}

-(NSInteger) GetIndexValue
{
    return _IndexValue;
}

-(void) SetIndexValue: (NSInteger) NewValue
{
    NSLog(@"Set New IndexValue %ld", (long)NewValue);
    if (self.GetDataStringArray != nil)
    {
        self.MinIndex = 0;
        self.MaxIndex = self.GetDataStringArray.count - 1;
    }
    
    if (self.MaxIndex < self.MinIndex)
    {
        self.MaxIndex = self.MinIndex;
    }
    
    if (NewValue > self.MaxIndex)
    {
        NewValue = self.MaxIndex;
    }
    else if (NewValue < self.MinIndex)
    {
        NewValue = self.MinIndex;
    }
        
    _IndexValue = NewValue;
    
    [self ValueColorChangeWithIndexValue];
}


-(void) SetDataStringArray: (NSMutableArray *) NewValue
{
    _DataStringArray = NewValue;
    self.IndexValue = 0;
}

- (NSMutableArray *) GetDataStringArray
{
    return _DataStringArray;
}

-(void) SetTouched: (BOOL) NewValue
{
    _Touched = NewValue;
    if (_Touched)
    {
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
        _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                             target:self
                                                           selector:@selector(TouchedOpen:)
                                                           userInfo:nil
                                                            repeats:YES];
        self.SubView_F4.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame4Touched];

    }
    else
    {
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
        _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                             target:self
                                                           selector:@selector(TouchedClose:)
                                                           userInfo:nil
                                                            repeats:YES];
        self.SubView_F4.backgroundColor = [UIColor colorWithPatternImage:_ImageFrame4];
    }
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) TouchedOpen: (NSTimer *) ThisTimer
{
    if (self.SubView_F4.frame.origin.x > -30)
    {
        //self.SubView_F4.frame = CGRectMake( -30, -30, 120, 120);
        self.SubView_F4.frame = CGRectMake( self.SubView_F4.frame.origin.x -1,
                                            self.SubView_F4.frame.origin.y -1,
                                            self.SubView_F4.frame.size.width + 2,
                                            self.SubView_F4.frame.size.height + 2
                                           );
    }
    else
    {
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
    }
}

- (void) TouchedClose: (NSTimer *) ThisTimer
{
    if (self.SubView_F4.frame.origin.x < 0)
    {
        //self.SubView_F4.frame = CGRectMake( 0 , 0, 60, 60);
        self.SubView_F4.frame = CGRectMake( self.SubView_F4.frame.origin.x +1,
                                           self.SubView_F4.frame.origin.y +1,
                                           self.SubView_F4.frame.size.width - 2,
                                           self.SubView_F4.frame.size.height - 2
                                           );
    }
    else
    {
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"123456789");
    OriginalLocation = [self GetLocationPoint: touches];

    self.Touched = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.Touched = NO;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.Touched)
    {
        CGPoint TouchLocation = [self GetLocationPoint: touches];
        // Because zero point is on left top, large point in on right bottom
        int MoveUp = (double)(OriginalLocation.y - TouchLocation.y) / (double)self.Sensitivity;
        if (MoveUp != 0)
        {
            self.IndexValue += MoveUp;
            OriginalLocation = TouchLocation;
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   self.Touched = NO; 
}

- (CGPoint) GetLocationPoint: (NSSet*)touches
{
    UITouch *Touch =  [touches anyObject];
    return [Touch locationInView:Touch.view];
}
@end
