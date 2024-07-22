//
//  FLEXBootloader.m
//  FLEX
//
//  Created by wesley_chen on 2024/3/6.
//  Copyright © 2024 Flipboard. All rights reserved.
//

#import "FLEXBootloader.h"
#import "FLEXManager.h"

#import <UIKit/UIKit.h>

#define FLEX_getBoolFromInfoPlist(key_, defaultBool_) \
({ \
    BOOL value = (defaultBool_); \
    id object = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:(key_)]; \
    if ([object respondsToSelector:@selector(boolValue)]) { \
        value = [object boolValue]; \
    } \
    value; \
});

@implementation FLEXBootloader

+ (void)load {
    // Note: check executable file name is FLEX, here suppose FLEX executable is a dynamic framework
    if ([[[NSBundle bundleForClass:[self class]].executableURL lastPathComponent] isEqualToString:@"FLEX"]) {
        BOOL enableBootload = FLEX_getBoolFromInfoPlist(@"FLEXEnableBootload", NO);
        if (!enableBootload) {
            return;
        }
        
        BOOL enableShowWhenAppLaunch = FLEX_getBoolFromInfoPlist(@"FLEXEnableBootloadWhenAppLaunch", NO);
        if (enableShowWhenAppLaunch) {
            if (@available(iOS 13.0, *)) {
                [[NSNotificationCenter defaultCenter] addObserverForName:UISceneWillConnectNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
                    [[FLEXManager sharedManager] showExplorer];
                }];
            }
            else {
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
                    [[FLEXManager sharedManager] showExplorer];
                }];
            }
        }
        
        if (@available(iOS 11.0, *)) {
            BOOL enableShowWhenTakeScreenshot = FLEX_getBoolFromInfoPlist(@"FLEXEnableBootloadWhenTakeScreenshot", NO);
            if (enableShowWhenTakeScreenshot) {
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
                    [[FLEXManager sharedManager] showExplorer];
                }];
            }
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
            [[FLEXManager sharedManager] showExplorer];
        }];   
    }
}

@end
