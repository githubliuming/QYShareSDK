//
//  QYShareSever.h
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareConst.h"
#import "QYShareComponentDelegate.h"
@interface QYShareSever : NSObject

- (void)startShare:(id<QYShareConfig>)shareConfig
      platformType:(QYSharePlatform)platform
         shareType:(QYShareType)type;

+(void)regesitDefaultComponent;

+(void)addComponent:(id<QYShareComponentBaseDelegate>)interface forPlatform:(QYSharePlatform)platform;
@end
