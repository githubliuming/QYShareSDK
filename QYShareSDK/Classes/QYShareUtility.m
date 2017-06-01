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

@interface QYShareUtility ()
@end

@implementation QYShareUtility

+ (instancetype)shareInstanced{
    
    static QYShareUtility * utility ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (utility == nil) {
            
            utility = [[QYShareUtility alloc] init];
        }
    });
    return utility;
}

- (instancetype) init{
    
    self = [super init];
    if (self) {
        initPlartformsNames();
    }
    
    return self;
}
- (void)share:(id<QYShareDelegate>) obj toPlatform:(NSString *) platform shareType:(QYShareType)type
{
    NSString * platform_ = [[platform componentsSeparatedByString:@"_"] lastObject];
    if ([platform_ isEqualToString:SHARE_PLARTFORM_WXLINE] || [platform isEqualToString:SHARE_PLARTFORM_WX])
    {
        platform_ = @"wx";
    }
    NSString * selString = [NSString stringWithFormat:@"%@_share:toPlatform:shareType:",platform_];
    SEL sel = NSSelectorFromString(selString);
    if ([self respondsToSelector:sel]) {
        
        IMP imp = [self methodForSelector:sel];
        void (* func)(id,SEL,id,NSString *,QYShareType) = (void *)imp;
        func(self,sel,obj,platform,type);
    }
}
- (void)registPlatform:(NSDictionary<NSString * ,NSString* > *)platformDic{
    
    [platformDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString * platform = [[key componentsSeparatedByString:@"_"] lastObject];
        if ([key isEqualToString:SHARE_PLARTFORM_WXLINE] || [key isEqualToString:SHARE_PLARTFORM_WX])
        {
            platform = @"wx";
        }
        NSString * selString = [NSString stringWithFormat:@"%@_Register:",platform];
        SEL sel = NSSelectorFromString(selString);
        if ([self respondsToSelector:sel]) {
            IMP imp = [self methodForSelector:sel];
            void (* func)(id,SEL,NSString *) = (void *)imp;
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
