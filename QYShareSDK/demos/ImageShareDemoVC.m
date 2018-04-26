//
//  ImageShareDemoVC.m
//  QYShareSDK
//
//  Created by liuming on 2018/4/26.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "ImageShareDemoVC.h"

@implementation ImageShareDemoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = nil;
    if (indexPath.row >= 0 && indexPath.row <self.dataSource.count) {
        
        dic = self.dataSource[indexPath.row];
    }
    
    QYShareModel * shareMdoel  =[[QYShareModel alloc] init];
    shareMdoel.title = @"这是一张图片";
    shareMdoel.content = @"这个图片可以玩一年";
    shareMdoel.images = @[[UIImage imageNamed:@"WechatIMG31.jpeg"]];
    QYSharePlatform platform = [dic[NXPlatformKey] integerValue];
    if (platform == QYSharePlatform_SinaWB)
    {
        if (![self.shareSever hasAuthor:QYSharePlatform_SinaWB])
        {
            [self.shareSever authoried:QYSharePlatform_SinaWB];
            return;
        }
    }
    [self.shareSever startShare:shareMdoel platformType:platform shareType:QYShareTypeImage];
    
}
@end
