//
//  CircleButton.m
//  Groove
//
//  Created by C-ty on 2014/11/7.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "CircleButton.h"
#import <QuartzCore/QuartzCore.h>

@interface CircleButton ()
@property (strong, nonatomic) IBOutlet UIView *subView4;
@property (strong, nonatomic) IBOutlet UIView *subView3;
@property (strong, nonatomic) IBOutlet UIView *subView2MiddleBlockValue;
@property (strong, nonatomic) IBOutlet UIView *subView1RedValue;
@property (strong, nonatomic) IBOutlet UIView *subViewFrame0;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewChangeSizeCircle;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewInnerBlackCircle;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewRedValue;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOuterBlackCircle;

@property (getter = getTouched, setter = setTouched:) BOOL touched;

@end

@implementation CircleButton
{
    UIImage * _imageMask;
    __block NSInteger _subView_F4_degree;
    
    CGPoint _originalLocation;
    
    NSTimer *_touchedTimer;
        
    NSOperationQueue * _queue;
}
@synthesize indexValue = _indexValue;
@synthesize indexRange = _indexRange;
@synthesize indexValueSensitivity = _indexValueSensitivity;
@synthesize touched = _touched;

- (void) awakeFromNib
{
    [super awakeFromNib];
}

-(void) initialize
{
    // Default Value
    _queue = [[NSOperationQueue alloc] init];
    _subView_F4_degree = 0;
    self.twickPicture.hidden = YES;
    _indexRange.maxIndex = CIRCLE_DEFAULT_MAX_VALUE;
    _indexRange.minIndex = CIRCLE_DEFAULT_MIN_VALUE;
    
    // reset to default state
    [self flipAnimation];
    
    // Need this, Important
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:@"NewCircle_F1"] drawInRect:self.bounds];
    _imageMask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.subView2MiddleBlockValue.backgroundColor = [UIColor colorWithPatternImage:_imageMask];
    
    CircleButtonRange volumeRange = {
        .maxIndex = 10.0, 
        .minIndex = 0, 
        .unitValue = 0.1
    };
    
    self.indexRange = volumeRange;
    self.indexValueSensitivity = 1;
        
}

- (id)initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self){
       [self initialize]; 
    }
    return self;
}

- (void) valueColorChangeWithIndexValue
{
    NSUInteger scale = self.indexRange.maxIndex - self.indexRange.minIndex;
    if (scale == 0) {
        scale = 1;
    }
    
    double displayPersentage = (double)(self.indexValue - self.indexRange.minIndex)/ (double) scale;
    
    self.subView2MiddleBlockValue.frame = CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height * (1 - displayPersentage));
    
}

- (CircleButtonRange) getIndexRange
{
    return _indexRange;
}

- (void) setIndexRange:(CircleButtonRange) newValue
{
    if (newValue.maxIndex < newValue.minIndex){
        newValue.maxIndex = newValue.minIndex;
    }
    
    if (newValue.maxIndex == 0){
        newValue.maxIndex = CIRCLE_DEFAULT_MAX_VALUE;
    }
    
    if (newValue.unitValue > newValue.maxIndex - newValue.minIndex)
    {
        newValue.unitValue = newValue.maxIndex - newValue.minIndex;
    }
    
    _indexRange = newValue;
}

- (double) getIndexValueSensitivity
{
    if (_indexValueSensitivity<= 0)
    {
        _indexValueSensitivity = 1;
    }
    return _indexValueSensitivity;
}

-(void) setIndexValueSensitivity: (double) newValue
{
    _indexValueSensitivity = newValue;
}

-(float) getIndexValue
{
    return _indexValue;
}

-(void) setIndexValue: (float) newValue
{
    
    if (newValue > self.indexRange.maxIndex){
        newValue = self.indexRange.maxIndex;
    }else if (newValue < self.indexRange.minIndex){
        newValue = self.indexRange.minIndex;
    }
        
    _indexValue = newValue;
    
    [self valueColorChangeWithIndexValue];
    [self.valueLabel setText:[NSString stringWithFormat:@"%0.1f", _indexValue]];
    
    [self circleButtonValueChanged: self];
}

-(void) setTouched: (BOOL) newValue
{
    _touched = newValue;
    if (_touched){
        [self.superview bringSubviewToFront:self];
        // If it has been touched, the inner red circle will become bigger.
        // The reason why I didn't use animate methods to handle it is because of speed, too slow.
        // It will rotate to label side when changing size finish.
        [self flipAnimation];
    }else{
        [self roundingAnimationStop];
    }
}

- (BOOL) getTouched
{
    return _touched;
}

- (void) flipAnimation
{
    if (self.touched) {
        [UIView transitionFromView:self.signPicture toView:self.valueLabel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            if (self.touched){
                                if (_touchedTimer != nil){
                                    [_touchedTimer invalidate];
                                    _touchedTimer = nil;
                                }
                                _touchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                                             target:self
                                                                           selector:@selector(touchedOpen:)
                                                                           userInfo:nil
                                                                            repeats:YES];
                            }
                        }];
    }
    else {
        [UIView transitionFromView:self.valueLabel toView:self.signPicture
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
    }
}

