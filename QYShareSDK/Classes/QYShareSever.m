//
//  QYShareSever.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "QYShareSever.h"
#import "QYShareRooter.h"
@interface QYShareSever()
@property(nonatomic,weak)id<QYShareDelegate>delegate;
@end
@implementation QYShareSever 

- (instancetype)initWithDelegate:(id<QYShareDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        [QYShareRooter shareInstanced].delegate = self.delegate;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDelegate:nil];
}
- (void)startShare:(id<QYShareConfig>)shareConfig
      platformType:(QYSharePlatform)platform
         shareType:(QYShareType)type
{
    //从rooter层获取分享组件对象 然后分享
    id<QYShareComponentBaseDelegate> interface = [[QYShareRooter shareInstanced] getShareInterfaceWithPlatform:platform];
    if (interface)
    {
        interface.platform = platform;
        interface.shareType = type;
        [self qy_shareWithInterface:interface andShareConfig:shareConfig shareType:type];
    }
    else
    {
        NSLog(@"该平台未注册 分享组件");
    }
}

- (void)qy_shareWithInterface:(id<QYShareComponentBaseDelegate>)interface
               andShareConfig:(id<QYShareConfig>)shareConfig
                    shareType:(QYShareType)type
{
    NSLog(@"share type = %ld",type);
    switch (type) {
        case QYShareTypeGif:
            [interface shareGif:shareConfig];
            break;
        case QYShareTypeUrl:
            [interface shareUrl:shareConfig];
            break;
        case QYShareTypeText:
            [interface shareText:shareConfig];
            break;
        case QYShareTypeImage:
            [interface shareImage:shareConfig];
            break;
        case QYShareTypeVideo:
             [interface shareVideo:shareConfig];
            break;
        default:
            NSLog(@"未知分享类型 %ld",type);
            break;
    }
}
+(void)regesitDefaultComponent
{
    [[QYShareRooter shareInstanced] registerDefualtComponent];
}
+(void)addComponent:(id<QYShareComponentBaseDelegate>)interface
        forPlatform:(QYSharePlatform)platform
{
    [[QYShareRooter shareInstanced] addComponent:interface forPlatform:platform];;
}
+ (void)removeComponetWithPlatfrom:(QYSharePlatform)platform
{
    [[QYShareRooter shareInstanced]removeComonetWitPlatform:platform];
}
- (void)dealloc
{
    self.delegate = nil;
    [QYShareRooter shareInstanced].delegate = nil;
}
@end
