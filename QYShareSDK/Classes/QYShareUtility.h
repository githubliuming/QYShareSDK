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

#import "WXApi.h"


typedef NS_ENUM(NSUInteger, QYShareType)
{
    QYShareTypeImage,
    QYShareTypeText,
    QYShareTypeVideo,
};

@class TencentOAuth;
@interface QYShareUtility : NSObject


@property(nonnull,strong) TencentOAuth * tencentOAuth;

+ (instancetype _Nullable )shareInstanced;

- (void)registPlatform:(NSDictionary<NSString * ,NSString* > *_Nonnull)platformDic;

- (void)share:(id <QYShareDelegate> _Nonnull) obj toPlatform:(NSString *_Nonnull) platform shareType:(QYShareType)type;

@end
