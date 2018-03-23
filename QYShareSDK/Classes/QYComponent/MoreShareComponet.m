//
//  MoreShareComponet.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/16.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "MoreShareComponet.h"
#import "QYShareTool.h"
@implementation MoreShareComponet
@synthesize platform,delegate,shareType;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
                       application:(UIApplication *)application
                     launchOptions:(NSDictionary *)launchOptions
{
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
}

- (void)authoried
{
}

- (BOOL)hasAuthorized
{
    return YES;
}

- (BOOL)isInstallAPPClient {
    return YES;
}
- (void)shareGif:(id<QYShareConfig>)interface
{
    NSData * gifData = [NSData dataWithContentsOfFile:interface.gifPath];
    [self shareWithSystemShareUinity:@[gifData]];
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    [self shareWithSystemShareUinity:interface.images];
}

- (void)shareText:(id<QYShareConfig>)interface
{
    [self shareWithSystemShareUinity:@[interface.title]];
}

- (void)shareUrl:(id<QYShareConfig>)interface
{
     [self shareWithSystemShareUinity:@[[NSURL URLWithString:interface.url]]];
}

- (void)shareVideo:(id<QYShareConfig>)interface {
    
    [self shareWithSystemShareUinity:@[[NSURL fileURLWithPath:interface.url]]];
}

/**
 *  系统分享组件 UIActivityViewController
 *
 *  @param datas 分享数据数组 注意 分享本地视频时 数组中放视频本地的url
 */
- (void)shareWithSystemShareUinity:(NSArray *)datas
{
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:datas applicationActivities:nil];
    [[QYShareTool nx_currentViewController] presentViewController:activityViewController
                                                              animated:YES
                                                            completion:nil];
}

@end
