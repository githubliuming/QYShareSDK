//
//  PlatformList.m
//  QYShareSDK
//
//  Created by liuming on 2018/4/26.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "PlatformList.h"
@interface PlatformList ()<QYShareDelegate>

@end

@implementation PlatformList

- (void) initDataSource
{
    
    NSArray * array = @[
                        @{
                            NXListTiltleKey:@"QQ好友",
                            NXPlatformKey:@(QYSharePlatform_QQ_Friend),
                            },
                        @{
                            NXListTiltleKey:@"QQ空间",
                            NXPlatformKey:@(QYSharePlatform_QQ_Zone),
                            },
                        @{
                            NXListTiltleKey:@"微信好友",
                            NXPlatformKey:@(QYSharePlatform_WX_Contact),
                            },
                        @{
                            NXListTiltleKey:@"微信朋友圈",
                            NXPlatformKey:@(QYSharePlatform_WX_TimerLine),
                            },
                        @{
                            NXListTiltleKey:@"微博分享",
                            NXPlatformKey:@(QYSharePlatform_SinaWB),
                            },
                        @{
                            NXListTiltleKey:@"ins",
                            NXPlatformKey:@(QYSharePlatform_Ins),
                            },
                        @{
                            NXListTiltleKey:@"faceBook",
                            NXPlatformKey:@(QYSharePlatform_FaceBook),
                            },

                        @{
                            NXListTiltleKey:@"Messenger",
                            NXPlatformKey:@(QYSharePlatform_Messenger),
                            },
                        @{
                            NXListTiltleKey:@"twitter",
                            NXPlatformKey:@(QYSharePlatform_Twitter),
                            },
                        ];
    [self.dataSource addObjectsFromArray:array];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _shareSever = [[QYShareSever alloc] initWithDelegate:self];
    // Do any additional setup after loading the view.
}

#pragma mark - QYShareDelegate
// 授权完成
- (void)authorizedFinished:(NSDictionary *)authDic With:(QYSharePlatform)platform
{
    
}
// 授权取消
- (void)authorizedCancelded:(NSDictionary *)authDic With:(QYSharePlatform)platform
{
 
    NSLog(@"授权完成  platform = %ld",platform);
}
// 授权失败
- (void)authorizedFailed:(NSError *)error With:(QYSharePlatform)platform
{
    NSLog(@"授权失败  platform = %ld",platform);
}

// 发布成功
- (void)publishFinishedWith:(QYSharePlatform)platform
{
    NSLog(@"发布成功  platform = %ld",platform);
}
// 发布取消
- (void)publishCanceldedWith:(QYSharePlatform)platform
{
    NSLog(@"取消发布  platform = %ld",platform);
}
// 发布失败
- (void)publishFailedWith:(QYSharePlatform)platform errorString:(NSString *)errorMsg
{
    NSLog(@"发布失败  platform = %ld",platform);
}

//取得个人信息成功
- (void)getUserInfoSucceedWithInfoDic:(NSDictionary *)infoDic
                                 with:(QYSharePlatform)platform
{
    NSLog(@"获取个人信息成功  info = %@  platform = %ld",infoDic,platform);
}
//取个人信息失败
- (void)getUserInfoFaileWithErrorMsg:(NSString *)errorMsg
                                with:(QYSharePlatform)platform
{
    NSLog(@"获取个人信息失败  errorMsg = %@  platform = %ld",errorMsg,platform);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
