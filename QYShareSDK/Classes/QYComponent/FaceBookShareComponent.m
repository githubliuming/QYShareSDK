//
//  FaceBookShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/14.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "FaceBookShareComponent.h"

@implementation FaceBookShareComponent

@synthesize platform,delegate,shareType;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
{
    
}

- (void)shareGif:(id<QYShareConfig>)interface
{
}

- (void)shareImage:(id<QYShareConfig>)interface
{
}

- (void)shareText:(id<QYShareConfig>)interface
{
}

- (void)shareUrl:(id<QYShareConfig>)interface
{
}

- (void)shareVideo:(id<QYShareConfig>)interface
{
}

- (void)authoried {
    
}

- (BOOL)hasAuthorized
{
    return YES;
}

- (BOOL)isInstallAPPClient
{
    return YES;
}
@end
