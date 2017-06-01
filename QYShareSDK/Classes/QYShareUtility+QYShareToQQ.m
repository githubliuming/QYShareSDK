//
//  QYShareUtility+QYShareToQQ.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility+QYShareToQQ.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "QYShareTool.h"
@implementation QYShareUtility (QYShareToQQ)

- (void)shareToQQFriend:(NSString *)title
                content:(NSString *)content
                  image:(id)imageContext
                    url:(NSString *)url
                   type:(QYShareType)type{
    if (![TencentOAuth iphoneQQInstalled])
    {
        [self showNotInstallQQ];
        return;
    }
    SendMessageToQQReq * req;
    if([imageContext isKindOfClass:[NSString class]] || [imageContext isKindOfClass:[NSURL class]]){
        
        req = [self buildQQMsg:title content:content imageUrl:imageContext url:url type:type];
    }
    if ([imageContext isKindOfClass:[UIImage class]] || [imageContext isKindOfClass:[NSData class]]) {
        
        req = [self buildQQMsg:title content:content image:imageContext url:url type:type];
    }
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)shareToQQZone:(NSString *)title
              content:(NSString *)content
                image:(id)imageContext
                  url:(NSString *)url
                 type:(QYShareType)type{
    
    if (![TencentOAuth iphoneQQInstalled])
    {
        
        return;
    }
    SendMessageToQQReq * req;
    if([imageContext isKindOfClass:[NSString class]] || [imageContext isKindOfClass:[NSURL class]]){
        
        req = [self buildQQMsg:title content:content imageUrl:imageContext url:url type:type];
    }
    if ([imageContext isKindOfClass:[UIImage class]] || [imageContext isKindOfClass:[NSData class]]) {
        
        req = [self buildQQMsg:title content:content image:imageContext url:url type:type];
    }
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

- (SendMessageToQQReq *)buildQQMsg:(NSString *)title
                           content:(NSString *)content
                             image:(id) imageContext
                               url:(NSString *)url
                              type:(QYShareType)type{
    
    NSData * imageData;
    if ([imageContext isKindOfClass:[NSData class]]) {
        
        imageData = imageContext;
    }
    if ([imageContext isKindOfClass:[UIImage class]]) {
        
        imageData = UIImageJPEGRepresentation(imageContext, 1.0f);
    }
    
    NSData * previewData = [imageData mutableCopy];
    if (previewData.length > 320 * 1024)
    {
        float scale = 0.5;
        while (previewData.length > 320 * 1024)
        {
            previewData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], scale);
            scale = scale * 0.5;
        }
    }
    
    SendMessageToQQReq *req;
    if (type == QYShareTypeVideo)
    {
        QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:url]
                                                               title:title
                                                         description:content
                                                    previewImageData:previewData];
        
        req = [SendMessageToQQReq reqWithContent:videoObj];
    }
    else if (type == QYShareTypeNews)
    {
        QQApiNewsObject *urlObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:title
                                                     description:content
                                                previewImageData:previewData];
        req = [SendMessageToQQReq reqWithContent:urlObj];
    }
    else if (type == QYShareTypeImage)
    {
        NSData *newImageData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.6);
        QQApiImageObject *imageObj = [QQApiImageObject objectWithData:newImageData
                                                     previewImageData:newImageData
                                                                title:title
                                                          description:content
                                                       imageDataArray:nil];
        req = [SendMessageToQQReq reqWithContent:imageObj];
        
        
    }
    
    return req;
}
- (SendMessageToQQReq *)buildQQMsg:(NSString *)title
                           content:(NSString *)content
                          imageUrl:(id)imageContext
                               url:(NSString *)url
                              type:(QYShareType)type{
    SendMessageToQQReq *req;
    
    NSURL * imageUrl;
    if ([imageContext isKindOfClass:[NSURL class]]) {
        
        imageUrl = imageContext;
    }
    if ([imageContext isKindOfClass:[NSString class]]) {
        
        imageUrl = [NSURL URLWithString:imageContext];
    }
    if (type == QYShareTypeVideo)
    {
        QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:url]
                                                               title:title
                                                         description:content
                                                     previewImageURL:imageUrl];
        req = [SendMessageToQQReq reqWithContent:videoObj];
    }
    else if (type == QYShareTypeNews)
    {
        QQApiNewsObject *urlObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:title
                                                     description:content
                                                 previewImageURL:imageUrl];
        
        req = [SendMessageToQQReq reqWithContent:urlObj];
    }
    
    return req;
}
#pragma mark qq delegate
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    NSLog(@"sendResult %d", sendResult);
    switch (sendResult)
    {
        case EQQAPISENDSUCESS:
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
            //            {
            //                // qq 的不向外发出代理 bugfix on ios9.0
            //                //                [self.delegate publishFinishedWith:self.share_type];
            //            }
            break;
        case EQQAPIAPPNOTREGISTED:
        {
            NSLog(@"App未注册");
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            //            {
            //                [self.delegate publishFailedWith:PLSHAREPLATFROM_QQ_FRIEND errorString:@"App未注册"];
            //            }
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            NSLog(@"发送参数错误");
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            //            {
            //                [self.delegate publishFailedWith:PLSHAREPLATFROM_QQ_FRIEND errorString:@"发送参数错误"];
            //            }
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            [self showNotInstallQQ];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            NSLog(@"API接口不支持");
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            //            {
            //                [self.delegate publishFailedWith:PLSHAREPLATFROM_QQ_FRIEND errorString:@"API接口不支持"];
            //            }
            break;
        }
        case EQQAPISENDFAILD:
        {
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            //            {
            //                [self.delegate publishFailedWith:PLSHAREPLATFROM_QQ_FRIEND
            //                                     errorString:[NSString stringWithFormat:@"QQAPI error code %d", sendResult]];
            //            }
            
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void) showNotInstallQQ{
    
    [QYShareTool alert:@"提示" msg:@"未安装QQ"];
}
@end
