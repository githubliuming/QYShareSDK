//
//  QYShareUtility+QYAuthor.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility+QYAuthor.h"
#import "QYShareTool.h"
@implementation QYShareUtility (QYAuthor)

+ (BOOL)hasAuthor:(NSString *) platformName
{
    //目前只做 QQ、微信、微博、的授权处理
    if([platformName isEqualToString:SHARE_PLARTFORM_QQ]
       || [platformName isEqualToString:SHARE_PLARTFORM_WX]
       || [platformName isEqualToString:SHARE_PLARTFORM_WXLINE]
       ||[platformName isEqualToString:SHARE_PLARTFORM_SINAWB])
    {

        return ([QYShareTool getValueFromUserDefault:platformName] !=nil);
    
    }
    return YES;
    
}

- (void)author:(NSString *)platformName
{

    
}
@end
