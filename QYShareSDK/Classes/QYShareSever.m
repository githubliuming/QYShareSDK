//
//  QYShareSever.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "QYShareSever.h"
#import "QYShareRooter.h"
@implementation QYShareSever 

- (void)startShare:(id<QYShareConfig>)shareConfig
      platformType:(QYSharePlatform)platform
         shareType:(QYShareType)type
{
    //从rooter层获取分享组件对象 然后分享
    id<QYShareComponentBaseDelegate> interface = [[QYShareRooter shareInstanced] getShareInterfaceWithPlatform:platform];
    if (interface)
    {
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
    if (type == QYShareTypeGif)
    {
        [interface shareGif:shareConfig];
    }
    else if (type == QYShareTypeUrl)
    {
        [interface shareUrl:shareConfig];
    }
    else if (type ==QYShareTypeText)
    {
        [interface shareText:shareConfig];
    }
    else if (type == QYShareTypeImage)
    {
        [interface shareImage:shareConfig];
    }
    else if (type == QYShareTypeVideo)
    {
        [interface shareVideo:shareConfig];
    }
    else
    {
        NSLog(@"未知分享类型");
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
@end
