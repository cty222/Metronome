//
//  GlobalServicesTest.m
//  RockClick
//
//  Created by C-ty on 2016-01-24.
//  Copyright © 2016 Cty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GlobalServices.h"
#import "MetronomeMainViewController.h"
#import "SystemPageViewController.h"
#import "TempoListViewController.h"

@interface GlobalServicesTest : XCTestCase
@property GlobalServices* globalServices;

@end

@implementation GlobalServicesTest
@synthesize globalServices = _globalServices;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.globalServices = [[GlobalServices alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetUIViewController {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    UIViewController * metronomePage = [self.globalServices getUIViewController:METRONOME_PAGE];
    UIViewController * systemPage = [self.globalServices getUIViewController:SYSTEMSETTING_PAGE];
    UIViewController * tempoListPage = [self.globalServices getUIViewController:TEMPOLIST_PAGE];
    UIViewController * nilPage = [self.globalServices getUIViewController:-1];
    XCTAssertTrue([metronomePage.class isSubclassOfClass:[MetronomeMainViewController class]], @"MetronomeMainViewController create failed");
    XCTAssertTrue([systemPage.class isSubclassOfClass:[SystemPageViewController class]], @"SystemPageViewController create failed");
    XCTAssertTrue([tempoListPage.class isSubclassOfClass:[TempoListViewController class]], @"TempoListViewController create failed");
    XCTAssertTrue((nilPage.class == nil), @"nilPage is not nil");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
