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
    __block NSInteger _SubView_F4_degree;
    
    BOOL _Touched;
    CGPoint OriginalLocation;
    
    float _IndexValue;

    NSUInteger _IndexValueSensitivity;
    
    NSTimer *_TouchedTimer;
    
    CIRCLEBUTTON_RANGE _IndexRange;
    
    NSOperationQueue * _Queue;
    NSBlockOperation * RoundingOperation;

    
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

-(void) Initialize
{
    // Default Valeu
    _Queue = [[NSOperationQueue alloc] init];
    _SubView_F4_degree = 0;
    _IndexRange.MaxIndex = CIRCLE_DEFAULT_MAX_VALUE;
    _IndexRange.MinIndex = CIRCLE_DEFAULT_MIN_VALUE;
    
    // reset to default state
    [self FlipAnimation];
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:@"NewCircle_F1"] drawInRect:self.bounds];
    _ImageMask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.SubView_Frame2_BlockValue.backgroundColor = [UIColor colorWithPatternImage:_ImageMask];
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

- (void) ValueColorChangeWithIndexValue
{
    NSUInteger Scale = self.IndexRange.MaxIndex - self.IndexRange.MinIndex;
    if (Scale == 0) {
        Scale = 1;
    }
    
    double DisplayPersentage = (double)(self.IndexValue - self.IndexRange.MinIndex)/ (double) Scale;
    
    self.SubView_Frame2_BlockValue.frame = CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height * (1 - DisplayPersentage));
    
}

- (CIRCLEBUTTON_RANGE) GetIndexRange
{
    return _IndexRange;
}

- (void) SetIndexRange:(CIRCLEBUTTON_RANGE) NewValue
{
    if (NewValue.MaxIndex < NewValue.MinIndex)
    {
        NewValue.MaxIndex = NewValue.MinIndex;
    }
    
    if (NewValue.MaxIndex == 0)
    {
        NewValue.MaxIndex = CIRCLE_DEFAULT_MAX_VALUE;
    }
    
    if (NewValue.UnitValue > NewValue.MaxIndex - NewValue.MinIndex)
    {
        NewValue.UnitValue = NewValue.MaxIndex - NewValue.MinIndex;
    }
    
    _IndexRange = NewValue;
}

- (double) GetIndexValueSensitivity
{
    if (_IndexValueSensitivity<= 0)
    {
        _IndexValueSensitivity = 1;
    }
    return _IndexValueSensitivity;
}

-(void) SetIndexValueSensitivity: (double) NewValue
{
    _IndexValueSensitivity = NewValue;
}

-(float) GetIndexValue
{
    return _IndexValue;
}

-(void) SetIndexValue: (float) NewValue
{
    
    if (NewValue > self.IndexRange.MaxIndex)
    {
        NewValue = self.IndexRange.MaxIndex;
    }
    else if (NewValue < self.IndexRange.MinIndex)
    {
        NewValue = self.IndexRange.MinIndex;
    }
        
    _IndexValue = NewValue;
    
    [self ValueColorChangeWithIndexValue];
    [self.ValueLabel setText:[NSString stringWithFormat:@"%0.1f", _IndexValue]];
    
    [self CircleButtonValueChanged: self];
}

-(void) SetTouched: (BOOL) NewValue
{
    _Touched = NewValue;
    if (_Touched)
    {
        // 如果觸碰
        // 最內環會變大, 便最外環
        // 不用animate 是因為動作設不快???
        // 翻轉文字_顯示, 放大在反轉完成之後
        [self FlipAnimation];
    }
    else
    {
        
        // 如果結束觸碰
        // 最內環會變轉正, 之後再縮小.
        [self RoundingAnimationStop];

    }
}

- (BOOL) GetTouched
{
    return _Touched;
}

- (void) FlipAnimation
{
    if (self.Touched) {
        [UIView transitionFromView:self.SignPicture toView:self.ValueLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            if (self.Touched)
                            {
                                // 放大在反轉完成之後
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
                        }];
    }
    else {
        [UIView transitionFromView:self.ValueLabel toView:self.SignPicture
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
    }
}

- (void) TouchedOpen: (NSTimer *) ThisTimer
{
    if (!self.Touched)
    {
        return;
    }
    
    // 放大
    if (self.SubView_Frame4.frame.origin.x > -1 * (self.frame.size.width /2))
    {
        self.SubView_Frame4.frame = CGRectMake( self.SubView_Frame4.frame.origin.x - 1,
                                            self.SubView_Frame4.frame.origin.y - 1,
                                            self.SubView_Frame4.frame.size.width + 2,
                                            self.SubView_Frame4.frame.size.height + 2
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

        [self RoundingAnimationStart];

    }
}

- (void) TouchedClose: (NSTimer *) ThisTimer
{
    if (self.Touched)
    {
        return;
    }
    
    // 縮小
    if (self.SubView_Frame4.frame.origin.x < 0)
    {
        self.SubView_Frame4.frame = CGRectMake( self.SubView_Frame4.frame.origin.x + 1,
                                           self.SubView_Frame4.frame.origin.y + 1,
                                           self.SubView_Frame4.frame.size.width - 2,
                                           self.SubView_Frame4.frame.size.height - 2
                                           );
    }
    else
    {
        // 翻轉文字_顯示
        [self FlipAnimation];

        
        if (_TouchedTimer != nil)
        {
            [_TouchedTimer invalidate];
            _TouchedTimer = nil;
        }
    }
}

- (void) RoundingAnimationStart
{
    [UIView animateWithDuration:0.005
                          delay:0.01
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self RotationChange :self.SubView_Frame4 Degree : (float) _SubView_F4_degree];
                     }
                     completion:^(BOOL finished){
                         if (self.Touched){
                             _SubView_F4_degree += ROUNDING_START_SENSITIVITY;
                             [self RoundingAnimationStart];
                         }
                     }];
}

