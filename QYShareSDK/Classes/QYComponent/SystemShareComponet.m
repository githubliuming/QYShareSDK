//
//  SystemShareComponet.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/16.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "SystemShareComponet.h"
#import "QYShareTool.h"
#import <Social/Social.h>
@implementation SystemShareComponet
@synthesize shareType,platform,delegate;
- (void)shareImage:(UIImage *)image text:(NSString *)text url:(NSURL *)url type:(QYSharePlatform)type completion:(void (^)(NSInteger result))completion
{
    
    NSString * extensionString  = [self getShareShareExtension:type];
    
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:extensionString];
    if (composeVc) {
        
        if ([SLComposeViewController isAvailableForServiceType:extensionString]){
            
            [composeVc setInitialText:text];
            [composeVc addImage:image];
            [composeVc addURL:url];
            composeVc.completionHandler = ^(SLComposeViewControllerResult result) {
                
                if (completion)
                {
                    completion(result);
                }
            };
            [[QYShareTool nx_currentViewController] presentViewController:composeVc
                                                                      animated:YES
                                                                    completion:nil];
            
        } else {
            
            NSLog(@"未登录 type 对应平台的账号");
        }
        
    } else {
        
        NSLog(@"未安装 type 对应的平台");
    }
}

- (NSString *)getShareShareExtension:(QYSharePlatform)platformType{
    
    return [[self extensionTypeDic] objectForKey:@(platformType)];
}

- (NSDictionary *)extensionTypeDic{
    
    return @{
             @(QYSharePlatform_SinaWB):SLServiceTypeSinaWeibo,
             @(QYSharePlatform_FaceBook):SLServiceTypeFacebook,
             @(QYSharePlatform_Twitter):SLServiceTypeTwitter,
             @(QYSharePlatform_QQ_Friend):@"com.tencent.mqq.ShareExtension",
             @(QYSharePlatform_WX_TimerLine):@"com.tencent.xin.sharetimeline",
            };
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return YES;
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

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
                       application:(UIApplication *)application
                     launchOptions:(NSDictionary *)launchOptions {
    
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

@end
