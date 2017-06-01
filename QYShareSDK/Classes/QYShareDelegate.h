//
//  QYShareDelegate.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QYShareDelegate <NSObject>


/**
 分享的链接地址

 @return 链接地址
 */
- (NSString *) getShareUrl;

/**
 分享的文本标题

 @return 文本标题
 */
- (NSString *)getShareTitle;

/**
 正文内容

 @return 正文
 */
- (NSString *)getShareContent;


/**
 分享的图片对象 UIImage 或者 NSData对象

 @return 分享的图片对象
 */
- (id)getShareImageContext;
@end
