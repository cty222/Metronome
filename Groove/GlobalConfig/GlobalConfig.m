//
//  GlobalConfig.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "GlobalConfig.h"
#import "MetronomeMainViewController.h"
#import "SystemPageViewController.h"

static BOOL _IsInitialized;
static NSMutableDictionary * ThisPlist;

@implementation GlobalConfig

// ============================
// function
//
+ (BOOL) ReBuildDbFlag
{
    static BOOL _ReBuildDbFlag;

    static dispatch_once_t _ReBuildDbToken;
    dispatch_once(&_ReBuildDbToken, ^{
        NSString * TmpDistributionPath = [GlobalConfig DistributionFilePath];
        NSString * TmpSourcePath = [GlobalConfig SourceFilePath];
    
        NSNumber *SourceDBVersion      = [[NSMutableDictionary dictionaryWithContentsOfFile:TmpSourcePath] objectForKey:@"DbVersion"];
        NSNumber *DistributionDBVersion = [[NSMutableDictionary dictionaryWithContentsOfFile:TmpDistributionPath] objectForKey:@"DbVersion"];
        _ReBuildDbFlag = [SourceDBVersion intValue] != [DistributionDBVersion intValue];
    });
    
    return _ReBuildDbFlag;
}

+ (NSString*) SourceFilePath
{
    static NSString* _SourceFilePath;
    static dispatch_once_t _SrcFilePathToken;
    dispatch_once(&_SrcFilePathToken, ^{
        _SourceFilePath = [[NSBundle mainBundle]pathForResource:@"GlobalConfig" ofType:@"plist"];
    });
    
    return _SourceFilePath;
}

+ (NSString*) DistributionFilePath
{
    static NSString* _DistributionFilePath;
    static dispatch_once_t _DstFilePathToken;
    dispatch_once(&_DstFilePathToken, ^{
        _DistributionFilePath = [NSString stringWithFormat:@"%@/Documents/GlobalConfig.plist", NSHomeDirectory()];;
    });
    
    return _DistributionFilePath;
}

+ (NSMutableDictionary *)GlobalConfigPlist
{
    static NSMutableDictionary* _GlobalConfigPlist;
    static dispatch_once_t _gPlistFilePathToken;
    dispatch_once(&_gPlistFilePathToken, ^{
        NSFileManager *FileManager = [[NSFileManager alloc] init];
        NSString * TmpDistributionPath = [GlobalConfig DistributionFilePath];
        NSString * TmpSourcePath = [GlobalConfig SourceFilePath];

        NSNumber *SourceVersionID      = [[NSMutableDictionary dictionaryWithContentsOfFile:TmpSourcePath] objectForKey:@"VersionID"];
        if (![FileManager fileExistsAtPath:TmpDistributionPath])
        {
            [FileManager copyItemAtPath:TmpSourcePath toPath:TmpDistributionPath  error:nil];
            NSLog(@"Create GlobalConfig plist VersionID %@", SourceVersionID);
        }
        else
        {
            NSNumber *DistributionSourceID = [[NSMutableDictionary dictionaryWithContentsOfFile:TmpDistributionPath] objectForKey:@"VersionID"];
            
            // Init RebuldFlag at this moment, Important.
            [GlobalConfig ReBuildDbFlag];
            
            if ([DistributionSourceID intValue] != [SourceVersionID intValue])
            {
                [FileManager removeItemAtPath:TmpDistributionPath error:nil];
                [FileManager copyItemAtPath:TmpSourcePath toPath:TmpDistributionPath  error:nil];
                NSLog(@"Change to VersionID %@", SourceVersionID);
            }
        }
        _GlobalConfigPlist = [NSMutableDictionary dictionaryWithContentsOfFile:TmpDistributionPath];
    });
    
    return _GlobalConfigPlist;
}

+ (BOOL) IsInitialized
{
    return _IsInitialized;
}

+ (void) Initialize : (UIWindow *) MainWindows
{
    ThisPlist = [GlobalConfig GlobalConfigPlist];
    BOOL IsChanged = NO;
    
    //
    // Get system info
    //
    NSNumber *MainWindowHeight = [NSNumber numberWithInt: MainWindows.frame.size.height];
    NSNumber *MainWindowWidth  = [NSNumber numberWithInt: MainWindows.frame.size.width];
    NSNumber *DeviceType;
    switch ([MainWindowHeight intValue])
    {
        case IPHONE_4S_HEIGHT:
            DeviceType = [NSNumber numberWithInt: IPHONE_4S];
            break;
        case IPHONE_5S_HEIGHT:
            DeviceType = [NSNumber numberWithInt: IPHONE_5S];
            break;
        default:
            DeviceType = [NSNumber numberWithInt: DEFAULT_DEVICE_TYPE];
    }
    

    if ([MainWindowHeight intValue] != [[ThisPlist objectForKey:@"MainWindowHeight"] intValue])
    {
        [ThisPlist setObject:MainWindowHeight forKey:@"MainWindowHeight"];
        IsChanged = YES;
    }
    
    if ([MainWindowWidth intValue] != [[ThisPlist objectForKey:@"MainWindowWidth"] intValue])
    {
        [ThisPlist setObject:MainWindowWidth forKey:@"MainWindowWidth"];
        IsChanged = YES;
    }

    if ([DeviceType intValue] != [[ThisPlist objectForKey:@"DeviceType"] intValue])
    {
        [ThisPlist setObject:DeviceType forKey:@"DeviceType"];
        IsChanged = YES;
    }

    
    //
    // IsInitialized
    //
    if ([DeviceType intValue] != DEFAULT_DEVICE_TYPE)
    {
        _IsInitialized = YES;
    }

    // Save in distribution file
    if (IsChanged)
    {
        [ThisPlist setObject:MainWindowWidth forKey:@"MainWindowWidth"];
        [ThisPlist setObject:MainWindowHeight forKey:@"MainWindowHeight"];
        [ThisPlist setObject:DeviceType forKey:@"DeviceType"];

        [GlobalConfig SaveDataInDistributionFile];
    }
    
    //
    // TODO: Self testing
    //
    if (self.MetronomeMainViewController == nil ||
        self.SystemPageViewController == nil
        )
    {
        _IsInitialized = NO;
    }
}

