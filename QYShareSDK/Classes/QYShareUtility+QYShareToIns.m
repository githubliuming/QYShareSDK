//
//  QYShareUtility+QYShareToIns.m
//  QYShareSDK
//
//  Created by 明刘 on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYShareUtility+QYShareToIns.h"
#import "QYShareTool.h"
#import <UIKit/UIKit.h>
@implementation QYShareUtility (QYShareToIns)

- (void)shareVideToInstagram:(NSString *)videoPath
{
    if ([self canOpenInstagram])
    {
        [QYShareTool saveToAlbum:videoPath
              complandler:^(NSURL *url, NSError *error) {
                  
                  if (error == nil)
                  {
                      [self shareVideoToInstagramWithAlbumUrl:url];
                  } else {
                  
                       NSLog(@"写入视频到相册失败 error info = %@",[error userInfo]);
                  }
              }];
    }
    else
    {
        [self showNotInstallIns];
    }
}
- (void)shareVideoToInstagramWithAlbumUrl:(NSURL *)albumUrl
{
    NSString *caption = @"#Philm";
    NSURL *instagramURL =
    [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",
                          [[albumUrl absoluteString]
                           stringByAddingPercentEncodingWithAllowedCharacters:
                           [NSCharacterSet alphanumericCharacterSet]],
                          [caption stringByAddingPercentEncodingWithAllowedCharacters:
                           [NSCharacterSet alphanumericCharacterSet]]]];
    if ([QYShareTool canOpenUrl:instagramURL.path])
    {
        [QYShareTool openUrl:instagramURL];
    }
    else
    {
        NSLog(@"Can't open Instagram  %@", instagramURL.absoluteString);
        [self showNotInstallIns];
    }
}


- (void)showNotInstallIns{

    
    [QYShareTool alert:@"提示" msg:@"未安装ins"];
}

- (BOOL)canOpenInstagram { return [QYShareTool canOpenUrl:@"instagram://"]; }
@end
