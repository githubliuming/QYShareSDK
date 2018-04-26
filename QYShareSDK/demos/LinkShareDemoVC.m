//
//  LinkShareDemoVC.m
//  QYShareSDK
//
//  Created by liuming on 2018/4/26.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "LinkShareDemoVC.h"

@implementation LinkShareDemoVC
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
    shareMdoel.url = @"http://www.baidu.com";
    shareMdoel.title = @"这是一个链接";
    shareMdoel.content = @"这个链接很好玩";
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
    [self.shareSever startShare:shareMdoel platformType:platform shareType:QYShareTypeUrl];
    
}
@end
