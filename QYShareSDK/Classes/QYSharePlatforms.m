//
//  QYSharePlatforms.m
//  QYShareSDK
//
//  Created by liuming on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYSharePlatforms.h"

NSString * SHARE_PLARTFORM_QQ;  ///<* QQ
NSString * SHARE_PLARTFORM_WX;  ///<* 微信好友
NSString * SHARE_PLARTFORM_WXLINE; ///<* 微信朋友圈
NSString * SHARE_PLARTFORM_INS;     ///<* ins
NSString * SHARE_PLARTFORM_FACEBOOK; ///<* facebook
NSString * SHARE_PLARTFORM_MESSAGER; ///<* messager
NSString * SHARE_PLARTFORM_SINAWB;   ///<* 新浪微博
NSString * SHARE_PLARTFORM_TWITTER;  ///<* 推特
NSString * SHARE_PLARTFORM_WHATAPP;  ///<* whatApp
NSString * SHARE_PLARTFORM_MORE;     ///<* 系统更多
NSString * SHAREMESSAGEWEBPAGEURL;

void initPlartformsNames()
{

    SHARE_PLARTFORM_QQ = @"qy_share_to_qq";
    SHARE_PLARTFORM_WX = @"qy_share_to_wxCONTACT";
    SHARE_PLARTFORM_WXLINE = @"qy_share_to_wxLine";
    SHARE_PLARTFORM_INS = @"qy_share_to_ins";
    SHARE_PLARTFORM_FACEBOOK = @"qy_share_to_faceBook";
    SHARE_PLARTFORM_MESSAGER = @"qy_share_to_messager";
    SHARE_PLARTFORM_SINAWB = @"qy_share_to_sinaWB";
    SHARE_PLARTFORM_TWITTER = @"qy_share_to_twitter";
    SHARE_PLARTFORM_WHATAPP = @"qy_share_to_whateApp";
    SHARE_PLARTFORM_MORE = @"qu_share_to_system_more";
    SHAREMESSAGEWEBPAGEURL =@"http://www.yoyoim.com";

}
