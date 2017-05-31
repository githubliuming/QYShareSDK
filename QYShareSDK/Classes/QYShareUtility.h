//
//  QYShareUtility.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareDelegate.h"
@interface QYShareUtility : NSObject

- (void)share:(id<QYShareDelegate>) obj toPlatform:(NSString *) platform shareType:(QYShareType)type;

@end
