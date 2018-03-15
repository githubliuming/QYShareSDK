//
//  QYShareRooter.h
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareComponentDelegate.h"
#import "QYShareConst.h"
@interface QYShareRooter : NSObject

+ (instancetype)shareInstanced;

@property(nonatomic,weak)id<QYShareDelegate>delegate;

@property(nonatomic,weak)id<QYShareComponentDelegate>currentComponent;

- (void)registerDefualtComponent;

-(void)addComponent:(id<QYShareComponentDelegate>)interface
        forPlatform:(QYSharePlatform)platform;

- (void)removeComonetWitPlatform:(QYSharePlatform)platform;

- (id<QYShareComponentDelegate>)getShareInterfaceWithPlatform:(QYSharePlatform) platform;

@end
