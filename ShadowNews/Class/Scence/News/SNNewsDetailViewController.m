//
//  SNNewsDetailViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailViewController.h"
#import "SNNewsDetailView.h"
#import "SNNewsModel.h"
#import "SNNewsDetail.h"
#import "SNNavigationController.h"

@interface SNNewsDetailViewController ()
@property (retain, nonatomic) SNNewsDetail * SNNDDVCDetail; //!< 新闻详情.
@end

@implementation SNNewsDetailViewController
- (instancetype) initWIthDocId: (NSString *) docId
{
    if (self = [super init]) {
        self.docId = docId;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // !!!:这个属性,或许可以用来实现抽屉效果.或者下拉菜单.
//        self.modalInPopover = YES;
    }
    return self;
}

- (void)loadView
{
    SNNewsDetailView * view = [[SNNewsDetailView alloc] init];
    self.view = view;
    SNRelease(view);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 猜测: 可以根据 导航栏的 pop 对手势的默认支持,模拟抽屉效果.back方法,是什么意思?
    
    /* 自定义导航栏. */
//    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"返回" style:UIBarButtonItemStylePlain target:self action: @selector(SNNDVCDidClickBackButtonItemAction:)];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // !!!:测试
    [self SNNDVCSetUpTitleView];
    
    
    
    [SNNewsModel detailModelWithDocId:self.docId success:^(id responseObject) {
        self.SNNDDVCDetail = responseObject;
        self.view.delegate = self;
        self.view.dataSource = self;
        [self.view reloadData];
    } fail:^(NSError *error) {
        // ???:优化方向:网易的"弹窗"会自动消失哦!
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"提示" message: @"网络故障!无法联网获取最新资讯!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
}

- (void) SNNDVCDidClickBackButtonItemAction: (id) sender
{
    
}
#pragma mark - 协议方法.
- (SNNewsDetail *)detailInNewsDetailView:(SNNewsDetailView *)newsDetailView
{
    return self.SNNDDVCDetail;
}

- (void) SNNDVCSetUpTitleView
{
    // !!!: 使用"约束语法".
    // !!!: 猜测:底部,估计是重写了tabBar.
    // !!!: 迭代至此.
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
}
@end
