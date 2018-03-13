//
//  QYShareConst.h
//  QYShareSDK
//
//  Created by liuming on 2018/3/13.
//  Copyright © 2018年 burning. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef QYShareConst_h
#define QYShareConst_h

typedef NS_ENUM (NSInteger,QYSharePlatform)
{
    QYSharePlatform_Unkown = 0,   //未知分享平台
    QYSharePlatform_Ins    = 1,   //INS
    QYSharePlatform_FaceBook = 2, //messeager
    QYSharePlatform_WX_Contact =3, //微信好友
    QYSharePlatform_More = 4,      //更多分享，调用系统组件
    QYSharePlatform_QQ_Friend = 5 , //分享到qq好友
    QYSharePlatform_Messenger = 6,  //分享到 Messenger
    QYSharePlatform_QQ_Zone = 7,    //分享到qq空间
    QYSharePlatform_SinaWB  = 8,   //新浪微博
    QYSharePlatform_WX_TimerLine = 9, //微信朋友圈
    QYSharePlatform_Twitter = 10,    //twitter
};

typedef NS_ENUM(NSInteger,QYShareType)
{
    QYShareTypeUnkown,        //未知分享类型
    QYShareTypeText,          //文本
    QYShareTypeImage,         //图片
    QYShareTypeUrl,           //链接
    QYShareTypeGif,           //gif
    QYShareTypeVideo,         //视频
};

@protocol QYShareConfig <NSObject>

- (NSString *)getShareTitile;
- (NSString *)getShareContent;
- (NSString *)getShareUrl;
- (NSString *)getShareImage;
- (NSData *)getShareImageData;

@end
#endif /* QYShareConst_h */
