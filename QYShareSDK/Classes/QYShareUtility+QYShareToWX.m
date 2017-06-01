//
//  QYShareUtility+QYShareToWX.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "QYShareUtility+QYShareToWX.h"
#import "QYShareTool.h"

@implementation QYShareUtility (QYShareToWX)

- (void)shareToWXContact:(NSString *)title content:(NSString *)content image:(NSData *)imageData url:(NSString *)url type:(QYShareType) type
{
    
    if (![WXApi isWXAppInstalled])
    {
        [QYShareTool alert:@"提示" msg:@"未安装微信"];
        return ;
    }
    
    WXMediaMessage * message = [self buildWXMessage:title content:content image:imageData url:url type:type];
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
- (void)shareToWXTimeline:(NSString *)title content:(NSString *)content image:(NSData *)imageData url:(NSString * )url type:(QYShareType) type{
    
    if (![WXApi isWXAppInstalled])
    {
        [QYShareTool alert:@"提示" msg:@"未安装微信"];
        return ;
    }
    WXMediaMessage * message = [self buildWXMessage:title content:content image:imageData url:url type:type];
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}
- (WXMediaMessage *)buildWXMessage:(NSString *)title content:(NSString *)content image:(NSData *)imageData url:(NSString *)url type:(QYShareType) type{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    
    if (imageData.length > 32 * 1024.0f) {
        
        UIImage * image = [UIImage imageWithData:imageData];
        imageData = [QYShareTool scaleThumbImageData:image];
    }
    [message setThumbData:imageData];
    
    if (type == QYShareTypeVideo) {
        
        NSLog(@"微信好友 imageUrl 发的是视频");
        WXVideoObject *ext = [WXVideoObject object];
        // url 是HTML 地址 不是MP4地址
        ext.videoUrl = url;
        
        message.mediaObject = ext;
    }
    if (type == QYShareTypeImage) {
        
        WXImageObject *ext = [WXImageObject object];
        
        ext.imageData = imageData;
        message.mediaObject = ext;
    }
    if (type == QYShareTypeNews)
    {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        message.mediaObject = ext;
    }
    
    return message;
}
@end
