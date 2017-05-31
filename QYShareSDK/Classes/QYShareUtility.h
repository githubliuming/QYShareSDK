//
//  QYShareUtility.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYShareDelegate.h"
#import "QYSharePlatforms.h"

typedef NS_ENUM(NSUInteger, QYShareType)
{
    QYShareTypeImage,
    QYShareTypeText,
    QYShareTypeVideo,
};

@interface QYShareUtility : NSObject

- (instancetype)shareInstanced;

- (void)registPlatform:(NSDictionary<NSString * ,NSString* > *)platformDic;

- (void)share:(id<QYShareDelegate>) obj toPlatform:(NSString *) platform shareType:(QYShareType)type;

@end
