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
    id object = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"FLEXEnableBootload"];
    if ([object respondsToSelector:@selector(boolValue)]) {
        enableBootload = [object boolValue];
    }
    
    if (enableBootload) {
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
        
        if (@available(iOS 11.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull notification) {
                [[FLEXManager sharedManager] showExplorer];
            }];
        }
    }
}

@end
