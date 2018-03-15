//
//  QYQQShare- (id<QYShareComponentBaseDelegate>)getShareInterfaceWithPlatform:(QYSharePlatform) platform; QQShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "QQSharecomponent.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//#import <TencentOpenAPI/TencentApiInterface.h>

#define ACCESSTOKEN @"ACCESSTOKEN"
#define QQCONNECT_TOKEN_DIC @"QQCONNECT_TOKEN_DIC"
#define QQ_USER_INFO_DIC @"QQ_USER_INFO_DIC"

@interface QQShareComponent()<QQApiInterfaceDelegate,TencentSessionDelegate>
@property(nonatomic,strong)TencentOAuth * tencentOAuth;
@property(nonatomic,strong) NSMutableArray * permissions;
@end
@implementation QQShareComponent
@synthesize shareType,delegate,platform;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                        secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    QQApiObject * imageObject;
    if([self isShareToZone])
    {
        imageObject = [self buildImageObject:interface];
    }
    else
    {
        imageObject = [self buildImageObjectForQQZone:interface];
    }
    [self sendShareObject:imageObject];
}
- (void)shareVideo:(id<QYShareConfig>)interface
{
    QQApiVideoObject * videoObject = [self buildVideoObject:interface];
    [self sendShareObject:videoObject];
}
- (void)shareUrl:(id<QYShareConfig>)interface
{
    QQApiNewsObject * newsObject = [self buildNewsObject:interface];
    [self sendShareObject:newsObject];
}
- (void)shareGif:(id<QYShareConfig>)interface
{
    QQApiObject *object;
    if ([self isShareToZone])
    {
        object = [self buildImageObjectForQQZone:interface];
    }
    else
    {
        object = [self buildImageObject:interface];
    }
    [self sendShareObject:object];
}
- (void)shareText:(id<QYShareConfig>)interface
{
    QQApiTextObject * textObject = [self buildTextObject:interface];
    [self sendShareObject:textObject];
}
#pragma mark - 构建分享对象
- (QQApiTextObject *)buildTextObject:(id<QYShareConfig>)config
{
    QQApiTextObject * textObject;
    if(config)
    {
        textObject = [[QQApiTextObject alloc] initWithText:[config getShareContent]];
    }
    return textObject;
}
- (QQApiVideoObject *)buildVideoObject:(id<QYShareConfig>)config
{
    QQApiVideoObject * videoObj;
    if(config)
    {
        videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:[config getShareUrl]]
                                             title:[config getShareTitile]
                                       description:[config getShareContent]
                                   previewImageURL:[NSURL URLWithString:[config getImageUrl]]];
    }
    return videoObj;
}
-(QQApiNewsObject *)buildNewsObject:(id<QYShareConfig>)config
{
    QQApiNewsObject * newsObj;
    if(config)
    {
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[config getShareUrl]]
                                           title:[config getShareTitile]
                                     description:[config getShareContent]
                                previewImageData:[config getShareImageData]];
    }
    return newsObj;
}
- (QQApiImageObject *)buildImageObject:(id<QYShareConfig>)config
{
    QQApiImageObject * imageObject;
    if(config)
    {
        UIImage *image = [config getShareImage];
        NSData * preImageData = [self getPreImageWithImage:image];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
        if(self.shareType == QYShareTypeGif)
        {
            imageData = [NSData dataWithContentsOfFile:[config getGifPath]];
        }
        imageObject = [QQApiImageObject objectWithData:imageData
                                      previewImageData:preImageData
                                                 title:[config getShareTitile]
                                           description:[config getShareContent]
                                        imageDataArray:nil];
    }
    return imageObject;
}
- (QQApiImageArrayForQZoneObject *)buildImageObjectForQQZone:(id<QYShareConfig>)config
{
    QQApiImageArrayForQZoneObject * zoneObject;
    if (config)
    {
        UIImage * image = [config getShareImage];
        NSData * imageData = UIImagePNGRepresentation(image);
        if(self.shareType == QYShareTypeGif)
        {
            imageData = [NSData dataWithContentsOfFile:[config getGifPath]];
        }
        zoneObject = [QQApiImageArrayForQZoneObject objectWithimageDataArray:@[imageData]
                                                                       title:[config getShareTitile]
                                                                      extMap:nil];
        zoneObject.shareDestType = ShareDestTypeQQ;
    }
    return  zoneObject;
}
- (NSData *)getPreImageWithImage:(UIImage *)image{
    
    NSData *previewData = UIImagePNGRepresentation(image);
    float scale = 0.8;
    while (previewData.length > 1024 * 1024)
    {
        previewData = UIImageJPEGRepresentation(image, scale);
    }
    return  previewData;
}