- (void) touchedOpen: (NSTimer *) thisTimer
{
    if (!self.touched){
        return;
    }
    
    // change to large size
    if (self.subView4.frame.origin.x > -1 * (self.frame.size.width /2)){
        self.subView4.frame = CGRectMake( self.subView4.frame.origin.x - 1,
                                            self.subView4.frame.origin.y - 1,
                                            self.subView4.frame.size.width + 2,
                                            self.subView4.frame.size.height + 2
                                           );
    }else{
        if (_touchedTimer != nil){
            [_touchedTimer invalidate];
            _touchedTimer = nil;
        }

        [self roundingAnimationStart];
    }
}

- (void) touchedClose: (NSTimer *) thisTimer
{
    if (self.touched){
        return;
    }
    
    // change to small size
    if (self.subView4.frame.origin.x < 0){
        self.subView4.frame = CGRectMake( self.subView4.frame.origin.x + 1,
                                           self.subView4.frame.origin.y + 1,
                                           self.subView4.frame.size.width - 2,
                                           self.subView4.frame.size.height - 2
                                           );
    }else{
        // rotate back to symbal
        [self flipAnimation];

        
        if (_touchedTimer != nil){
            [_touchedTimer invalidate];
            _touchedTimer = nil;
        }
    }
}

- (void) roundingAnimationStart
{
    self.imageViewChangeSizeCircle.image = [UIImage imageNamed:@"NewCircle_Big_Inner"];
    [UIView animateWithDuration:0.005
                          delay:0.01
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self rotationChange :self.subView4 degree : (float) _subView_F4_degree];
                     }
                     completion:^(BOOL finished){
                         if (self.touched){
                             _subView_F4_degree += ROUNDING_START_SENSITIVITY;
                             [self roundingAnimationStart];
                         }
                     }];
}

- (void) roundingAnimationStop
{
    self.imageViewChangeSizeCircle.image = [UIImage imageNamed:@"NewCircle_F4"];

    [UIView animateWithDuration:0.005
                          delay:0.0001
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self rotationChange :self.subView4 degree : (float) _subView_F4_degree];
                     }
                     completion:^(BOOL finished){
                         if (!self.touched){
                             if ((_subView_F4_degree % HALF_CIRCLE_DEGREE) == 0){
                                 _subView_F4_degree = 0;
                                 if (_touchedTimer != nil){
                                     [_touchedTimer invalidate];
                                     _touchedTimer = nil;
                                 }
                                 _touchedTimer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                                                  target:self
                                                                                selector:@selector(touchedClose:)
                                                                                userInfo:nil
                                                                                 repeats:YES];
                             }else{
                                 if (_subView_F4_degree % ROUNDING_BACK_SENSITIVITY){
                                     _subView_F4_degree -= _subView_F4_degree % ROUNDING_BACK_SENSITIVITY;
                                 }
                                 _subView_F4_degree -= ROUNDING_BACK_SENSITIVITY;
                                 [self roundingAnimationStop];
                             }
                         }
                     }];
}


- (void) rotationChange :(UIView *) targetView degree : (float) degree
{
    if (targetView == nil){
        return;
    }
    
    float rad = ((float)degree/ (float)HALF_CIRCLE_DEGREE) *M_PI;
    CGAffineTransform rotation = CGAffineTransformMakeRotation(rad);
    [targetView.layer setAffineTransform:rotation];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    _originalLocation = [self getLocationPoint: touches];

    self.touched = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touched = NO;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touched){
        CGPoint touchLocation = [self getLocationPoint: touches];
        // Because zero point is on left top, large point in on right bottom
        int moveUp = (double)(_originalLocation.y - touchLocation.y) / (double)self.indexValueSensitivity;
        if (moveUp != 0){
           self.indexValue += (float)moveUp * self.indexRange.unitValue;
           _originalLocation = touchLocation;
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   self.touched = NO;
}

- (CGPoint) getLocationPoint: (NSSet*)touches
{
    UITouch *touch =  [touches anyObject];
    return [touch locationInView:touch.view];
}

- (IBAction) circleButtonValueChanged:(CircleButton*) circleButton;
{
    // Pass to parent view.
    if (self.delegate != nil){
        // Check whether delegate have this selector
        if([self.delegate respondsToSelector:@selector(circleButtonValueChanged:)]){
            [self.delegate circleButtonValueChanged: circleButton];
        }
    }
}

- (void) twickLing
{
    if (self.touched){
        self.twickPicture.hidden = YES;
        return;
    }
    self.twickPicture.hidden = NO;
    [UIView transitionFromView:self.signPicture toView:self.twickPicture
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        [UIView transitionFromView:self.twickPicture toView:self.signPicture
                                          duration:0.1
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        completion:^(BOOL finished){
                                            self.twickPicture.hidden = YES;
                                        }];

                    }];
}

- (void) resetHandle
{
    // useful
    self.touched = NO;
}
@end
