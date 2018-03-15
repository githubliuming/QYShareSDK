//
//  QYShareTool.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/14.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "QYShareTool.h"
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
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

+ (UIViewController *)nx_currentViewController
{
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self nx_findBestViewController:viewController];
}

+ (UIViewController *)nx_findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController)
    {
        // Return presented view controller
        return [self nx_findBestViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UISplitViewController class]])
    {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0)
            return [self nx_findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    }
    else if ([vc isKindOfClass:[UINavigationController class]])
    {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0)
            return [self nx_findBestViewController:svc.topViewController];
        else
            return vc;
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
            return [self nx_findBestViewController:svc.selectedViewController];
        else
            return vc;
    }
    else
    {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (void)requestSocialAccountAuthor:(NSString *)accountTypeIndentifier complent:(void(^)(BOOL granted, NSError *error)) block
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *sinaWeiboAccount = [accountStore accountTypeWithAccountTypeIdentifier:accountTypeIndentifier];
    
    [accountStore requestAccessToAccountsWithType:sinaWeiboAccount
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           
                                           if (block)
                                           {
                                               block(granted,error);
                                           }
                                       }];
}
@end
