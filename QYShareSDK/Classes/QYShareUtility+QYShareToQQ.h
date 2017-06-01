//
//  QYShareUtility+QYShareToQQ.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility.h"

/**
 QQ平台的接口
 */
@interface QYShareUtility (QYShareToQQ)


- (void)qq_share:(id <QYShareDelegate> _Nonnull) obj toPlatform:(NSString *_Nonnull) platform shareType:(QYShareType)type;

@end
