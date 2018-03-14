//
//  QYShareTool.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/14.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "QYShareTool.h"
#import <UIKit/UIKit.h>
@implementation QYShareTool

+(NSData *)scaleThumbImageData:(UIImage *)myimage
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

+ (BOOL)canOpenUrlShemes:(NSString *)urlShemes
{
    NSURL *url = [NSURL URLWithString:urlShemes];
    return [[UIApplication sharedApplication] canOpenURL:url];
}
+ (BOOL)openUrlShemes:(NSString *)urlShemes
{
    NSURL *url = [NSURL URLWithString:urlShemes];
    return [[UIApplication sharedApplication] openURL:url];
}
@end
