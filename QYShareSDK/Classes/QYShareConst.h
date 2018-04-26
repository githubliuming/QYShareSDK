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
    QYSharePlatform_FaceBook = 2, //facebook
    QYSharePlatform_WX_Contact =3, //微信好友
    QYSharePlatform_QQ_Friend = 4 , //分享到qq好友
    QYSharePlatform_Messenger = 5,  //分享到 Messenger
    QYSharePlatform_QQ_Zone = 6,    //分享到qq空间
    QYSharePlatform_SinaWB  = 7,   //新浪微博
    QYSharePlatform_WX_TimerLine = 8, //微信朋友圈
    QYSharePlatform_Twitter = 9,    //twitter
    QYSharePlatform_More = 10,      //更多分享，调用系统组件
    QYSharePlatform_SystemShare = 11, //系统的组件
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
@property(nonatomic,strong)NSString * title;  ///<* 分享 title
@property(nonatomic,strong)NSString * content;///<* 分享内容
@property(nonatomic,strong)NSString * url;    ///<* 分享路径(包括 网页路径、视频本地路径、视频相册路径)
@property(nonatomic,strong)NSArray<UIImage *> *images; ///<* 分享图片
@property(nonatomic,strong)NSString * gifPath;         ///<* 分享gif的本地路径
@end

@protocol QYShareFinishDelegate<NSObject>

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
