//
//  QYShareComponentDelegate.h
//  QYShareSDK
//  声明 shareSDK 内部使用的组件接口
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareConst.h"
/**
 组件基协议，1.0会把所有的协议暂时放在基协议中。后期再进行拆分
 */
@protocol QYShareComponentBaseDelegate<NSObject>

/**
 注册 第三方sdk 没有 screentKey 传nil。不需要注册的 该方法实现为空方法
 @param appId 第三方sdk的appID
 @param secretKey 第三方secretKey
 @param redirectUrl 重定向url 不需要的传nil
 */
- (void)registerInterfaceWithAPPID:(NSString *)appId
                        secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl;


/**
 分享图片
 */
- (void)shareImage:(id<QYShareConfig>)interface;
/**
 分享视频
 */
- (void)shareVideo:(id<QYShareConfig>)interface;
/**
 分享网页链接
 */
- (void)shareUrl:(id<QYShareConfig>)interface;
/**
 分享GIF
 */
- (void)shareGif:(id<QYShareConfig>)interface;
/**
 分享纯文本
 */
- (void)shareText:(id<QYShareConfig>)interface;


/**
 是否安装第三方APP
 @return YES 安装了， NO未安装
 */
- (BOOL)isInstallAPPClient;


/**
 检测第三方平台是否已经授权

 @return YES 授权 ,NO 未授权
 */
- (BOOL)hasAuthorized;

/**
 发起授权
 */
- (void)authoried;

@property(nonatomic,assign)QYSharePlatform platform;
@property(nonatomic,assign)QYShareType shareType;
@property(nonatomic,weak)id<QYShareDelegate>delegate;
@end

@protocol QYShareToQQDelegate<QYShareComponentBaseDelegate>

@end

@protocol QYShareToWXDelegate<QYShareComponentBaseDelegate>

@end

@protocol QYShareToSinaDelegate<QYShareComponentBaseDelegate>

@end
