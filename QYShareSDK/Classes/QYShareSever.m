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
@property(nonatomic,weak)id<QYShareFinishDelegate>delegate;
@end
@implementation QYShareSever 

- (instancetype)initWithDelegate:(id<QYShareFinishDelegate>)delegate
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
    id<QYPropertyDelegate> interface = [[QYShareRooter shareInstanced] getShareInterfaceWithPlatform:platform];
    if (interface)
    {
        interface.shareType = type;
        [self qy_shareWithInterface:interface andShareConfig:shareConfig shareType:type];
    }
    else
    {
        NSLog(@"该平台未注册 分享组件");
    }
}
-(void)startShare:(NSString *)title
          content:(NSString *)content
           images:(NSArray *)images
              url:(NSString *)url
          gifPath:(NSString *)gifPath
     platformType:(QYSharePlatform)platform
        shareType:(QYShareType)type
{
    id<QYShareConfig> configModel = [[QYShareConfigModel alloc] init];
    configModel.title  = title;
    configModel.content = content;
    configModel.images = images;
    configModel.url = url;
    configModel.gifPath  = gifPath;
    [self startShare:configModel platformType:platform shareType:type];
}

- (void)qy_shareWithInterface:(id<QYShareDelegate>)interface
               andShareConfig:(id<QYShareConfig>)shareConfig
                    shareType:(QYShareType)type
{
    NSLog(@"share type = %ld",(long)type);
    [QYShareRooter shareInstanced].currentComponent = interface;
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
            NSLog(@"未知分享类型 %ld",(long)type);
            break;
    }
}
-(BOOL)hasAuthor:(QYSharePlatform)platform
{
    id<QYShareAuthorDelegate> interface = [[QYShareRooter shareInstanced] getShareInterfaceWithPlatform:platform];
    return [interface hasAuthorized];
}
-(void)authoried:(QYSharePlatform)platform
{
    id<QYShareAuthorDelegate> interface = [[QYShareRooter shareInstanced] getShareInterfaceWithPlatform:platform];
    [QYShareRooter shareInstanced].currentComponent = interface;
    [interface authoried];
}
+(void)regesitDefaultComponent
{
    [[QYShareRooter shareInstanced] registerDefualtComponent];
}
+(void)addComponent:(id<QYShareComponentDelegate>)interface
        forPlatform:(QYSharePlatform)platform
{
    [[QYShareRooter shareInstanced] addComponent:interface forPlatform:platform];;
}
+ (void)removeComponetWithPlatfrom:(QYSharePlatform)platform
{
    [[QYShareRooter shareInstanced]removeComonetWitPlatform:platform];
}

+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
   return  [[QYShareRooter shareInstanced].currentComponent application:application handleOpenURL:url];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[QYShareRooter shareInstanced].currentComponent application:application
                                                                openURL:url
                                                      sourceApplication:sourceApplication
                                                             annotation:annotation];
}

+(void)registerThirdComponent:(void(^)(id<QYPropertyDelegate> component,QYSharePlatform platform))block
{
    if (block)
    {
        NSSet <id<QYPropertyDelegate>> * components = [[QYShareRooter shareInstanced] getAllRegisterComponet];
        [components enumerateObjectsUsingBlock:^(id<QYPropertyDelegate>  _Nonnull obj, BOOL * _Nonnull stop)
        {
            block(obj,obj.platform);
        }];
    }
}

- (void)dealloc
{
    self.delegate = nil;
    [QYShareRooter shareInstanced].delegate = nil;
}
@end
