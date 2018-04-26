//
//  GifShareDemoVC.m
//  QYShareSDK
//
//  Created by liuming on 2018/4/26.
//  Copyright © 2018年 burning. All rights reserved.
//

#import "GifShareDemoVC.h"
#import "QYShareModel.h"
@implementation GifShareDemoVC

-(void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = nil;
    if (indexPath.row >= 0 && indexPath.row <self.dataSource.count) {
        
        dic = self.dataSource[indexPath.row];
    }
    NSString * gifPath =[[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
    QYShareModel * shareMdoel  =[[QYShareModel alloc] init];
    shareMdoel.images = @[[UIImage imageWithContentsOfFile:gifPath]];
    shareMdoel.gifPath = gifPath;
    QYSharePlatform platform = [dic[NXPlatformKey] integerValue];
    if (platform == QYSharePlatform_SinaWB)
    {
        if (![self.shareSever hasAuthor:QYSharePlatform_SinaWB])
        {
            [self.shareSever authoried:QYSharePlatform_SinaWB];
            return;
        }
    }
    [self.shareSever startShare:shareMdoel platformType:platform shareType:QYShareTypeGif];
    
}
@end
