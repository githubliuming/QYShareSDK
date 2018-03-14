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
- (NSString *)getImageUrl;
- (UIImage *)getShareImage;
- (NSData *)getShareImageData;
- (NSString *)getGifPath;

@end

@protocol QYShareDelegate<NSObject>

@optional

// 授权完成
- (void)authorizedFinished:(NSDictionary *)authDic With:(QYSharePlatform)platform;
// 授权取消
- (void)authorizedCancelded:(NSDictionary *)authDic With:(QYSharePlatform)platform;
// 授权失败
- (void)authorizedFailed:(NSError *)error With:(QYSharePlatform)platform;

// 发布成功
- (void)publishFinishedWith:(QYSharePlatform)platform;
// 发布取消
- (void)publishCanceldedWith:(QYSharePlatform)platform;
// 发布失败
- (void)publishFailedWith:(QYSharePlatform)platform errorString:(NSString *)errorMsg;

//取得个人信息成功
- (void)getUserInfoSucceedWithInfoDic:(NSDictionary *)infoDic
                      with:(QYSharePlatform)platform;
//取个人信息失败
- (void)getUserInfoFaileWithErrorMsg:(NSString *)errorMsg
                    with:(QYSharePlatform)platform;

@end
#endif /* QYShareConst_h */
