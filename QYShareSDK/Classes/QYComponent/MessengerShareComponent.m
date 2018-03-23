//
//  MessengerShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/15.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "MessengerShareComponent.h"
#import "QYShareTool.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface MessengerShareComponent()<FBSDKSharingDelegate,FBSDKMessengerURLHandlerDelegate>
@property(nonatomic,strong) FBSDKMessengerURLHandler * messengerUrlHandler;
@end
@implementation MessengerShareComponent

@synthesize platform,delegate,shareType;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
                       application:(UIApplication *)application
                     launchOptions:(NSDictionary*)launchOptions
{
    
    _messengerUrlHandler = [[FBSDKMessengerURLHandler alloc] init];
    _messengerUrlHandler.delegate = self;
    
}


- (void)shareGif:(id<QYShareConfig>)interface
{
    NSData * gifData = [NSData dataWithContentsOfFile:interface.gifPath];
    [FBSDKMessengerSharer shareAnimatedGIF:gifData withOptions:nil];
    NSLog(@"Messenger 不支持分享Gif");
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    BOOL _is_ipad = [[UIDevice currentDevice].model hasPrefix:@"iPad"];
    if (_is_ipad)
    {
        UIImage *image = [interface.images firstObject];
        [FBSDKMessengerSharer shareImage:image withOptions:nil];
    }
    else
    {
        
        FBSDKSharePhotoContent *content = [self FBBuildPhotosContent:interface.images];
        [self shareToMessger:content];
    }
}

- (void)shareText:(id<QYShareConfig>)interface
{
    NSLog(@"Messenger 分享纯文字 待查资料实现");
}

- (void)shareUrl:(id<QYShareConfig>)interface
{
    FBSDKShareLinkContent * linkContent = [self fbBuildLinkContent:interface.url
                                                     contentString:interface.content];
    [self shareToMessger:linkContent];
}

- (void)shareVideo:(id<QYShareConfig>)interface
{
    NSData *videoData = [NSData dataWithContentsOfFile:interface.url];
    [FBSDKMessengerSharer shareVideo:videoData withOptions:nil];
}
- (void)authoried {
    
}

#pragma mark-- 构建分享模板 faceBook 和 messager可以公用一套分享模板
- (FBSDKSharePhotoContent *)FBBuildPhotosContent:(NSArray<UIImage *> *)images
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (UIImage *image in images)
    {
        FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:NO];
        [photos addObject:photo];
    }
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = photos;
    return content;
}
- (FBSDKShareVideoContent *)fbBuildVideoContent:(NSURL *)albumUrl
{
    FBSDKShareVideo *video = [FBSDKShareVideo videoWithVideoURL:albumUrl];
    video.videoURL = albumUrl;
    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.video = video;
    return content;
}
- (FBSDKShareLinkContent *)fbBuildLinkContent:(NSString *)url contentString:(NSString *)cString
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:url];
    content.contentDescription = cString;
    return content;
}

- (void)shareToMessger:(id<FBSDKSharingContent>)content
{
    if (content)
    {
        FBSDKMessageDialog *dialog =
        [FBSDKMessageDialog showWithContent:content delegate:self];
        NSError *error = nil;
        [dialog validateWithError:&error];
        if (error)
        {
            NSLog(@" share messenger error %@", error);
        }
        if ([dialog canShow])
        {
            NSLog(@"open facebook");
        }
        else
        {
            NSLog(@"can not open facebook");
        }
    }
    else
    {
        NSLog(@"content is nil");
    }
}

- (BOOL)hasAuthorized
{
    return YES;
}

- (BOOL)isInstallAPPClient
{
    return [QYShareTool  canOpenUrlShemes:@"fb-messenger-api://"] || [QYShareTool canOpenUrlShemes:@"fb-messenger-platform://"];
}

#pragma mark FBSDKSharingDelegate
#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"Messenger %@", results);
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
    {
        [self.delegate publishFinishedWith:self.platform];
    }
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"Messenger share fail %@", [error userInfo]);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)]) {
        [self.delegate publishFailedWith:self.platform errorString:[error description]];
    }
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"Messenger share didCancel ");
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishCanceldedWith:)])
    {
        [self.delegate publishCanceldedWith:self.platform];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    
    BOOL handled = YES;
    if ([_messengerUrlHandler canOpenURL:url sourceApplication:sourceApplication])
    {
        // Handle the url
        handled = [_messengerUrlHandler openURL:url sourceApplication:sourceApplication];
    }
    return handled;
}

#pragma mark- deleage
- (void)messengerURLHandler:(FBSDKMessengerURLHandler *)messengerURLHandler
  didHandleReplyWithContext:(FBSDKMessengerURLHandlerReplyContext *)context{
    
}

- (void)messengerURLHandler:(FBSDKMessengerURLHandler *)messengerURLHandler
didHandleOpenFromComposerWithContext:(FBSDKMessengerURLHandlerOpenFromComposerContext *)context
{
    
}
- (void)messengerURLHandler:(FBSDKMessengerURLHandler *)messengerURLHandler
 didHandleCancelWithContext:(FBSDKMessengerURLHandlerCancelContext *)context{
    
}
@end
