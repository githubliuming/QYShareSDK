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
 组件基协议
 */
@protocol QYShareComponentBaseDelegate<NSObject>

- (void)registerInterfaceWithAPPID:(NSString *)appId
                        screentKey:(NSString *)screentKey;

- (void)shareImage:(id<QYShareConfig>)interface;
- (void)shareVideo:(id<QYShareConfig>)interface;
- (void)shareUrl:(id<QYShareConfig>)interface;
- (void)shareGif:(id<QYShareConfig>)interface;
- (void)shareText:(id<QYShareConfig>)interface;
@end

@protocol QYShareToQQDelegate<QYShareComponentBaseDelegate>

@end

@protocol QYShareToWXDelegate<QYShareComponentBaseDelegate>

@end

@protocol QYShareToSinaDelegate<QYShareComponentBaseDelegate>

@end