- (BOOL)isShareToZone
{
    return self.platform == QYSharePlatform_QQ_Zone;
}
#pragma mark - 发起分享
- (void)sendShareObject:(QQApiObject *)object
{
    QQApiSendResultCode sent;
    SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:object];
    if([self isShareToZone])
    {
        sent = [QQApiInterface SendReqToQZone:req];
    }
    else
    {
        sent = [QQApiInterface sendReq:req];
    }
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    NSLog(@"sendResult %d", sendResult);
    switch (sendResult)
    {
        case EQQAPISENDSUCESS:
            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
            {
                // qq 的不向外发出代理 bugfix on ios9.0
                //                [self.delegate publishFinishedWith:self.share_type];
            }
            break;
        case EQQAPIAPPNOTREGISTED:
        {
            NSLog(@"App未注册");
            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            {
                [self.delegate publishFailedWith:self.platform errorString:@"App未注册"];
            }
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            NSLog(@"发送参数错误");
            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            {
                [self.delegate publishFailedWith:self.platform errorString:@"发送参数错误"];
            }
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
//            msgbox = [[PLAlertView alloc] init];
//            [msgbox showWithTitle:@"未安装手机QQ"
//                        backImage:[UIImage nx_screenHierarchyShots:[UIApplication sharedApplication].keyWindow]
//                        btnsArray:[NSMutableArray arrayWithObjects:@"确定", nil]];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            NSLog(@"API接口不支持");
            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            {
                [self.delegate publishFailedWith:self.platform errorString:@"API接口不支持"];
            }
            break;
        }
        case EQQAPISENDFAILD:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            {
                [self.delegate publishFailedWith:self.platform
                                     errorString:[NSString stringWithFormat:@"QQAPI error code %d", sendResult]];
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
}
#pragma mark - 检测安装
- (BOOL)isInstallAPPClient
{
    return [TencentOAuth iphoneQQInstalled];
}
#pragma mark -
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL  handled = [TencentOAuth HandleOpenURL:url];
    if (!handled)
    {
        handled = [QQApiInterface handleOpenURL:url delegate:self];
    }
    return handled;
}
#pragma mark - 授权模块

/**
 检测第三方平台是否已经授权
 
 @return YES 授权 ,NO 未授权
 */
- (BOOL)hasAuthorized
{
    return [_tencentOAuth isSessionValid];
}

/**
 发起授权
 */
