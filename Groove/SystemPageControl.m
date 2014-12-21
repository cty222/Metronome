//
//  SystemPageControl.m
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SystemPageControl.h"

@implementation SystemPageControl
{
    UIAlertView *_MusicTimeAlert;
}

- (void) MainViewWillAppear
{

}

- (void) InitializeSystemButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    self.SystemButton = Parent.TopSubView.SystemButton;
    self.adView = Parent.BottomSubView.adView;
    
    
    [self.SystemButton addTarget:self
                                action:@selector(ChangeToGrooveMainViewControllerIphone:) forControlEvents:UIControlEventTouchDown];
   
    self.adView.delegate = self;
}

- (void) StopTimeLowerThanStartTimeCallBack:(NSNotification *)Notification
{
}

// =================================
// iAD function

-(void) bannerViewWillLoadAd:(ADBannerView *)banner
{
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    // 廣告載入
    
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // 有錯誤會進來
}


-(BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // 使用者點了廣告後開啟畫面

    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{

}

//
// =================================


//  =========================
//
//
- (IBAction) ChangeToGrooveMainViewControllerIphone : (id) Button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToSystemPageView object:nil];
}
//
//  =========================
@end
