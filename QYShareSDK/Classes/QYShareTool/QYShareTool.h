//
//  QYShareTool.h
//  QYShareSDK
//
//  Created by liuming on 2018/3/14.
//  Copyright © 2018年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage,UIViewController;
@interface QYShareTool : NSObject

/**
 
压缩图片 将图片压缩到 32KB以下
 @param myimage 将要压缩的图片
 @return imageData
 */
+ (NSData *)scaleThumbImageData:(UIImage *)myimage;

/**
 判断是否能够打开一个 urlShemes
 
 @param urlShemes 需要打开的 urlShemes
 
 @return YES- 能打开 NO 不能打开
 */
+ (BOOL)canOpenUrlShemes:(NSString *)urlShemes;
/**
 打开目标 urlShemes
 
 @param urlShemes 目标 urlShemes
 
 @return 打开结果
 */
+ (BOOL)openUrlShemes:(NSString *)urlShemes;

/**
 获取当前视图控制器

 @return 正在显示的视图控制器
 */
+ (UIViewController *)nx_currentViewController;

+ (void)requestSocialAccountAuthor:(NSString *)accountTypeIndentifier complent:(void(^)(BOOL granted, NSError *error)) block;
@end
