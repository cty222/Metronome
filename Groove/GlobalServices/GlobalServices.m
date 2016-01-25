//
//  GlobalServices.m
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import "GlobalServices.h"
#import "MetronomeMainViewController.h"
#import "TempoListViewController.h"
#import "SystemPageViewController.h"


@interface GlobalServices ()
// Main View
@property UIViewController * metronomeMainViewController;
@property UIViewController * tempoListController;
@property UIViewController * systemPageViewController;
@end

@implementation GlobalServices
@synthesize engine = _engine;
@synthesize metronomeMainViewController = _metronomeMainViewController;
@synthesize tempoListController = _tempoListController;
@synthesize systemPageViewController = _systemPageViewController;

- (id) init
{
    self = [super init];
    
    if (self){
        self.engine = [[MetronomeEngine alloc] init];
    }
    
    return self;
}

// ===============================
// public methods
//

- (UIViewController *) getUIViewController: (__MAIN_PAGE) key{
    UIViewController * controller = nil;
    switch (key) {
        case METRONOME_PAGE:
            if (!self.metronomeMainViewController) {
                [self initMetronomePage];
            }
            controller = self.metronomeMainViewController;
            break;
        case SYSTEMSETTING_PAGE:
            if (!self.systemPageViewController) {
                [self initSystemSettingPage];
            }
            controller = self.systemPageViewController;
            break;
        case TEMPOLIST_PAGE:
            if (!self.tempoListController) {
                [self initTempoListPage];
            }
            controller = self.tempoListController;
            break;
    }
    
    return controller;
}

//
// ============================


// ============================
// private methods
//

- (void) initMetronomePage
{
    self.metronomeMainViewController = [[MetronomeMainViewController alloc] initWithGlobalServices:self];
}

- (void) initSystemSettingPage
{
    self.systemPageViewController = [[SystemPageViewController alloc] initWithGlobalServices:self];
}

- (void) initTempoListPage
{
    self.tempoListController = [[TempoListViewController alloc] initWithGlobalServices:self];
}

//
// ============================



@end
