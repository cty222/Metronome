//
//  GlobalConfig.m
//  Groove
//
//  Created by C-ty on 2014/8/31.
//  Copyright (c) 2014年 Cty. All rights reserved.
//

#import "GlobalConfig.h"
#import "MetronomeMainViewControllerIphone.h"
#import "GrooveMainViewControllerIpone.h"

static BOOL _IsInitialized;
static NSMutableDictionary * ThisPlist;

@implementation GlobalConfig

// ============================
// function
//

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
    if (self.MetronomeMainViewControllerIphone == nil ||
        self.GrooveMainViewControllerIphone == nil
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

+ (NSNumber *) LastFocusCellIndex
{
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    
    return [ThisPlist objectForKey:@"LastFocusCellIndex"];
}

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
//
// ============================

// ============================
// Main View Initialize
//
+ (UIViewController *) MetronomeMainViewControllerIphone
{
    static MetronomeMainViewControllerIphone* _MetronomeMainViewControllerIphone;
    static dispatch_once_t _MMVCIToken;
    dispatch_once(&_MMVCIToken, ^{
        _MetronomeMainViewControllerIphone = [[MetronomeMainViewControllerIphone alloc] initWithNibName:NSStringFromClass([MetronomeMainViewControllerIphone class]) bundle:nil];
    });
    
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return _MetronomeMainViewControllerIphone;
}

+ (UIViewController *) GrooveMainViewControllerIphone
{
    static GrooveMainViewControllerIpone* _GrooveMainViewControllerIphone;
    static dispatch_once_t _GMVCIToken;
    dispatch_once(&_GMVCIToken, ^{
        _GrooveMainViewControllerIphone = [[GrooveMainViewControllerIpone alloc] initWithNibName:NSStringFromClass([GrooveMainViewControllerIpone class]) bundle:nil];
    });
    
    if (![GlobalConfig IsInitialized])
    {
        return nil;
    }
    return _GrooveMainViewControllerIphone;
}

//
// ============================

@end
