//
//  MetronomeMainViewControllerIphone.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "MetronomeMainViewControllerIphone.h"

@interface MetronomeMainViewControllerIphone ()

@end

@implementation MetronomeMainViewControllerIphone

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//
//    }
//    return self;
//}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect FullViewFrame = self.FullView.frame;
    CGRect TopViewFrame = self.TopView.frame;
    CGRect BottomViewFrame = self.BottomView.frame;
    

    NSNumber * DeviceType = [GlobalConfig DeviceType];
    switch (DeviceType.intValue) {
        case IPHONE_4S:
            FullViewFrame = CGRectMake(FullViewFrame.origin.x
                                      , FullViewFrame.origin.y
                                      , FullViewFrame.size.width
                                      , IPHONE_4S_HEIGHT
                                      );
            
            TopViewFrame = CGRectMake(TopViewFrame.origin.x
                                      , TopViewFrame.origin.y
                                      , TopViewFrame.size.width
                                      , TopViewFrame.size.height - (IPHONE_5S_HEIGHT - IPHONE_4S_HEIGHT)
                                      );
            BottomViewFrame = CGRectMake(BottomViewFrame.origin.x
                                      , BottomViewFrame.origin.y  - (IPHONE_5S_HEIGHT - IPHONE_4S_HEIGHT)
                                      , BottomViewFrame.size.width
                                      , BottomViewFrame.size.height
                                      );
            break;
        case IPHONE_5S:
            break;
        default:
            break;
    }
    
    self.FullView.frame = FullViewFrame;
    self.TopView.frame = TopViewFrame;
    self.BottomView.frame = BottomViewFrame;

    NSLog(@"%@", self.FullView);
    NSLog(@"%@", self.TopView);
    NSLog(@"%@", self.BottomView);

    [self InitializeTopSubView];
    [self InitializeBottomSubView];
}

- (void) InitializeTopSubView
{
    if (self.TopSubView == nil)
    {
        self.TopSubView = [[MetronmoneTopSubViewIphone alloc] initWithFrame:self.TopView.frame];
    }
    if (self.TopView.subviews.count != 0)
    {
        [[self.TopView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.TopView addSubview:self.TopSubView];

}

- (void) InitializeBottomSubView
{
    if (self.BottomSubView == nil)
    {
        CGRect SubFrame = self.BottomView.frame;
        SubFrame.origin = CGPointMake(0, 0);
        
        self.BottomSubView = [[MetronomeBottomSubViewIphone alloc] initWithFrame:SubFrame];
    }
    if (self.BottomView.subviews.count != 0)
    {
        [[self.BottomView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSLog(@"%@",self.BottomSubView);
    [self.BottomView addSubview:self.BottomSubView];
    //self.BottomSubView.Set.hidden = YES;
}
//  =========================
//
//
- (IBAction) ChangeToGrooveMainViewControllerIphone : (id) Button
{
    
    [self presentViewController:[GlobalConfig GrooveMainViewControllerIphone] animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch =  [touches anyObject];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [touch locationInView:touch.view];
        [BPMPicker TouchBeginEvent:OriginalLocation];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [touch locationInView:touch.view];
        [BPMPicker TouchEndEvent:OriginalLocation];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [touch locationInView:touch.view];
        [BPMPicker TouchMoveEvent:OriginalLocation];
    }
}

 -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"LargeBPMPicker"])
    {
        LargeBPMPicker* BPMPicker = (LargeBPMPicker *)touch.view;
        CGPoint OriginalLocation;
        OriginalLocation = [touch locationInView:touch.view];
        [BPMPicker TouchCancellEvent:OriginalLocation];
    }
}

//
//  =========================

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
