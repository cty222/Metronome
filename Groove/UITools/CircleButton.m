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
    UIImage * _ValueColorBackGroundImage;
    UIImage * _FrontBackGroundImage;
    
    BOOL _Touched;
    CGPoint OriginalLocation;
    
    NSUInteger _IndexValue;
    NSMutableArray * _DataStringArray;

    
    NSUInteger _Sensitivity;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

-(void) Initialize
{
    _DataStringArray = nil;
    
    
    // red  playloop button
    UIGraphicsBeginImageContext(self.BackView.frame.size);
    [[UIImage imageNamed:@"LoopPlay_red"] drawInRect:self.BackView.bounds];
    _ValueColorBackGroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.BackView.backgroundColor = [UIColor colorWithPatternImage:_ValueColorBackGroundImage];
    
    // bloak  playloop button
    UIGraphicsBeginImageContext(self.FrontView.frame.size);
    [[UIImage imageNamed:@"LoopPlay_black"] drawInRect:self.FrontView.bounds];
    _FrontBackGroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.FrontView.backgroundColor = [UIColor colorWithPatternImage:_ValueColorBackGroundImage];
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
    
    double DisplayPersentage = (double)self.IndexValue / (double) Scale;
    
    self.BackView.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * (1 - DisplayPersentage));

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

-(NSUInteger) GetIndexValue
{
    return _IndexValue;
}

-(void) SetIndexValue: (NSUInteger) NewValue
{
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
    NSLog(@"NewValue : %tu", _IndexValue);
    
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

    }
    else
    {

    }
}
- (BOOL) GetTouched
{
    return _Touched;
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
