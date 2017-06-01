//
//  QYShareUtility+QYShareToSina.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility+QYShareToSina.h"
#import "QYShareUtility+QYAuthor.h"
#import "WeiboSDK.h"
#import "QYShareTool.h"

#define ACCESSTOKEN @"ACCESSTOKEN"

@implementation QYShareUtility (QYShareToSina)

- (void)shareToSina:(NSString *)title content:(NSString *)content imageData:(NSData *)imageData url:(NSString *)url type:(QYShareType) type{

    if ([self hasAuthor:SHARE_PLARTFORM_SINAWB]) {
        
        NSDictionary * sinaDic = [QYShareTool getValueFromUserDefault:SHARE_PLARTFORM_SINAWB];
        NSString * token = sinaDic[ACCESSTOKEN];
        //判断需不需要拼url
        NSString *shareTextStr;
        NSRange range = [title rangeOfString:@"http://"];
        if (range.location == NSNotFound)
        {
            shareTextStr = [NSString stringWithFormat:@"%@ %@", title, url];
        }
        else
        {
            shareTextStr = title;
        }
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = @"wwww.sina.com";
        authRequest.scope = @"all";
        
        WBMessageObject *message = [WBMessageObject message];
        message.text = shareTextStr;
        
        if (imageData && type != QYShareTypeVideo)
        {
            WBImageObject *imageObj = [WBImageObject object];
            imageObj.imageData = [QYShareTool uu_imageData:[UIImage imageWithData:imageData]];
            message.imageObject = imageObj;
        }
        WBSendMessageToWeiboRequest *request =
        [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:token];
        request.userInfo = @{
                             @"ShareMessageFrom" : @"SendMessageToWeiboViewController",
                             @"Other_Info_1" : [NSNumber numberWithInt:123],
                             @"Other_Info_2" : @[ @"obj1", @"obj2" ],
                             @"Other_Info_3" : @{@"key1" : @"obj1", @"key2" : @"obj2"}
                             };
        [WeiboSDK sendRequest:request];

    }
}
@end
