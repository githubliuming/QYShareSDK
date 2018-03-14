//
//  QYShareSever.h
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareConst.h"
#import "QYShareComponentDelegate.h"
//1、重定向url怎么传进来
//2、剥离里面 philm的业务逻辑代码

@interface QYShareSever : NSObject

- (instancetype)initWithDelegate:(id<QYShareDelegate>)delegate;

- (void)startShare:(id<QYShareConfig>)shareConfig
      platformType:(QYSharePlatform)platform
         shareType:(QYShareType)type;
/**
 向路由表中注册新的组件
 @param interface 组件对象
 @param platform 平台
 */
+(void)addComponent:(id<QYShareComponentBaseDelegate>)interface
        forPlatform:(QYSharePlatform)platform;

/**
 从路由表中移除组件
 @param platform 平台
 */
+ (void)removeComponetWithPlatfrom:(QYSharePlatform)platform;
@end
