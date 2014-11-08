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
    UIImage * _ImageMask;
    NSInteger _SubView_F4_degree;
    
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
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:@"NewCircle_F1"] drawInRect:self.bounds];
    _ImageMask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.SubView_F2_ValueHide.backgroundColor = [UIColor colorWithPatternImage:_ImageMask];
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
        // 如果觸碰
        // 最內環會變大, 便最外環
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
        _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                             target:self
                                                           selector:@selector(TouchedOpen:)
                                                           userInfo:nil
                                                            repeats:YES];
    }
    else
    {
        // 如果結束觸碰
        // 最內環會變轉正, 之後再縮小.
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
        _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                         target:self
                                                       selector:@selector(RoundingStart:)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) TouchedOpen: (NSTimer *) ThisTimer
{

    if (self.SubView_F4.frame.origin.x > -1 * (self.frame.size.width /2))
    {
        self.SubView_F4.frame = CGRectMake( self.SubView_F4.frame.origin.x -1,
                                            self.SubView_F4.frame.origin.y -1,
                                            self.SubView_F4.frame.size.width + 2,
                                            self.SubView_F4.frame.size.height + 2
                                           );
    }
    else
    {
        //當變大完成, 就會開始旋轉
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
        _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(RoundingStart:)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

- (void) TouchedClose: (NSTimer *) ThisTimer
{
    if (self.SubView_F4.frame.origin.x < 0)
    {
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

- (void) RoundingStart: (NSTimer *) ThisTimer
{

    if (self.Touched)
    {
        _SubView_F4_degree += ROUNDING_START_SENSITIVITY;
        [self RotationChange:self.SubView_F4 Degree:(float)_SubView_F4_degree];
    }
    else
    {
        if (_SubView_F4_degree % ROUNDING_BACK_SENSITIVITY)
        {
            _SubView_F4_degree -= _SubView_F4_degree % ROUNDING_BACK_SENSITIVITY;
        }
        _SubView_F4_degree -= ROUNDING_BACK_SENSITIVITY;
        [self RotationChange:self.SubView_F4 Degree:(float)_SubView_F4_degree];
        if ((_SubView_F4_degree % 180) == 0)
        {
            //當轉正完成, 就會開始縮小
            if (_TouchedTimer != nil)
            {
                [_TouchedTimer invalidate];
                _TouchedTimer = nil;
            }
            _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                         target:self
                                                       selector:@selector(TouchedClose:)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }
}

- (void) RotationChange :(UIView *) TargetView Degree : (float) Degree
{
    if (TargetView == nil)
    {
        return;
    }
    
    float rad = Degree/ 180.0 *M_PI;
    CGAffineTransform rotation = CGAffineTransformMakeRotation(rad);
    [TargetView.layer setAffineTransform:rotation];

}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
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
