//
//  SNUserViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-9.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNUserViewController.h"

@interface SNUserViewController ()

@end

@implementation SNUserViewController

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
    // !!!: 临时先这么写.
    // !!!:底部,好像的确是一个背景图片.
    // !!!:周末根据沙盒中的xib文件,修正一下布局.
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.alpha = 0.5;
    
    // !!!:暂时先用button.
    CGFloat height = 0;
    NSArray * titles = @[@"登陆", @"收藏", @"跟帖", @"消息", @"天气", @"离线", @"夜间", @"搜索", @"邮件", @"扫码", @"每日一槽", @"添加", @"设置"];
    for (NSUInteger i = 0; i < titles.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0.0, height, 100.0, 50.0);
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget: self action:@selector(SNMVCDidClickUserItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview: button];
        
        height += 50.0;
    }
    
    self.view = view;

    // !!!: 验证下: 是被推出视图的view 出现后,上一个页面的view才会消失.
    // !!!: 猜想,可以强制捕捉 viewMovetoWindow事件,强制保留方法.
    
    // !!!: 抽屉思路: 控制器间切换的动画,应该也是可以控制的.仔细观察下效果,推测可能的层级关系,控制器间的层架关系.
}

// !!!: 解析字符串的操作: 可以直接用于网页替换,这样,效率更高.
// !!!: 一个猜想: 其实用webView替代ImageView显示网络图片,才是最合适的吧,因为它本身就会自动异步加载图片.
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

- (void)SNMVCDidClickUserItemAction: (UIButton *) button
{
    NSString * title = [button titleForState:UIControlStateNormal];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"提示" message: [NSString stringWithFormat:@"%@ 页面还没实现!对不起...  我慢了  ...", title] delegate: nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

@end
