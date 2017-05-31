//
//  QYShareTool.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYShareTool : NSObject

#pragma mark -- NSUserDefault
+ (id) getValueFromUserDefault:(NSString *)key;
+ (void)setValue:(id)value tokey:(NSString *)key;

#pragma mark - 提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg;

#pragma mark -
+ (BOOL) canOpenUrl:(NSString *)urlShemes;
@end
