//
//  WXShareComponent.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "WXShareComponent.h"
#import "QYShareTool.h"
#import "WXApi.h"

#define ACCESSTOKEN @"ACCESSTOKEN"
#define WEIXIN_TOKEN_DIC @"WEIXIN_TOKEN_DIC"
#define WEIXIN_USER_INFO_DIC @"WEIXIN_USER_INFO_DIC"
@interface WXShareComponent()<WXApiDelegate>
@property(nonatomic,strong) NSString * appId;
@property(nonatomic,strong) NSString *secretKey;
@end
@implementation WXShareComponent
@synthesize shareType,delegate,platform;

- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
                       application:(UIApplication *)application
                     launchOptions:(NSDictionary*)launchOptions
{
    self.appId = appId;
    self.secretKey = secretKey;
    if (![WXApi registerApp:self.appId])
    {    
        NSLog(@"微信sdk 注册失败");
    }
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    WXImageObject * ext = [self buildImageObject:interface];
    WXMediaMessage * message = [self buildWXMessage:ext with:interface];
    [self sendWXMessage:message];
}
- (void)shareVideo:(id<QYShareConfig>)interface
{
    WXVideoObject * ext = [self buildVideoObject:interface];
    WXMediaMessage * message = [self buildWXMessage:ext with:interface];
    [self sendWXMessage:message];
}
- (void)shareUrl:(id<QYShareConfig>)interface
{
    WXWebpageObject * ext = [self buildWebPageObject:interface];
    WXMediaMessage * message = [self buildWXMessage:ext with:interface];
    [self sendWXMessage:message];
}
- (void)shareGif:(id<QYShareConfig>)interface
{

    self.platform = QYSharePlatform_WX_Contact;
    WXEmoticonObject *ext = [self buildEmojeObject:interface];
    WXMediaMessage *message = [self buildWXMessage:ext with:interface];
    [self sendWXMessage:message];
}
- (void)shareText:(id<QYShareConfig>)interface
{
    WXTextObject * ext = [self buildTextObject:interface];
    WXMediaMessage * message =[self buildWXMessage:ext with:interface];
    [self sendWXMessage:message];
}

- (void)sendWXMessage:(WXMediaMessage *)message
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =[self isShareWXTimeLine]? WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];
}

- (WXMediaMessage *)buildWXMessage:(id)ext with:(id<QYShareConfig>)config
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = config.title;
    message.description = config.content;
    UIImage * image = [config.images firstObject];;
    NSData * data = [QYShareTool scaleThumbImageData:image];
    if (data.length > 0)
    {
        [message setThumbData:data];
    }
    message.mediaObject = ext;
    return message;
}

- (WXTextObject *)buildTextObject:(id<QYShareConfig>)config
{
    WXTextObject * ext;
    if (config) {
        
        ext = [[WXTextObject alloc] init];
        ext.contentText = config.content;
    }
    return ext;
}
- (WXVideoObject *)buildVideoObject:(id<QYShareConfig>)config
{
    WXVideoObject * ext;
    if (config)
    {
        ext = [WXVideoObject object];
        ext.videoUrl = config.url;
    }
    return ext;
}
- (WXImageObject *)buildImageObject:(id<QYShareConfig>)config
{
    WXImageObject * ext;
    if (config)
    {
        ext = [WXImageObject object];
        ext.imageData = UIImagePNGRepresentation([config.images firstObject]);
    }
    return ext;
}
- (WXWebpageObject *)buildWebPageObject:(id<QYShareConfig>)config
{
    WXWebpageObject * ext;
    if (config)
    {
        ext = [WXWebpageObject object];
        ext.webpageUrl = config.url;
    }
    return ext;
}
- (WXEmoticonObject *)buildEmojeObject:(id<QYShareConfig>)config
{
    WXEmoticonObject * ext ;
    if (config)
    {
        ext = [WXEmoticonObject object];
        ext.emoticonData = [NSData dataWithContentsOfFile:config.gifPath];
    }
    return ext;
}
#pragma mark - 授权模块
- (void)authoried
{
    
}
- (BOOL)hasAuthorized
{
    return YES;
}
#pragma mark- 检测是否安装
- (BOOL)isInstallAPPClient
{
    return [WXApi isWXAppInstalled];
}

