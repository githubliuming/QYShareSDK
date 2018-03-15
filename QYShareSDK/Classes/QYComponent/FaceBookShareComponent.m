//
//  FaceBookShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/14.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "FaceBookShareComponent.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import "QYShareTool.h"
@interface FaceBookShareComponent()<FBSDKSharingDelegate>
@end
@implementation FaceBookShareComponent

@synthesize platform,delegate,shareType;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
{
}

- (void)shareGif:(id<QYShareConfig>)interface
{
    NSLog(@"faceBook 不支持分享Gif");
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    FBSDKSharePhotoContent * photoContent = [self FBBuildPhotosContent:@[[interface getShareImage]]];
    [self shareToFB:photoContent];
}

- (void)shareText:(id<QYShareConfig>)interface
{
    NSLog(@" faceBook 分享纯文字 待查资料。目前未实现");
}

- (void)shareUrl:(id<QYShareConfig>)interface
{
    FBSDKShareLinkContent * linkContent = [self fbBuildLinkContent: [interface getShareUrl]
                                                     contentString:[interface getShareContent]];
    [self shareToFB:linkContent];
}

- (void)shareVideo:(id<QYShareConfig>)interface
{
    FBSDKShareVideoContent *content = [self fbBuildVideoContent:[NSURL URLWithString:[interface getShareUrl]]];
    
//    content.hashtag = [FBSDKHashtag hashtagWithString:@"#Philm"];
    [self shareToFB:content];
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
- (void)shareToFB:(id<FBSDKSharingContent>)content
{
    if (content)
    {
        FBSDKShareDialog *dialog = [FBSDKShareDialog showFromViewController:[UIViewController alloc]
                                                                withContent:content
                                                                   delegate:self];
        dialog.mode = FBSDKShareDialogModeShareSheet;
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
        NSLog(@" content is nil");
    }
}

- (void)authoried
{
    NSLog(@"facebook 暂时不实现授权处理");
}

- (BOOL)hasAuthorized
{
    return YES;
}

- (BOOL)isInstallAPPClient
{
    return [QYShareTool canOpenUrlShemes:@"fbauth2://"];
}
#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"faceBook %@", results);
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
    {
        [self.delegate publishFinishedWith:self.platform];
    }
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"faceBook share fail %@", [error userInfo]);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)]) {
        [self.delegate publishFailedWith:self.platform errorString:[error description]];
    }
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"faceBook share didCancel ");
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
    
   return  [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
}
@end
