//
//  QYShareTool.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareTool.h"
#import <UIKit/UIKit.h>

@implementation QYShareTool

#pragma mark -- NSUserDefault
+ (id) getValueFromUserDefault:(NSString *)key
{
    return  [[self userDefaults] valueForKey:key];
}
+ (void)setValue:(id)value tokey:(NSString *)key
{
    [[self userDefaults] setObject:value forKey:key];
    [[self userDefaults] synchronize];
}

+ (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark -提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg{
    
    UIAlertController * alertCrt = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertCrt addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCrt animated:YES completion:nil];
}
+ (BOOL) canOpenUrl:(NSString *)urlShemes{

    NSURL *url = [NSURL URLWithString:urlShemes];
    return [[UIApplication sharedApplication] canOpenURL:url];
}
@end
