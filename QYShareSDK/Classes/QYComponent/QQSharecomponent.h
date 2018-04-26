//
//  QYQQShare- (id<QYShareComponentBaseDelegate>)getShareInterfaceWithPlatform:(QYSharePlatform) platform; QQShareComponent.h
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareComponentDelegate.h"

@interface QQShareComponent : NSObject<QYShareComponentDelegate,QYShareDelegate,QYPropertyDelegate,QYShareAuthorDelegate,QYShareFinishDelegate>
@end