- (void) RoundingAnimationStop
{
    [UIView animateWithDuration:0.005
                          delay:0.0001
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self RotationChange :self.SubView_Frame4 Degree : (float) _SubView_F4_degree];
                     }
                     completion:^(BOOL finished){
                         if (!self.Touched){
                             if ((_SubView_F4_degree % HALF_CIRCLE_DEGREE) == 0)
                             {
                                 _SubView_F4_degree = 0;
                                 //當轉正完成, 就會開始縮小
                                 if (_TouchedTimer != nil)
                                 {
                                     [_TouchedTimer invalidate];
                                     _TouchedTimer = nil;
                                 }
                                 _TouchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                                                  target:self
                                                                                selector:@selector(TouchedClose:)
                                                                                userInfo:nil
                                                                                 repeats:YES];
                             }
                             else
                             {
                                 if (_SubView_F4_degree % ROUNDING_BACK_SENSITIVITY)
                                 {
                                     _SubView_F4_degree -= _SubView_F4_degree % ROUNDING_BACK_SENSITIVITY;
                                 }
                                 _SubView_F4_degree -= ROUNDING_BACK_SENSITIVITY;
                                 [self RoundingAnimationStop];
                             }
                         }
                     }];
}
#if 0
- (void) OperationRounding
{
    //if (RoundingOperation == nil)
    {
        RoundingOperation = [[NSBlockOperation alloc] init];
        [RoundingOperation setThreadPriority:1];
        [RoundingOperation addExecutionBlock:^{
            __block int TestCounter;
            TestCounter = 0;
            while (self.Touched) {
                _SubView_F4_degree += ROUNDING_START_SENSITIVITY;
                float rad = ((float)_SubView_F4_degree/ (float)HALF_CIRCLE_DEGREE )*M_PI;
                CGAffineTransform rotation = CGAffineTransformMakeRotation(rad);
                [self.SubView_F4.layer setAffineTransform:rotation];
            }
        }];
        
        [_Queue addOperation:RoundingOperation];
    }
}
#endif


- (void) RotationChange :(UIView *) TargetView Degree : (float) Degree
{
    if (TargetView == nil)
    {
        return;
    }
    
    float rad = ((float)Degree/ (float)HALF_CIRCLE_DEGREE) *M_PI;
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
        int MoveUp = (double)(OriginalLocation.y - TouchLocation.y) / (double)self.IndexValueSensitivity;
        if (MoveUp != 0)
        {
           self.IndexValue += (float)MoveUp * self.IndexRange.UnitValue;
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

- (IBAction) CircleButtonValueChanged:(CircleButton*) ThisCircleButton;
{
    // Pass to parent view.
    if (self.delegate != nil)
    {
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(CircleButtonValueChanged:)])
        {
            [self.delegate CircleButtonValueChanged: ThisCircleButton];
        }
    }
}

#if 0
// 如果開animate, Close 也要用 不然會有bug
- (void) AnimationTouchedOpen
{
    [UIView animateWithDuration:0.03
                          delay:0
                        options: 0
                     animations:^{
                         self.SubView_F4.frame = CGRectMake( self.SubView_F4.frame.origin.x -1,
                                                            self.SubView_F4.frame.origin.y -1,
                                                            self.SubView_F4.frame.size.width + 2,
                                                            self.SubView_F4.frame.size.height + 2
                                                            );
                     }
                     completion:^(BOOL finished){
                         if (self.Touched)
                         {
                             if (self.SubView_F4.frame.origin.x > -1 * (self.frame.size.width /2)) {
                                 [self AnimationTouchedOpen];
                             }
                             else
                             {
                                 [self RoundingAnimationStart];
                             }
                         }
                         else
                         {
                             [self RoundingAnimationStop];
                             
                         }
                         
                     }];
}
#endif
@end
