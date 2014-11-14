//
//  SystemPageControl.m
//  Groove
//
//  Created by C-ty on 2014/11/14.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "SystemPageControl.h"

@implementation SystemPageControl

- (void) InitializeSystemButton
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;
    
    self.SystemButton = Parent.TopSubView.SystemButton;
    self.adView = Parent.BottomSubView.adView;
    
    self.adView.delegate = self;
}


// =================================
// iAD function

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // 有錯誤會進來
}

- (void) bannerViewActionDidFinish:(ADBannerView *)banner
{
    // 使用者關掉廣告內容畫面
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    // 廣告載入
}

-(void) bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}

-(BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // 使用者點了廣告後開啟畫面
    return YES;
}


//
// =================================


//  =========================
//
//
- (IBAction) ChangeToGrooveMainViewControllerIphone : (id) Button
{
    MetronomeMainViewControllerIphone * Parent = (MetronomeMainViewControllerIphone *)self.ParrentController;

    [Parent presentViewController:[GlobalConfig GrooveMainViewControllerIphone] animated:YES completion:nil];
}
//
//  =========================
@end
