//
//  PlatformList.h
//  QYShareSDK
//
//  Created by liuming on 2018/4/26.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "NXBaseListViewController.h"
#import "QYShareSever.h"
#import "QYShareModel.h"
#define NXPlatformKey @"NXPlatformKey"
@interface PlatformList : NXBaseListViewController
@property(nonatomic,assign)QYSharePlatform platform;
@property(nonatomic,strong,readonly)QYShareSever * shareSever;
@end
