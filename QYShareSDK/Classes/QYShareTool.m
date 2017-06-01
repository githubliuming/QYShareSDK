//
//  QYShareTool.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareTool.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation QYShareTool

#pragma mark -- NSUserDefault
+ (id) getValueFromUserDefault:(NSString *)key
{
    return  [[self userDefaults] valueForKey:key];
}
+ (void)setValue:(id)value tokey:(NSString *)key
{
    [[self userDefaults] setObject:value forKey:key];
    [[self userDefaults] synchronize];
}

+ (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark -提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg{
    
    UIAlertController * alertCrt = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertCrt addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCrt animated:YES completion:nil];
}
+ (BOOL) canOpenUrl:(NSString *)urlShemes{

    NSURL *url = [NSURL URLWithString:urlShemes];
    return [[UIApplication sharedApplication] canOpenURL:url];
}
+ (void) openUrl:(NSURL *) url{

    double systemVersion = [UIDevice currentDevice].systemVersion.doubleValue;
    if (systemVersion >= 10.0f) {
    
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
    
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)saveToAlbum:(NSString *)videoPath complandler:(void (^)(NSURL *url, NSError *error))block
{
    ALAssetsLibrary *libraray = [[ALAssetsLibrary alloc] init];
    [libraray writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath] completionBlock:block];
}

+(void)saveImageToAlbum:(UIImage * ) image complandler:(void (^)(NSURL *url, NSError *error))block{

    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:block];
}

#pragma mark -压缩图片
#pragma mark image method
//图片不能大于32k
+ (NSData *)scaleThumbImageData:(UIImage *)myimage
{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    float scale = 0.5;
    UIImage *newImage = [UIImage imageWithData:data];
    
    while (data.length > 300 * 1024)
    {
        //太大的 先重画
        newImage = [self scale:newImage toSize:CGSizeMake(newImage.size.width / 2., newImage.size.height / 2.)];
        data = UIImageJPEGRepresentation(newImage, 1.0);
    }
    
    while (data.length > 32 * 1024)
    {
        data = UIImageJPEGRepresentation(newImage, scale);
        scale = scale * 0.5;
        if (scale < 0.1)
        {
            newImage = [self scale:newImage toSize:CGSizeMake(newImage.size.width / 2., newImage.size.height / 2.)];
            scale = 1.0;
        }
    }
    return data;
}

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


//压缩图像
+ (NSData *)uu_imageData:(UIImage *)myimage
{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length > 1024 * 1024)
    {  // 1M以及以上
        data = UIImageJPEGRepresentation(myimage, 0.01);
    }
    else if (data.length > 512 * 1024)
    {  // 0.5M-1M
        data = UIImageJPEGRepresentation(myimage, 0.1);
    }
    else if (data.length > 256 * 1024)
    {  // 0.25M-0.5M
        data = UIImageJPEGRepresentation(myimage, 0.25);
    }
    else if (data.length > 128 * 1024)
    {  // 128k-0.25M
        data = UIImageJPEGRepresentation(myimage, 0.5);
    }
    return data;
}

#pragma marrk - model转换
- (QYShareModel *)convertToShareModel:(id<QYShareDelegate>) obj
{
    QYShareModel * shareModel = [[QYShareModel alloc] init];
    if ([obj respondsToSelector:@selector(getShareUrl)]) {
        
        shareModel.url = [obj getShareUrl];
    }
    if ([obj respondsToSelector:@selector(getShareTitle)]) {

        shareModel.title = [obj getShareTitle];
    }
    
    if([obj respondsToSelector:@selector(getShareContent)]){
    
        shareModel.content = [obj getShareContent];
    }
    if ([obj respondsToSelector:@selector(getShareImageContext)]){
        
        shareModel.imageContext = [obj getShareImageContext];
    }
    return shareModel;
}
@end

@implementation QYShareModel


@end
