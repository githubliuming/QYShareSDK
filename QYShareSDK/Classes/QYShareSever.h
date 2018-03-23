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
//3、确定FBSDKHashtag是否被删除
@interface QYShareSever : NSObject

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE; 

- (instancetype)initWithDelegate:(id<QYShareDelegate>)delegate;

- (void)startShare:(id<QYShareConfig>)shareConfig
      platformType:(QYSharePlatform)platform
         shareType:(QYShareType)type;

-(void)startShare:(NSString *)title
          content:(NSString *)content
           images:(NSArray *)images
              url:(NSString *)url
          gifPath:(NSString *)gifPath
     platformType:(QYSharePlatform)platform
        shareType:(QYShareType)type;
/**
 向路由表中注册新的组件
 @param interface 组件对象
 @param platform 平台
 */
+(void)addComponent:(id<QYShareComponentDelegate>)interface
        forPlatform:(QYSharePlatform)platform;

/**
 从路由表中移除组件
 @param platform 平台
 */
+ (void)removeComponetWithPlatfrom:(QYSharePlatform)platform;

+(void)registerThirdComponent:(void(^)(id<QYShareComponentDelegate> component,QYSharePlatform platform))block;

+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
@end
