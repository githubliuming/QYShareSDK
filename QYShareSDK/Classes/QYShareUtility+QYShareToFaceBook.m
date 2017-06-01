//
//  QYShareUtility+QYShareToFaceBook.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility+QYShareToFaceBook.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import "QYShareTool.h"

#define _is_ipad ([[UIDevice currentDevice].model hasPrefix:@"iPad"])

@implementation QYShareUtility (QYShareToFaceBook)

#pragma mark - share to faceBook
- (void)shareVideToFaceBook:(NSString *)videoPath
{
    if ([self canOpenFaceBook])
    {
                [QYShareTool saveToAlbum:videoPath
                      complandler:^(NSURL *url, NSError *error) {
                          if (error == nil)
                          {
                              [self shareVideToFaceBookWithAlbumUrl:url];
                          }
                          else
                          {
//                              [self showAlertWithTitle:NXLocalizedString(@"Local_storage_full")];
                              NSLog(@"error  写入视频到相册失败  error info = %@",[error userInfo]);
                          }
                      }];
    }
    else
    {
        [self showNotInstallFaceBook];
    }
}
- (void)shareVideToFaceBookWithAlbumUrl:(NSURL *)url
{
    if ([self canOpenFaceBook])
    {
        FBSDKShareVideoContent *content = [self fbBuildVideoContent:url];
        content.hashtag = [FBSDKHashtag hashtagWithString:@"#Philm"];
        [self shareToFB:content];
    }
    else
    {
        [self showNotInstallFaceBook];
    }
}


- (void)shareImagesToFaceBook:(NSArray *)images
{
    if ([self canOpenFaceBook])
    {
        FBSDKSharePhotoContent *content = [self FBBuildPhotosContent:images];
        // content.hashtag = [FBSDKHashtag hashtagWithString:@"#Philm"];
        [self shareToFB:content];
    }
    else
    {
        [self showNotInstallFaceBook];
    }
}

#pragma mark - share to messeger
- (void)shareVideoToMessager:(NSString *)videoPath
{
    if ([self canOpenMessager])
    {
        if (_is_ipad)
        {
            [FBSDKMessengerSharer shareVideo:[NSData dataWithContentsOfFile:videoPath] withOptions:nil];
        }
        else
        {
            NSData *videoData = [NSData dataWithContentsOfFile:videoPath];
            [FBSDKMessengerSharer shareVideo:videoData withOptions:nil];
        }
    }
    else
    {
        [self showNotInstallMessager];
    }
}
- (void)shareVideoToMessagerWithAlbumUrl:(NSURL *)url
{
    if ([self canOpenMessager])
    {
        FBSDKShareVideoContent *content = [self fbBuildVideoContent:url];
        [self shareToMessger:content];
    }
    else
    {
        [self showNotInstallMessager];
    }
}
- (void)shareImageToMessger:(NSArray *)images
{
    if ([self canOpenMessager])
    {
        if (_is_ipad)
        {
            if (images.count > 0)
            {
                UIImage *image = [images firstObject];
                [FBSDKMessengerSharer shareImage:image withOptions:nil];
            }
        }
        else
        {
            FBSDKSharePhotoContent *content = [self FBBuildPhotosContent:images];
            [self shareToMessger:content];
        }
    }
    else
    {
        [self showNotInstallMessager];
    }
}


#pragma mark mark alert

- (void)showNotInstallFaceBook
{
    
    [self showAlert:@"未安装faceBook"];
}
- (void) showNotInstallMessager{
    
    [self showAlert:@"未安装messeager"];
}

- (void) showAlert:(NSString *)msg{
    
    [QYShareTool alert:@"提示" msg:msg];
}
#pragma mark - faceBook share
- (void)shareToFB:(id<FBSDKSharingContent>)content
{
    if (content)
    {
        FBSDKShareDialog *dialog = [FBSDKShareDialog showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                                                withContent:content
                                                                   delegate:nil];
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
#pragma  mark - messager share
- (void)shareToMessger:(id<FBSDKSharingContent>)content
{
    if (content)
    {
        FBSDKMessageDialog *dialog =
        [FBSDKMessageDialog showWithContent:content delegate:nil];
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

#pragma mark - faceBook buildContent
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

- (FBSDKShareMediaContent *)fbBuldeMedaiContent:(UIImage *)image
{
    FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:NO];
    FBSDKShareMediaContent *content = [[FBSDKShareMediaContent alloc] init];
    content.media = @[ photo ];
    return content;
}

#pragma mark -是否能打开 faceBook messager
- (BOOL)canOpenMessager
{
    return [QYShareTool canOpenUrl:@"fb-messenger-api://"] || [QYShareTool canOpenUrl:@"fb-messenger-platform://"];
}

- (BOOL)canOpenFaceBook { return [QYShareTool canOpenUrl:@"fbauth2://"]; }
@end
