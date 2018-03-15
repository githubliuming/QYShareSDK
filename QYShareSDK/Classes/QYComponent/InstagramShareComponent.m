//
//  InstagramShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/15.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "InstagramShareComponent.h"
#import "QYShareTool.h"
@implementation InstagramShareComponent
@synthesize delegate,platform,shareType;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
{
    
}

- (void)authoried
{
    
}

- (BOOL)hasAuthorized {
    
    return YES;
}

- (BOOL)isInstallAPPClient
{
    return [QYShareTool canOpenUrlShemes:@"instagram://"];
}

- (void)shareGif:(id<QYShareConfig>)interface
{
    [self shareMediaToInstagramWithAlbumUrl:[NSURL URLWithString:[interface getShareUrl]]];
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    [self shareMediaToInstagramWithAlbumUrl:[NSURL URLWithString:[interface getShareUrl]]];
}

- (void)shareText:(id<QYShareConfig>)interface
{
    NSLog(@"Instagram  不支持分享纯文字");
}

- (void)shareUrl:(id<QYShareConfig>)interface
{
    NSLog(@"Instagram  不支持分享链接");
}

- (void)shareVideo:(id<QYShareConfig>)interface
{
    [self shareMediaToInstagramWithAlbumUrl:[NSURL URLWithString:[interface getShareUrl]]];
}

- (void)shareMediaToInstagramWithAlbumUrl:(NSURL *)albumUrl
{
    NSString *caption = @"#Philm";
    NSURL *instagramURL =
    [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",
                          [[albumUrl absoluteString]
                           stringByAddingPercentEncodingWithAllowedCharacters:
                           [NSCharacterSet alphanumericCharacterSet]],
                          [caption stringByAddingPercentEncodingWithAllowedCharacters:
                           [NSCharacterSet alphanumericCharacterSet]]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    else
    {
        NSLog(@"Can't open Instagram  %@,请检查是否安装 Instagram，或者infoPlist文件中有没有将 Instagram 加入白名单", instagramURL.absoluteString);
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    
    return YES;
}

@end
