//
//  QYShareUtility+QYShareToFaceBook.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility.h"

/**
 分享到facebook平台
 */
@interface QYShareUtility (QYShareToFaceBook)

- (void)faceBook_share:(id <QYShareDelegate> _Nonnull) obj toPlatform:(NSString *_Nonnull) platform shareType:(QYShareType)type;

- (void)messager_share:(id <QYShareDelegate> _Nonnull) obj toPlatform:(NSString *_Nonnull) platform shareType:(QYShareType)type;
@end