- (void)authoried
{
    if([self isInstallAPPClient])
    {
        if([self isShareToZone])
        {
            [_tencentOAuth authorize:@[ kOPEN_PERMISSION_ADD_SHARE ]];
        }
        else
        {
             [_tencentOAuth authorize:self.permissions inSafari:NO];
        }
    }
    else
    {
        NSLog(@"未安装 QQ");
    }
}
#pragma mark - QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
    if ([resp isMemberOfClass:[SendMessageToQQReq class]])
    {
        NSLog(@"------- 匹配成功了 ---------");
    }
    // -4 分享取消  0 分享成功
    if (self.delegate)
    {
        if (resp.result.integerValue == 0)
        {
            if ([self.delegate respondsToSelector:@selector(publishFinishedWith:)])
            {
                [self.delegate publishFinishedWith:self.platform];
            }
        }
        else if (resp.result.integerValue == -4)
        {
            if ([self.delegate respondsToSelector:@selector(publishCanceldedWith:)])
            {
                [self.delegate publishCanceldedWith:self.platform];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            {
                [self.delegate publishFailedWith:self.platform errorString:resp.errorDescription];
            }
        }
    }
    NSLog(@"class -- %@", NSStringFromClass([resp class]));
    NSLog(@"qq 返回结果 %@", resp.result);
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    
    
}
#pragma mark -TencentSessionDelegate
- (BOOL) tencentWebViewShouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return YES;
}
- (NSUInteger) tencentWebViewSupportedInterfaceOrientationsWithWebkit
{
    return NO;
}
- (BOOL) tencentWebViewShouldAutorotateWithWebkit
{
    return YES;
    
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    NSLog(@"登录成功后");
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        NSMutableDictionary *tecentDic = [[NSMutableDictionary alloc] init];
        [tecentDic setValue:[NSString stringWithFormat:@"%@", _tencentOAuth.openId] forKey:@"openId"];
        [tecentDic setValue:[NSString stringWithFormat:@"%@", _tencentOAuth.accessToken] forKey:ACCESSTOKEN];
        [tecentDic setValue:[NSString stringWithFormat:@"%@", _tencentOAuth.expirationDate] forKey:@"expires"];
        
        [[NSUserDefaults standardUserDefaults] setObject:tecentDic forKey:QQCONNECT_TOKEN_DIC];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFinished:With:)])
        {
            [self.delegate authorizedFinished:tecentDic With:self.platform];
        }
        //取个人信息 不应该自动取。TODO
        if (![_tencentOAuth getUserInfo])
        {
            NSLog(@"ADFASDFADS 可能授权已过期，请重新获取");
            //        [self showInvalidTokenOrOpenIDMessage];
        }
    }
    else
    {
        NSError *aError = [[NSError alloc]
                           initWithDomain:@""
                           code:1
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"tencentOAuth accessToken error",
                                     NSLocalizedDescriptionKey, nil]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
        {
            [self.delegate authorizedFailed:aError With:self.platform];
        }
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"登录失败");
    if (cancelled)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedCancelded:With:)])
        {
            [self.delegate authorizedCancelded:nil With:self.platform];
        }
    }
    else
    {
        NSError *aError = [[NSError alloc]
                           initWithDomain:@""
                           code:cancelled
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"QQ主动退出", NSLocalizedDescriptionKey, nil]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
        {
            [self.delegate authorizedFailed:aError With:self.platform];
        }
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    NSLog(@"网络有问题");
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
    {
        NSError *aError =
        [[NSError alloc] initWithDomain:@""
                                   code:1
                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"tencentDidNotNetWork",
                                         NSLocalizedDescriptionKey, nil]];

        [self.delegate authorizedFailed:aError With:self.platform];
    }
}
//取个人信息反回结果
- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSMutableString *str = [NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse)
        {
            [str appendString:[NSString stringWithFormat:@"%@:%@\n", key, [response.jsonResponse objectForKey:key]]];
        }
        
        NSLog(@"%@取QQ个人信息返回成功: %@", self.delegate, str);
        if (self.delegate && [self.delegate respondsToSelector:@selector(getUserInfoSucceedWithInfoDic:with:)])
        {
            NSMutableDictionary *JsonRes = [[NSMutableDictionary alloc] initWithDictionary:response.jsonResponse];
            if ([JsonRes objectForKey:@"nickname"] == nil)
            {
                [JsonRes setObject:@"用户名未设置" forKey:@"nickname"];
            }

            [[NSUserDefaults standardUserDefaults] setObject:JsonRes forKey:QQ_USER_INFO_DIC];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.delegate getUserInfoSucceedWithInfoDic:response.jsonResponse with:self.platform];
        }
    }
    else
    {
        NSLog(@"取QQ个人信息失败: %@", response.errorMsg);
        if (self.delegate && [self.delegate respondsToSelector:@selector(getUserInfoFaileWithErrorMsg:with:)])
        {
            [self.delegate getUserInfoFaileWithErrorMsg:response.errorMsg with:self.platform];
        }
    }
}
#pragma mark - getter/setter
-(NSMutableArray *)permissions
{
    if(_permissions == nil)
    {    
       _permissions = [NSMutableArray
           arrayWithObjects:kOPEN_PERMISSION_ADD_TOPIC, kOPEN_PERMISSION_ADD_ONE_BLOG, kOPEN_PERMISSION_ADD_ALBUM,
           kOPEN_PERMISSION_UPLOAD_PIC, kOPEN_PERMISSION_LIST_ALBUM, kOPEN_PERMISSION_ADD_SHARE,
           kOPEN_PERMISSION_CHECK_PAGE_FANS, kOPEN_PERMISSION_GET_INFO,
           kOPEN_PERMISSION_GET_OTHER_INFO, kOPEN_PERMISSION_GET_VIP_INFO,
           kOPEN_PERMISSION_GET_VIP_RICH_INFO, kOPEN_PERMISSION_GET_USER_INFO,
           kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    }
    return _permissions;
}
@end