+ (void) SaveDataInDistributionFile
{
    if (![GlobalConfig IsInitialized])
    {
        return;
    }
    
    [ThisPlist writeToFile:[GlobalConfig DistributionFilePath] atomically:YES];
}

+ (NSNumber *) MainWindowWidth
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"MainWindowWidth"];;
}

+ (NSNumber *) MainWindowHeight
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"MainWindowHeight"];;
}

+ (NSNumber *) DeviceType
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"DeviceType"];
}

+ (NSNumber *) BPMMinValue
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return [ThisPlist objectForKey:@"BPMMinValue"];
}

+ (NSNumber *) BPMMaxValue
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"BPMMaxValue"];
}

+ (NSNumber *) DbVersion
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"DbVersion"];
}

// ========================================
+ (void) SetLastTempoListIndex : (int) NewValue
{
    if (![GlobalConfig IsInitialized])
    {
        return;
    }
    [ThisPlist setValue:[[NSNumber alloc] initWithInt:NewValue] forKey:@"LastTempoListIndex"];
    [ThisPlist writeToFile:[GlobalConfig DistributionFilePath] atomically:YES];
    
}

+ (NSNumber *) GetLastTempoListIndex
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"LastTempoListIndex"];
}

// ========================================



+ (NSNumber *) LoopValueMax
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return [ThisPlist objectForKey:@"LoopValueMax"];
}

+ (NSNumber *) LoopValueMin
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"LoopValueMin"];
}

+ (NSNumber *) LoopCellMaxCount
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"LoopCellMaxCount"];
}

+ (BOOL) PlayCellListNoneStop
{
    if (![GlobalConfig IsInitialized])
    {
        return NO;
    }
    
    return [[ThisPlist objectForKey:@"PlayCellListNoneStop"] boolValue];
}

+ (void) SetPlayCellListNoneStop : (BOOL) NewValue
{
    if (![GlobalConfig IsInitialized])
    {
        return;
    }
    [ThisPlist setValue:[[NSNumber alloc] initWithInt:NewValue] forKey:@"PlayCellListNoneStop"];
    [ThisPlist writeToFile:[GlobalConfig DistributionFilePath] atomically:YES];
}

//
// ============================

// ============================
// Music bounds Flag
//
+ (MusicProperties * ) GetMusicProperties
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    MusicProperties * Properties = [[MusicProperties alloc] init];
    
    Properties.MusicFunctionEnable = [[ThisPlist objectForKey:@"MusicFunctionEnable"] boolValue];
    Properties.MusicHalfRateEnable = [[ThisPlist objectForKey:@"MusicHalfRate"] boolValue];
    Properties.PlaySingleCellWithMusicEnable = [[ThisPlist objectForKey:@"PlaySingleCellWithMusic"] boolValue];
    Properties.PlayMusicLoopingEnable = [[ThisPlist objectForKey:@"PlayMusicLoopingEnable"] boolValue];
    
    return Properties;
}

+ (void) SetMusicProperties : (MusicProperties *) NewMusicProperties
{
    [ThisPlist setValue:[NSNumber numberWithBool:NewMusicProperties.MusicFunctionEnable] forKey:@"MusicFunctionEnable"];
    [ThisPlist setValue:[NSNumber numberWithBool:NewMusicProperties.MusicHalfRateEnable] forKey:@"MusicHalfRate"];
    [ThisPlist setValue:[NSNumber numberWithBool:NewMusicProperties.PlaySingleCellWithMusicEnable] forKey:@"PlaySingleCellWithMusic"];
    [ThisPlist setValue:[NSNumber numberWithBool:NewMusicProperties.PlayMusicLoopingEnable] forKey:@"PlayMusicLoopingEnable"];

    
    [ThisPlist writeToFile:[GlobalConfig DistributionFilePath] atomically:YES];
}
//
// ============================

// ============================
// Main View Initialize
//
+ (UIViewController *) MetronomeMainViewController
{
    static MetronomeMainViewController* _MetronomeMainViewController;
    static dispatch_once_t _MMVCIToken;
    dispatch_once(&_MMVCIToken, ^{
        _MetronomeMainViewController = [[MetronomeMainViewController alloc] initWithNibName:NSStringFromClass([_MetronomeMainViewController class]) bundle:nil];
    });
    
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return _MetronomeMainViewController;
}

+ (UIViewController *) SystemPageViewController
{
    static SystemPageViewController* _SystemPageViewController;
    static dispatch_once_t _SPVCToken;
    dispatch_once(&_SPVCToken, ^{
        _SystemPageViewController = [[SystemPageViewController alloc] initWithNibName:NSStringFromClass([_SystemPageViewController class]) bundle:nil];
        _SystemPageViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    });
    
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return _SystemPageViewController;
}

+ (UIViewController *) TempoListController
{
    static TempoListViewController* _TempoListViewController;
    static dispatch_once_t _TLCIToken;
    dispatch_once(&_TLCIToken, ^{
        _TempoListViewController = [[TempoListViewController alloc] initWithNibName:NSStringFromClass([_TempoListViewController class]) bundle:nil];
        _TempoListViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
    });
    
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return _TempoListViewController;
}
//
// ============================

@end
