//
//  QYShareTool.h
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QYShareDelegate.h"


@class QYShareModel;
@interface QYShareTool : NSObject

#pragma mark -- NSUserDefault
+ (id) getValueFromUserDefault:(NSString *)key;
+ (void)setValue:(id)value tokey:(NSString *)key;

#pragma mark - 提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg;

#pragma mark -
+ (BOOL) canOpenUrl:(NSString *)urlShemes;
+ (void) openUrl:(NSURL *) url;

#pragma mark - save to library
+ (void)saveToAlbum:(NSString *)videoPath complandler:(void (^)(NSURL *url, NSError *error))block;

+(void)saveImageToAlbum:(UIImage *) image complandler:(void (^)(NSURL *url, NSError *error))block;

//图片不能大于32k
+ (NSData *)scaleThumbImageData:(UIImage *)myimage;

+ (NSData *)uu_imageData:(UIImage *)myimage;

#pragma marrk - model转换
- (QYShareModel *)convertToShareModel:(id<QYShareDelegate>) obj;
@end


@interface QYShareModel : NSObject

@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) id imageContext;
@property(nonatomic,strong) NSString * url;
@end
