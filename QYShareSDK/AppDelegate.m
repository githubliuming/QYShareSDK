//
//  AppDelegate.m
//  QYShareSDK
//
//  Created by liuming on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "AppDelegate.h"
#import "QYShareSever.h"
#define KAPPID @"KAPPID"
#define KSecretKey @"KSecretKey"
#define KRedirectUrl @"KRedirectUrl"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSDictionary *)thirdRegisterInfoMap
{
    return @{
        @(QYSharePlatform_QQ_Friend) : @{
            KAPPID : @"1105725139",
            KSecretKey : @"",
        },
        @(QYSharePlatform_WX_Contact) : @{
            KAPPID : @"wx3da7473af9c22b08",
            KSecretKey : @"14bb143ec7dbea55abbc00d77e1a49c2",
        },
        @(QYSharePlatform_SinaWB) : @{
            KAPPID : @"1374044879",
            KSecretKey : @"3d0a13e13cde20db2393f4a844048956",
            KRedirectUrl : @"http://www.yoyoim.com"
        },
    };
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    //注册第三方平台
    [QYShareSever registerThirdComponent:^(id<QYShareComponentDelegate> component, QYSharePlatform platform) {
        NSDictionary *configDic = [self thirdRegisterInfoMap][@(platform)];
        if (configDic)
        {
            [component registerInterfaceWithAPPID:configDic[KAPPID]
                                        secretKey:configDic[KSecretKey]
                                      redirectUrl:configDic[KRedirectUrl]
                                      application:application
                                    launchOptions:launchOptions];
        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of
    // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should
    // use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application
    // state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate:
    // when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes
    // made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application
    // was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also
    // applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [QYShareSever application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [QYShareSever application:application handleOpenURL:url];
}

@end
