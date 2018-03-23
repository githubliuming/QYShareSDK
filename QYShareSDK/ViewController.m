//
//  ViewController.m
//  QYShareSDK
//
//  Created by liuming on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "ViewController.h"
#import "QYShareSever.h"
#import "QYShareSever.h"
@interface ViewController ()<QYShareDelegate>
@property(nonatomic,strong)QYShareSever * shareSever;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.shareSever = [[QYShareSever alloc] initWithDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QYShareDelegate
// 授权完成
- (void)authorizedFinished:(NSDictionary *)authDic With:(QYSharePlatform)platform
{
    
}
// 授权取消
- (void)authorizedCancelded:(NSDictionary *)authDic With:(QYSharePlatform)platform
{
    
}
// 授权失败
- (void)authorizedFailed:(NSError *)error With:(QYSharePlatform)platform
{
    
}

// 发布成功
- (void)publishFinishedWith:(QYSharePlatform)platform
{
    
}
// 发布取消
- (void)publishCanceldedWith:(QYSharePlatform)platform
{
    
}
// 发布失败
- (void)publishFailedWith:(QYSharePlatform)platform errorString:(NSString *)errorMsg
{
    
}

//取得个人信息成功
- (void)getUserInfoSucceedWithInfoDic:(NSDictionary *)infoDic
                                 with:(QYSharePlatform)platform
{
    
}
//取个人信息失败
- (void)getUserInfoFaileWithErrorMsg:(NSString *)errorMsg
                                with:(QYSharePlatform)platform
{
    
}

@end