- (BOOL)isShareWXTimeLine
{
    return self.platform == QYSharePlatform_WX_TimerLine;
}
#pragma mark req&resp
- (void)onReq:(BaseReq *)req
{
    if ([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        
//        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
//
//        PLAlertView *alertV = [[PLAlertView alloc] init];
//        [alertV showWithTitle:strMsg
//                    backImage:[UIImage nx_screenHierarchyShots:[UIApplication sharedApplication].keyWindow]
//                    btnsArray:[NSMutableArray arrayWithObjects:@"确定", nil]];
        
//        alertV.tag = 1000;
    }
    else if ([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
//        ShowMessageFromWXReq *temp = (ShowMessageFromWXReq *)req;
//        WXMediaMessage *msg = temp.message;
//
//        //显示微信传过来的内容
//        WXAppExtendObject *obj = msg.mediaObject;
//
//        NSString *strMsg =
//        [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n",
//         msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
//        PLAlertView *alertV = [[PLAlertView alloc] init];
//        [alertV showWithTitle:strMsg
//                    backImage:[UIImage nx_screenHierarchyShots:[UIApplication sharedApplication].keyWindow]
//                    btnsArray:[NSMutableArray arrayWithObjects:@"确定", nil]];
    }
    else if ([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        
//        NSString *strMsg = @"这是从微信启动的消息";
//        PLAlertView *alertV = [[PLAlertView alloc] init];
//        [alertV showWithTitle:strMsg
//                    backImage:[UIImage nx_screenHierarchyShots:[UIApplication sharedApplication].keyWindow]
//                    btnsArray:[NSMutableArray arrayWithObjects:@"确定", nil]];
    }
}

//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSLog(@"weichat 返回结果%d", resp.errCode);
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
                {
                    [self.delegate publishFinishedWith:self.platform];
                }
            }
                break;
            case WXErrCodeUserCancel:
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
                    [self.delegate publishFailedWith:self.platform errorString:resp.errStr];
                }
                break;
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]])
    {  //请求授权
        if (resp.errCode == 0)
        {  //同意
            SendAuthResp *requ = (SendAuthResp *)resp;
            //通过code  去获取token
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            // kWeixinAppID, kWeixinSecret
            NSString *urlString =
            [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/"
             @"access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
             self.appId, self.secretKey, requ.code];
            request.URL = [NSURL URLWithString:urlString];
            NSError *error = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (!data)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
                {
                    [self.delegate authorizedFailed:error With:self.platform];
                }
                return;
            }
            NSMutableDictionary *dataDic = [NSMutableDictionary
                                            dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableLeaves
                                                                                                       error:nil]];
            if (error)
            {  //获取token失败 算作认证失败
                if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
                {
                    [self.delegate authorizedFailed:error With:self.platform];
                }
            }
            else if (dataDic)
            {  //获取token 成功 保存dic到本地
                // ACCESSTOKEN
                [dataDic setValue:[dataDic objectForKey:@"access_token"] forKey:ACCESSTOKEN];
                [dataDic setValue:[dataDic objectForKey:@"openid"] forKey:@"openid"];
                // WEIXIN_TOKEN_DIC
                [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:WEIXIN_TOKEN_DIC];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFinished:With:)])
                {
                    [self.delegate authorizedFinished:dataDic With:self.platform];
                }
                [self getWXLoginUserInfo];
            }
        }
        else if (resp.errCode == -4)
        {  //拒绝
            
            NSError *aError = [[NSError alloc]
                               initWithDomain:@""
                               code:resp.errCode
                               userInfo:[NSDictionary
                                         dictionaryWithObjectsAndKeys:@"授权拒绝", NSLocalizedDescriptionKey, nil]];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
            {
                [self.delegate authorizedFailed:aError With:self.platform];
            }
        }
        else if (resp.errCode == -2)
        {  //取消
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(authorizedFailed:With:)])
            {
                [self.delegate
                 authorizedCancelded:[NSDictionary dictionaryWithObjectsAndKeys:@"授权取消",
                                      NSLocalizedDescriptionKey, nil]
                 With:self.platform];
            }
        }
    }
}
- (void) getWXLoginUserInfo
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary * dataDic = [userDefault objectForKey:WEIXIN_TOKEN_DIC];
    //异步拉取用户信息
    NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",
                         [dataDic objectForKey:ACCESSTOKEN], [dataDic objectForKey:@"openid"]];
    NSURLRequest * requst = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getUserInfoFaileWithErrorMsg:with:)])
            {
                [self.delegate getUserInfoFaileWithErrorMsg:[error localizedDescription]
                                           with:self.platform];
            }
            
        } else {
            
            NSDictionary *userInfoDic =
            [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (userInfoDic){
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(getUserInfoSucceedWithInfoDic:with:)])
                {
                    //
                    [[NSUserDefaults standardUserDefaults] setObject:userInfoDic forKey:WEIXIN_USER_INFO_DIC];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.delegate getUserInfoSucceedWithInfoDic:userInfoDic with:self
                     .platform];
                }
            }
            
        }
        
    }];
    [task resume];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
   return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   return  [self application:application handleOpenURL:url];
}
@end
