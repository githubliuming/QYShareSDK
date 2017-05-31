//
//  QYShareUtility.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility.h"


#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#import "WXApi.h"

@interface QYShareUtility ()

@property(nonnull,strong) TencentOAuth * tencentOAuth;
@end

@implementation QYShareUtility

- (instancetype)shareInstanced{

    static QYShareUtility * utility ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (utility == nil) {
            
            utility = [[QYShareUtility alloc] init];
        }
    });
    return utility;
}

- (void)share:(id<QYShareDelegate>) obj toPlatform:(NSString *) platform shareType:(QYShareType)type
{
    
    SHARE_PLARTFORM_QQ = @"qy_share_to_qq";
    SHARE_PLARTFORM_WX = @"qy_share_to_wxCONTACT";
    SHARE_PLARTFORM_WXLINE = @"qy_share_to_wxLine";
    SHARE_PLARTFORM_INS = @"qy_share_to_ins";
    SHARE_PLARTFORM_FACEBOOK = @"qy_share_to_faceBook";
    SHARE_PLARTFORM_MESSAGER = @"qy_share_to_messager";
    SHARE_PLARTFORM_SINAWB = @"qy_share_to_sinaWB";
    SHARE_PLARTFORM_TWITTER = @"qy_share_to_twitter";
    SHARE_PLARTFORM_WHATAPP = @"qy_share_to_whateApp";
    SHARE_PLARTFORM_MORE = @"qu_share_to_system_more";
}
- (void)registPlatform:(NSDictionary<NSString * ,NSString* > *)platformDic{

    [platformDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString * platform = [[key componentsSeparatedByString:@"_"] lastObject];
        if ([platform isEqualToString:@"wxCONTACT"] || [platform isEqualToString:@"wxLine"])
        {
            platform = @"wx";
        }
        NSString * selString = [NSString stringWithFormat:@"%@_Register:",platform];
        SEL sel = NSSelectorFromString(selString);
        if ([self respondsToSelector:sel]) {
            IMP imp = [self methodForSelector:sel];
            void (* func)(id,SEL,NSString * appId) = (void *)imp;
            func(self,sel,obj);
        }
    }];
}
- (void)wx_Register:(NSString *)appId{

    [WXApi registerApp:appId withDescription:@"demo 2.0"];
}
- (void)qq_Register:(NSString *)appId
{
     _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:nil];
}
- (void)sinaWB_Register:(NSString *) appId{

    /*
     新浪微博
     */
    [WeiboSDK enableDebugMode:YES];
    // kSinaAppKey
    [WeiboSDK registerApp:appId];
}
@end
