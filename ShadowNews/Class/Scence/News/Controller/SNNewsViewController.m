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
#import "SNMenuViewController.h"
#import "SNUserViewController.h"

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
    UIBarButtonItem * menuItem = [[UIBarButtonItem alloc] initWithTitle: @"菜单" style:UIBarButtonItemStylePlain target:self action: @selector(SNNVCDidClickMenuButtonAction:)];
    self.navigationItem.leftBarButtonItem = menuItem;
    SNRelease(menuItem);
    
    UIBarButtonItem * userItem = [[UIBarButtonItem alloc] initWithTitle: @"用户" style:UIBarButtonItemStylePlain target:self action: @selector(SNNVCDidClickUserButtonAction:)];
    self.navigationItem.rightBarButtonItem = userItem;
    SNRelease(userItem);
    
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

#pragma mark - 私有方法.
/**
 *  菜单按钮的响应方法.
 *
 *  @param aButton 菜单按钮.
 */
- (void) SNNVCDidClickMenuButtonAction: (id) aButton
{
    // !!!: 一个建议: 如果把菜单页面在新闻页面之前压入的话,会有抽屉的效果.
    SNMenuViewController * menuVC = [[SNMenuViewController alloc] init];
    [self.navigationController pushViewController:menuVC animated:YES];
    SNRelease(menuVC);
}

/**
 *  菜单按钮的响应方法.
 *
 *  @param aButton 菜单按钮.
 */
- (void) SNNVCDidClickUserButtonAction: (id) aButton
{
    SNUserViewController * userVC = [[SNUserViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
    SNRelease(userVC);
}


#pragma mark - SNNewsViewDataSource 协议方法
- (SNNewsPageView *)newsView:(SNNewsView *)newsView viewForTitle:(NSString *) title preLoad:(BOOL)preLoad
{
    SNNewsPageView * pageView = [SNNewsPageView pageWithTitle:title preLoad: preLoad];
    pageView.preLoad = preLoad;
    SNNewsDelegate * delegate = [SNNewsDelegate delegateWithCell: pageView];
    pageView.delegate = delegate;
    pageView.dataSource = delegate;
    
    // !!!: 建议加一个有意义的背景色.
    pageView.backgroundColor = [UIColor whiteColor];
    return pageView;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}

#pragma mark - SNNewsViewDelegate 协议方法.
- (void) newsView: (SNNewsView *) newsView  didClickSettingButtonButtonAction:(UIButton *) button
{
    // TODO:跳转到设置页面.
}
@end
