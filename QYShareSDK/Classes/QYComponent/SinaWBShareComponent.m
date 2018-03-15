//
//  SinaWBShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "SinaWBShareComponent.h"
#import "WeiboSDK.h"

#define SINAWEIBO_TOKEN_DIC @"SINAWEIBO_TOKEN_DIC"
#define SINA_USER_INFO_DIC @"SINA_USER_INFO_DIC"
#define ACCESSTOKEN @"ACCESSTOKEN"
#define SHAREMESSAGEWEBPAGEURL @"http://www.yoyoim.com"

@interface SinaWBShareComponent()<WBHttpRequestDelegate,WeiboSDKDelegate>
@property(nonatomic,strong)NSString * redirectUrl;
@end
@implementation SinaWBShareComponent
@synthesize platform,delegate,shareType;
- (void)registerInterfaceWithAPPID:(NSString *)appId
                        secretKey:(NSString *)secretKey
                        redirectUrl:(NSString *)redirectUrl
{
    self.redirectUrl = redirectUrl;
    /*
     新浪微博
     */
    [WeiboSDK enableDebugMode:NO];
    // kSinaAppKey
    [WeiboSDK registerApp:appId];
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    [self sendWBMessage:interface];
}
- (void)shareVideo:(id<QYShareConfig>)interface
{
    [self sendWBMessage:interface];
}
- (void)shareUrl:(id<QYShareConfig>)interface
{
    [self sendWBMessage:interface];
}
- (void)shareGif:(id<QYShareConfig>)interface
{
    //    注意 shareTitle的格式:安全域名 + 分享文案 (内容不超过140个汉字，文本中不能包含“#话题词#”，同时文本中必须包含至少一个第三方分享到微博的网页URL，且该URL只能是该第三方（调用方）绑定域下的URL链接)  还有一定要进行URLencode
    NSString * title = [interface getShareTitile];
    NSData * gifData = [NSData dataWithContentsOfFile:[interface getGifPath]];
    NSDictionary *sinaDic = [[NSUserDefaults standardUserDefaults] objectForKey:SINAWEIBO_TOKEN_DIC];
    NSString * shareTitle_ = [NSString stringWithFormat:@"http://www.philm.cc %@",title];
    shareTitle_ = [shareTitle_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * token = sinaDic[ACCESSTOKEN];
    token = [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * paramDic = @{@"access_token":token,@"status":shareTitle_,@"pic":gifData};
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/share.json"
                       httpMethod:@"POST"
                           params:paramDic
                         delegate:self
                          withTag:@"2"];
    
}
- (void)shareText:(id<QYShareConfig>)interface
{
    [self sendWBMessage:interface];
}

- (WBSendMessageToWeiboRequest *)buildWBRequest:(WBMessageObject*)message
                                  authorRequest:(WBAuthorizeRequest *)authorRequest{
    
     NSDictionary *sinaDic = [[NSUserDefaults standardUserDefaults] objectForKey:SINAWEIBO_TOKEN_DIC];
    NSString * token = sinaDic[ACCESSTOKEN];
    WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:message
                                                                                   authInfo:authorRequest access_token:token];
    request.userInfo = @{
                         @"ShareMessageFrom" : @"SendMessageToWeiboViewController",
                         @"Other_Info_1" : [NSNumber numberWithInt:123],
                         @"Other_Info_2" : @[ @"obj1", @"obj2" ],
                         @"Other_Info_3" : @{@"key1" : @"obj1", @"key2" : @"obj2"}
                         };
    return request;
}

- (WBAuthorizeRequest *)buildAuthorizeRequest
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"wwww.sina.com";
    authRequest.scope = @"all";
    return authRequest;
}

- (WBImageObject *)buidImageObject:(id<QYShareConfig>)config
{
    WBImageObject * imageObject;
    if (config)
    {
        imageObject = [[WBImageObject alloc] init];
        imageObject.imageData = UIImagePNGRepresentation([config getShareImage]);
    }
    return imageObject;
}
- (WBMessageObject *)buildMessage:(id<QYShareConfig>)config
{
    NSString * title = [config getShareTitile];
    if (title.length == 0)
    {
        title = [config getShareContent];
    }
    NSString * url = [config getShareUrl];
    NSString *shareTextStr;
    NSRange range = [title rangeOfString:@"http://"];
    if (range.location == NSNotFound)
    {
        shareTextStr = [NSString stringWithFormat:@"%@ %@", title, url];
    }
    else
    {
        shareTextStr = title;
    }
    WBMessageObject *message = [WBMessageObject message];
    message.text = shareTextStr;
    WBImageObject * imageOjbect = [self buidImageObject:config];
    if (imageOjbect)
    {
        message.imageObject = imageOjbect;
    }
    return message;
}

