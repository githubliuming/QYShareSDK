//
//  TwitterShareComponet.m
//  QYShareSDK
//
//  Created by liuming on 2018/3/15.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "TwitterShareComponet.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "QYShareTool.h"
@implementation TwitterShareComponet
@synthesize shareType,platform,delegate;


- (void)registerInterfaceWithAPPID:(NSString *)appId
                         secretKey:(NSString *)secretKey
                       redirectUrl:(NSString *)redirectUrl
                       application:(UIApplication *)application
                     launchOptions:(NSDictionary*)launchOptions
{
    
}

- (void)authoried
{
    if (![self hasAuthorized])
    {
        [QYShareTool openUrlShemes:@"twitter://login"];
    }
}

- (BOOL)hasAuthorized {
    
    BOOL result = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    return result;
}

- (BOOL)isInstallAPPClient
{
    return [QYShareTool canOpenUrlShemes:@"twitter://"];
}

- (void)shareGif:(id<QYShareConfig>)interface
{
    
}

- (void)shareImage:(id<QYShareConfig>)interface
{
    [self shareToTwitterWithIntnerface:interface];
}

- (void)shareText:(id<QYShareConfig>)interface
{
    [self shareToTwitterWithIntnerface:interface];
}

- (void)shareUrl:(id<QYShareConfig>)interface
{
    [self shareToTwitterWithIntnerface:interface];
}

- (void)shareVideo:(id<QYShareConfig>)interface
{
    [self shareToTwitterWithIntnerface:interface];
}

- (void)shareToTwitterWithIntnerface:(id<QYShareConfig>)config
{
    [self shareToTwitter:config.title
                   image:[config.images firstObject]
                     url:config.url
              completion:^(NSInteger result) {
        
        [self qy_handlerResutl:result errorMsg:nil];
    }];
}


- (void)shareToTwitter:(NSString *)title
                 image:(id)image
                   url:(NSString *)url
            completion:(void (^)(NSInteger result))completion
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
                [[QYShareTool nx_currentViewController] presentViewController:composeVC
                                                                          animated:YES
                                                                        completion:nil];
            }
            else
            {
                [self authoried];
            }
}

- (void) shareGif:(NSData *)gifData title:(NSString *)title completion:(void(^)(NSInteger result)) completion
{
    if ([self hasAuthorized])
    {
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
        NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
        if (title.length == 0)
        {
            title = @"";
        }
        [paramater setObject:title forKey:@"status"];
        [QYShareTool requestSocialAccountAuthor:ACAccountTypeIdentifierTwitter complent:^(BOOL granted, NSError *error) {
            
            if (granted)
            {
                NSArray *accountsArray = [self getAccountUsers:ACAccountTypeIdentifierTwitter];
                if (accountsArray.count > 0)
                {
                    [self requset:url
                           params:paramater
                      serviceType:SLServiceTypeTwitter
                          account:[accountsArray lastObject]
                           method:SLRequestMethodPOST
                    multipartData:^(SLRequest *postRequest) {
                        
                        [postRequest addMultipartData:gifData withName:@"media[]" type:@"image/gif" filename:@"animated.gif"] ;
                    }
                    complentBlock:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if (completion)
                        {
                            completion(error == nil);
                        }
                    }];
                }
                else
                {
                    NSLog(@"没有用户");
                    [self authoried];
                }
            } else {
                
                NSLog(@"拒绝授权权限");
            }
        }];
        
    }
}
- (void)requset:(id)url params:(NSDictionary *)params
    serviceType:(NSString *)type
        account:(ACAccount *)account
         method:(SLRequestMethod)method
  multipartData:(void(^)(SLRequest *postRequest))mutipartBlock
  complentBlock:(SLRequestHandler)handler{
    
    NSURL * hostUrl  =nil;
    if ([url isKindOfClass:[NSURL class]])
    {
        hostUrl = url;
    } else if ([url isKindOfClass:[NSString class]])
    {
        hostUrl = [NSURL URLWithString:url];
    } else {
        
        NSLog(@"url 不符合格式");
        return ;
    }
    SLRequest *postRequest = [SLRequest requestForServiceType:type requestMethod:method URL:hostUrl parameters:params];
    [postRequest setAccount:account];
    if(mutipartBlock)
    {
        mutipartBlock(postRequest);
    }
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *output = [NSString stringWithFormat:@"HTTP response status: %li", (long)[urlResponse statusCode]];
        NSLog(@"output = %@",output);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(responseData,urlResponse,error);
            }
        });
        
    }];
}
- (void)qy_handlerResutl:(NSInteger)result errorMsg:(NSString *)string
{
    if (self.delegate)
    {
        if (result == 1 && [self.delegate respondsToSelector:@selector(publishFinishedWith:)])
        {
            [self.delegate publishFinishedWith:self.platform];
        }
        if (result == 0 && [self.delegate respondsToSelector:@selector(publishCanceldedWith:)])
        {
            [self.delegate publishCanceldedWith:self.platform];
        }
        
        if (result == -1 && [self.delegate respondsToSelector:@selector(publishFailedWith:errorString:)])
        {
            
            [self.delegate publishFailedWith:self.platform errorString:string];
        }
        
    }
}
-(NSArray *)getAccountUsers:(NSString *) accountTypeIndentifier
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:accountTypeIndentifier];
    return [accountStore accountsWithAccountType:accountType];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    
    return YES;
}

@end
