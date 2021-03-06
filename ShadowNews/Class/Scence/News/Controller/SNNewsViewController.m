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
#import "SNNewsPageView.h"
#import "SNNewsDelegate.h"

@interface SNNewsViewController ()
@end

@implementation SNNewsViewController
-(void)dealloc
{
    self.model = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 不让控制器自动调整UIScrollview位置.
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        /* 在控制器初始化时,完成所有*/
        // TODO: 迭代至此! 一个猜想:  或许view在决定model,甚至controller,model,也应该用代理来限制,而不是一个具体的类型.意思说,也就是所谓的"泛型"!这样,V,C,M三者同时解耦,才可以真正做到解耦!原来如此.
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
    self.navigationItem.title = @"魅影资讯";
    
    self.model = [SNNewsModel model];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (YES == [self isViewLoaded] &&
        nil == self.view.window) {
        self.view = nil;
    }
}

#pragma mark - SNNewsViewDataSource 协议方法
- (SNNewsPageView *)newsView:(SNNewsView *)newsView viewForTitle:(NSString *) title preLoad:(BOOL)preLoad
{
    SNNewsPageView * pageView = [SNNewsPageView pageWithTitle:title preLoad: preLoad];
    pageView.preLoad = preLoad;
    SNNewsDelegate * delegate = [SNNewsDelegate delegateWithPageView: pageView];
    pageView.delegate = delegate;
    pageView.dataSource = delegate;
    pageView.backgroundColor = [UIColor whiteColor];
    return pageView;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}
@end
