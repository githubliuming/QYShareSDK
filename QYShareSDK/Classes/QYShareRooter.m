//
//  QYShareRooter.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "QYShareRooter.h"

#import "QQShareComponent.h"
#import "WXShareComponent.h"
#import "SinaWBShareComponent.h"

static QYShareRooter * static_rooter = nil;
@interface QYShareRooter()
@property(nonatomic,strong)NSMutableDictionary * rooterMap;
@end
@implementation QYShareRooter
+ (instancetype)shareInstanced
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (static_rooter == nil)
        {
            static_rooter = [[QYShareRooter alloc] init];
        }
    });
    return static_rooter;
}
- (void)registerDefualtComponent
{
    id<QYShareToQQDelegate> qq = [[QQShareComponent alloc] init];
    [self addComponent:qq forPlatform:QYSharePlatform_QQ_Zone];
    [self addComponent:qq forPlatform:QYSharePlatform_QQ_Friend];
    
    id<QYShareToWXDelegate> wx = [[WXShareComponent alloc] init];
    [self addComponent:wx forPlatform:QYSharePlatform_WX_Contact];
    [self addComponent:wx forPlatform:QYSharePlatform_WX_TimerLine];
    
    id<QYShareToSinaDelegate> sina = [[SinaWBShareComponent alloc] init];
    [self addComponent:sina forPlatform:QYSharePlatform_SinaWB];
    
}

-(void)addComponent:(id<QYShareComponentBaseDelegate>)interface
        forPlatform:(QYSharePlatform)platform
{
    NSAssert(interface!=nil, @" 分享组件对象为空");
    [self.rooterMap setObject:interface forKey:@(platform)];
}

- (void)removeComonetWitPlatform:(QYSharePlatform)platform
{
    [self.rooterMap removeObjectForKey:@(platform)];
}
- (id<QYShareComponentBaseDelegate>)getShareInterfaceWithPlatform:(QYSharePlatform) platform
{
    return self.rooterMap[@(platform)];
}
- (NSMutableDictionary *)rooterMap
{
    if (_rooterMap == nil)
    {
        _rooterMap = [[NSMutableDictionary alloc] init];
    }
    return _rooterMap;
}
@end
