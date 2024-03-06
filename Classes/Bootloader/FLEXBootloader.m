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

@implementation FLEXBootloader

+ (void)load {
    BOOL enableBootload = NO;
    id object1 = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"FLEXEnableBootload"];
    if ([object1 respondsToSelector:@selector(boolValue)]) {
        enableBootload = [object1 boolValue];
    }
    
    if (!enableBootload) {
        return;
    }
    
    BOOL enableShowWhenAppLaunch = NO;
    id object2 = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"FLEXEnableBootloadWhenAppLaunch"];
    if ([object2 respondsToSelector:@selector(boolValue)]) {
        enableBootload = [object2 boolValue];
    }
    
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
        BOOL enableShowWhenTakeScreenshot = NO;
        id object2 = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"FLEXEnableBootloadWhenTakeScreenshot"];
        if ([object2 respondsToSelector:@selector(boolValue)]) {
            enableShowWhenTakeScreenshot = [object2 boolValue];
        }
        
        if (enableShowWhenTakeScreenshot) {
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
                [[FLEXManager sharedManager] showExplorer];
            }];
        }
    }
}

@end