- (void)sendWBMessage:(id<QYShareConfig>)config
{
    WBMessageObject * message = [self buildMessage:config];
    WBAuthorizeRequest * authorizeRequest = [self buildAuthorizeRequest];
    WBSendMessageToWeiboRequest * sendRequest = [self buildWBRequest:message authorRequest:authorizeRequest];
    [WeiboSDK sendRequest:sendRequest];
}
#pragma mark - 授权模块
- (void)authoried
{
    //授权
    NSLog(@"微博重定向url = %@",self.redirectUrl);
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectUrl;
    request.scope = @"all";
    request.userInfo = @{
                         @"SSO_From" : @"PLEditMovieVC",
                         @"Other_Info_1" : [NSNumber numberWithInt:123],
                         @"Other_Info_2" : @[ @"obj1", @"obj2" ],
                         @"Other_Info_3" : @{@"key1" : @"obj1", @"key2" : @"obj2"}
                         };
    [WeiboSDK sendRequest:request];
}


- (BOOL)hasAuthorized
{
    BOOL bRet = NO;
    NSDictionary *sinaDic = [[NSUserDefaults standardUserDefaults] objectForKey:SINAWEIBO_TOKEN_DIC];
    
    if (sinaDic)
    {  //已经有token
        // ACCESSTOKEN
        if ([[sinaDic objectForKey:ACCESSTOKEN] length] != 0)
        {
            NSDate *date = (NSDate *)[sinaDic objectForKey:@"expirationDate"];
            if (date && ([[NSDate date] compare:date] == NSOrderedAscending))
            {
                bRet = YES;
            }
        }
    }
    return bRet;
}


- (BOOL)isInstallAPPClient
{
    return [WeiboSDK isWeiboAppInstalled];
}


#pragma mark sina delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {  //认证结果
        switch (response.statusCode)
        {
            case WeiboSDKResponseStatusCodeSuccess:
            {
                NSString *token = [(WBAuthorizeResponse *)response accessToken];
                NSString *sinaid = [(WBAuthorizeResponse *)response userID];
                NSDate *expirationDate = [(WBAuthorizeResponse *)response expirationDate];
                
                NSMutableDictionary *wbDic = [[NSMutableDictionary alloc] init];
                [wbDic setValue:sinaid forKey:@"openId"];
                [wbDic setValue:token forKey:ACCESSTOKEN];
                
                [wbDic setValue:expirationDate forKey:@"expirationDate"];
                
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:wbDic forKey:SINAWEIBO_TOKEN_DIC];
                [userDefaults synchronize];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFinished:With:)])
                {
                    [self.delegate authorizedFinished:wbDic With:self.platform];
                }
                [self loginWithSina];
                
                break;
            }
            case WeiboSDKResponseStatusCodeUserCancel:
            {
                NSLog(@"用户取消了授权");
                break;
            }
            default:
            {
                NSError *aError = [[NSError alloc]
                                   initWithDomain:@""
                                   code:1
                                   userInfo:[NSDictionary
                                             dictionaryWithObjectsAndKeys:
                                             [NSString stringWithFormat:@"WeiboSDKResponseStatusCodeAuthDeny_%ld",
                                              (long)response.statusCode],
                                             NSLocalizedDescriptionKey, nil]];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
                {
                    [self.delegate authorizedFailed:aError With:self.platform];
                }
            }
                break;
        }
    }
    else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        switch (response.statusCode)
        {
            case WeiboSDKResponseStatusCodeSuccess:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
                {
                    [self.delegate publishFinishedWith:self.platform];
                }
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancel:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(publishCanceldedWith:)])
                {
                    [self.delegate publishCanceldedWith:self.platform];
                }
            }
                break;
            default:
                if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
                {
                    [self.delegate publishFailedWith:self.platform errorString:@"error"];
                }
                break;
        }
    }
}
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    if ([request.httpMethod isEqualToString:@"POST"])
    {
        // publish
        if ([result rangeOfString:@"error"].length != 0)
        {
            NSLog(@"sina微博 publish result %@", result);
            if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
            {
                [self.delegate publishFailedWith:self.platform errorString:result];
            }
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
        {
            [self.delegate publishFinishedWith:self.platform];
        }
    }
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
    {
        [self.delegate publishFailedWith:self.platform errorString:error.localizedDescription];
    }
}

#pragma mark 各个平台拉去个人信息回调

//新浪微博登录
- (void)loginWithSina
{
    NSDictionary *sinaDic = [[NSUserDefaults standardUserDefaults] objectForKey:SINAWEIBO_TOKEN_DIC];
    
    if (sinaDic)
    {  //已经有token
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[sinaDic objectForKey:@"openId"] forKey:@"uid"];
        
        [WBHttpRequest
         requestWithAccessToken:[sinaDic objectForKey:ACCESSTOKEN]
         url:[NSString stringWithFormat:@"%@", @"https://api.weibo.com/2/users/show.json"]
         httpMethod:@"GET"
         params:parameters
         delegate:self
         withTag:@"1"];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self application:application handleOpenURL:url];
}
@end
