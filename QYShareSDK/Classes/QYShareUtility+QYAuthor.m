//
//  QYShareUtility+QYAuthor.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility+QYAuthor.h"
#import "QYShareTool.h"

#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>


@implementation QYShareUtility (QYAuthor)

+ (BOOL)hasAuthor:(NSString *) platformName
{
    //目前只做 QQ、微信、微博、的授权处理
    if([platformName isEqualToString:SHARE_PLARTFORM_QQ]
       || [platformName isEqualToString:SHARE_PLARTFORM_WX]
       || [platformName isEqualToString:SHARE_PLARTFORM_WXLINE]
       ||[platformName isEqualToString:SHARE_PLARTFORM_SINAWB])
    {
        
        return ([QYShareTool getValueFromUserDefault:platformName] !=nil);
        
    }
    return YES;
    
}

- (void)author:(NSString *)platformName
{
    NSString * platform = [[platformName componentsSeparatedByString:@"_"] lastObject];
    if ([platformName isEqualToString:SHARE_PLARTFORM_WX] || [platformName isEqualToString:SHARE_PLARTFORM_WXLINE]) {
        
        platform = @"wx";
    }
    NSString * selStr = [NSString stringWithFormat:@"%@_auhtor",platform];
    SEL sel = NSSelectorFromString(selStr);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void(* func)(id,SEL) = (void *)imp;
        func(self,sel);
    }
}

- (void)qq_author{
    
    if (![TencentOAuth iphoneQQInstalled]){
        
        [QYShareTool alert:@"提示" msg:@"未安装QQ"];
        return ;
    }
    NSMutableArray *  permissions = [NSMutableArray
                                     arrayWithObjects:kOPEN_PERMISSION_ADD_TOPIC, kOPEN_PERMISSION_ADD_ONE_BLOG, kOPEN_PERMISSION_ADD_ALBUM,
                                     kOPEN_PERMISSION_UPLOAD_PIC, kOPEN_PERMISSION_LIST_ALBUM, kOPEN_PERMISSION_ADD_SHARE,
                                     kOPEN_PERMISSION_CHECK_PAGE_FANS, kOPEN_PERMISSION_GET_INFO,
                                     kOPEN_PERMISSION_GET_OTHER_INFO, kOPEN_PERMISSION_GET_VIP_INFO,
                                     kOPEN_PERMISSION_GET_VIP_RICH_INFO, kOPEN_PERMISSION_GET_USER_INFO,
                                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    
    [self.tencentOAuth authorize:permissions inSafari:NO];
}

- (void)sinaWB_author
{
    //授权
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SHAREMESSAGEWEBPAGEURL;
    request.scope = @"all";
    request.userInfo = @{
                         @"SSO_From" : @"PLEditMovieVC",
                         @"Other_Info_1" : [NSNumber numberWithInt:123],
                         @"Other_Info_2" : @[ @"obj1", @"obj2" ],
                         @"Other_Info_3" : @{@"key1" : @"obj1", @"key2" : @"obj2"}
                         };
    [WeiboSDK sendRequest:request];
    
}
- (void)wx_author
{
    if (![WXApi isWXAppInstalled])
    {
        [QYShareTool alert:@"提示" msg:@"未安装微信"];
        NSLog(@"你没有安装微信");
        return;
    }
    
    //授权 这里是授权登录的 请求
    SendAuthReq *authReq = [[SendAuthReq alloc] init];
    authReq.scope = @"snsapi_userinfo";
    [WXApi sendReq:authReq];
}
@end
