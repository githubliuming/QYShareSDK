//
//  QYShareTool.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareTool.h"

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
@end
