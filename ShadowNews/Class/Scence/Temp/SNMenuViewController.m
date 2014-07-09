//
//  SNMenuViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-9.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNMenuViewController.h"

@interface SNMenuViewController ()

@end

@implementation SNMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    // !!!:猜想: 或许,其实只有左中右,三张视图.点不同的菜单,给中间的视图传不同的值,如此而已.
    // !!!: 临时先这么写.
    // ???: 侧面应该是一个tabBar,tabBar可以竖着放嘛?
    // ???: 一个猜想:控制器二次更改了view的 insset值,又或者两个抽屉与controller本身就是一个整体.
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    view.opaque = YES;
    
    // !!!:暂时先用button.
    CGFloat height = 0;
    NSArray * titles = @[@"新闻", @"订阅", @"图片", @"视频", @"跟帖", @"投票"];
    for (NSUInteger i = 0; i < 6; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, height, 100.0, 50.0);
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget: self action:@selector(SNMVCDidClickMenuItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview: button];
        
        height += 50.0;
    }
    
    self.view = view;
    SNRelease(view);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SNMVCDidClickMenuItemAction: (UIButton *) button
{
    NSString * title = [button titleForState:UIControlStateNormal];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"提示" message: [NSString stringWithFormat:@"%@ 页面还没实现!对不起...  我慢了  ...", title] delegate: nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
