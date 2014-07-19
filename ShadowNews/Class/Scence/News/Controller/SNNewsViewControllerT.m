//
//  SNNewsViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsViewControllerT.h"
#import "SNNewsMenu.h"
#import "SNNewsPageView.h"
#import "SNNewsDelegate.h"
#import "SNNewsDetailViewControllerT.h"
#import "SNNewsModel.h"

@interface SNNewsViewControllerT ()
@end

@implementation SNNewsViewControllerT
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
    }
    return self;
}

//- (void)loadView
//{
//    SNNewsView * view = [[SNNewsView alloc] init];
//    view.delegate = self;
//    view.dataSource = self;
//    self.view = view;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 不让控制器自动调整UIScrollview位置.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SNNewsView * view = (SNNewsView *)self.view;
    view.delegate = self;
    view.dataSource = self;
    
    /* 在控制器初始化时,完成所有数据的请求. */
    // !!!: 这个好像,应该在外部指定.
    // !!!: 迭代至此!
    self.model = [SNNewsModel model];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SNNewsDetailViewControllerT * detailVC = (SNNewsDetailViewControllerT *)segue.destinationViewController;
    detailVC.docId = sender;
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
    delegate.newsVC = self;
    pageView.backgroundColor = [UIColor whiteColor];
    return pageView;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}
@end
