//
//  ViewController.m
//  QYShareSDK
//
//  Created by liuming on 2017/5/31.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "ViewController.h"
#import "GifShareDemoVC.h"
#import "LinkShareDemoVC.h"
#import "ImageShareDemoVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void) initDataSource{
    
    NSArray * array = @[
                        @{
                            NXListTiltleKey:@"链接分享",
                            NXListVCKey:[LinkShareDemoVC class]
                            },
                        @{
                            NXListTiltleKey:@"图片分享",
                            NXListVCKey:[ImageShareDemoVC class]
                            },
                        @{
                            NXListTiltleKey:@"gif分享",
                            NXListVCKey:[GifShareDemoVC class]
                            },
                        ];
    [self.dataSource addObjectsFromArray:array];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
