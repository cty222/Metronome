//
//  AppDelegate.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "AppDelegate.h"

// 讓silence mode 下也有聲音
#import <AVFoundation/AVFoundation.h>
#import "Audioplay.h"
#import "GlobalServices.h"

@interface AppDelegate ()
@property NSDictionary *options;
@property GlobalServices *globalServices;

@end

@implementation AppDelegate
@synthesize globalServices = _globalServices;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if TODO
    NSLog(@"%@", [NSLocale preferredLanguages]);
#endif
    
    self.window = [[UIWindowWithHook alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blueColor]; //??????
    self.window.EnableTouchHookNotifications = YES;
    
// 移植資料庫
// 1. Groove.xcdatamodeld上 Editor -> add Model version -> base選現在系統裡面的
// 2. 加完新項目後->Class改成新的
// DBVERSION_CHANGE_REBUILD_DB_FOR_TEST_ENABLE 改成0;
    
// 資料庫移植有base的概念
// 不能隨意downgrade
// 如果要downgrade
// 方法一 再Upgrade
// 方法二 刪掉重建舊的

    self.options = nil;
    // 如果Db如果有做修改的話 刪掉
    if ([GlobalConfig UpdateDbFlag])
    {
#if DBVERSION_CHANGE_REBUILD_DB_FOR_TEST_ENABLE
        NSLog(@"RebuildDb");
        // DB會被放在 Documents裡, 找出目標file的URL
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Groove.sqlite"];
        
        NSFileManager *FileManager = [[NSFileManager alloc] init];
        [FileManager removeItemAtURL:storeURL error:nil];
#else
        // Update DBVersion
        self.options = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
         [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
#endif
    }

    
    
    //
    // 1. Initize global config
    //
    // will all so set or reset global plist
    [GlobalConfig Initialize:self.window];
    self.globalServices = [[GlobalServices alloc] init];
    
    //
    // 2. Initize Model
    //
    gMetronomeModel = [[MetronomeModel alloc] init];
    [gMetronomeModel InitializeCoreData : self.managedObjectContext
                     ManagedObjectModel : self.managedObjectModel
                              DbVersion : [GlobalConfig DbVersion]];
    [gMetronomeModel UpdateDbVersion:[GlobalConfig DbVersion]];
    
    //3. Set rootViewController
    self.window.rootViewController =  [self.globalServices getUIViewController: METRONOME_PAGE];
    
    
    // System add
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
    // 關掉所有音樂
    [[NSNotificationCenter defaultCenter] postNotificationName:kVoiceStopByInterrupt object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    
    // 防止其他程式關掉AlcDevice
   [AudioPlay RestartAlcDevice];
    
    // 0. Disbale IdleTimer
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");

    
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack
// 要做出 managedObjectContext , managedObjectModel, persistentStoreCoordinator

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    // DB的sqlite是從這個檔案做出來的
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Groove" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // DB會被放在 Documents裡, 找出目標file的URL
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Groove.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:self.options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
