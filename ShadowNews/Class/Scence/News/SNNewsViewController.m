//
//  SNNewsViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsViewController.h"
#import "SNNewsModel.h"
#import "SNNewsMenu.h"

@interface SNNewsViewController ()

@end

@implementation SNNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 不让控制器自动调整UIScrollview位置.
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)loadView
{
    SNNewsView * view = [[SNNewsView alloc] init];
    view.delegate = self;
    view.dataSource = self;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // !!!:控制器,应该可以自动向对应的model请求数据.等到数据请求完成后,再设置代理.
    // !!!: 由控制器来决定导航栏样式.
    // !!!: 美化一下导航栏.
    self.navigationItem.title = @"魅影资讯";
    // !!!:此处需要加按钮事件.
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle: @"菜单" style:UIBarButtonItemStylePlain target:nil action: NULL];
    self.navigationItem.leftBarButtonItem = leftItem;
    SNRelease(leftItem);
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle: @"用户" style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.rightBarButtonItem = rightItem;
    SNRelease(rightItem);
    
    // !!!:此处用block异步传值,是不是更合适?谁又能保证,菜单就不涉及网络请求?
    self.model = [SNNewsModel model];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SNNewsViewDataSource 协议方法
- (UIView *)newsView:(SNNewsView *)newsView viewForTitle:(NSString *) title preLoad:(BOOL)preLoad
{
    // !!!:预加载,优先从本地读取数据,且只从本地读取数据.(除非本地数据不存在,再发起网络请求.).
    
    UILabel * view = [[UILabel alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    view.text = title;
    SNAutorelease(view);
    return view;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}

#pragma mark - SNNewsViewDelegate 协议方法.

@end
