//
//  LocalizedMutilanguage.m
//  Groove
//
//  Created by C-ty on 2015/1/29.
//  Copyright (c) 2015年 Cty. All rights reserved.
//

#import "LocalizedMutilanguage.h"

static NSBundle *DefaultLanguageBundle = nil;

@implementation LocalizedMutilanguage

+ (NSString *)LocalizedMutilanguage:(NSString *)key replaceValue:(NSString *)comment {
    NSString *Language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *LocalizedString;
    
    if ([@[@"en", @"zh-Hant", @"zh-Hans"] containsObject:Language]){
        return NSLocalizedString(key, comment);
    }
    else{
        if (DefaultLanguageBundle == nil)
        {
            NSString *DefaultLanguage = @"en";
            if ([[Language substringToIndex:[@"zh" length]]isEqualToString:@"zh"]) {
                if ([[Language substringToIndex:[@"zh-Hant" length]]isEqualToString:@"zh-Hant"]) {
                    DefaultLanguage = @"zh-Hant";
                }
                else
                {
                    DefaultLanguage = @"zh-Hans";
                }
            }
            NSString *DefaultBundlePath = [[NSBundle mainBundle] pathForResource:DefaultLanguage ofType:@"lproj"];
            DefaultLanguageBundle = [NSBundle bundleWithPath:DefaultBundlePath];
        }
        NSString *DefaultString = [DefaultLanguageBundle localizedStringForKey:key value:comment table:nil];
        LocalizedString = DefaultString;
    }
    
    return LocalizedString;
}

@end
