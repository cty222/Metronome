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
}

- (void) MainViewWillAppear
{

}

- (void) InitializeSystemButton
{
    MetronomeMainViewController * Parent = (MetronomeMainViewController *)self.ParrentController;
    
    self.SystemButton = Parent.TopSubView.SystemButton;
    self.adView = Parent.adView;
    
    
    [self.SystemButton addTarget:self
                                action:@selector(ChangeToSystemSettingControllerView:) forControlEvents:UIControlEventTouchDown];
   
    self.adView.delegate = self;
    
    // 一開始是不打開的
    self.adView.hidden = YES;
    
    // TODO: self.adView 加入顯示/隱藏動畫

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
- (IBAction) ChangeToSystemSettingControllerView : (id) Button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeToSystemPageView object:nil];
}
//
//  =========================
@end
