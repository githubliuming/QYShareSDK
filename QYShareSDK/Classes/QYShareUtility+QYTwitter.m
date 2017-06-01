//
//  QYShareUtility+QYTwitter.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "QYShareTool.h"
#import "QYShareUtility+QYTwitter.h"
#import <Social/Social.h>
@implementation QYShareUtility (QYTwitter)


- (void)shareToTwitter:(NSString *)title
                 image:(id)image
                   url:(NSString *)url
            completion:(void (^)(NSInteger result))completion
{
    if ([self canOpenTwitter])
    {
        if ([self twitterHasAuthor])
        {
            UIImage *img = nil;
            if ([image isKindOfClass:[UIImage class]])
            {
                img = image;
            }
            if ([image isKindOfClass:[NSString class]])
            {
                img = [UIImage imageNamed:image];
            }
            if ([image isKindOfClass:[NSData class]])
            {
                img = [UIImage imageWithData:image];
            }
            SLComposeViewController *composeVC =
            [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [composeVC addURL:[NSURL URLWithString:url]];
            [composeVC addImage:img];
            [composeVC setInitialText:title];
            composeVC.completionHandler = ^(SLComposeViewControllerResult result) {
                
                if (completion)
                {
                    completion(result);
                }
                
            };
            // 如果用户未登录 twitter composeVC 为nil
            if (composeVC)
            {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composeVC
                                                                          animated:YES
                                                                        completion:nil];
            }
            else
            {
                [self authorTwitterCompletion:nil];
            }
        }
        else
        {
            [self authorTwitterCompletion:nil];
        }
    }
    else
    {
        [self showNotInstallTWitter];
    }
}
- (BOOL)canOpenTwitter { return [QYShareTool canOpenUrl:@"twitter://"]; }

- (BOOL)twitterHasAuthor
{
    BOOL result = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    return result;
}

- (void)authorTwitterCompletion:(void (^)(id *session, NSError *error))completion
{
    if ([self canOpenTwitter])
    {
        [QYShareTool canOpenUrl:@"twitter://login"];
    }
    else
    {
        [self showNotInstallTWitter];
    }
}

- (void)showNotInstallTWitter{

    [QYShareTool alert:@"提示" msg:@"未安装 twitter"];
}
@end
