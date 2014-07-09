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

// !!!: 应该让view去管理.
@property (retain, nonatomic) NSMutableArray * SNNVDelegates; //!< 当前各个视图的代理.
@property (retain, nonatomic) NSMutableDictionary * SNNVLoadedViews; //!< 存储已加载的视图.以新闻版块名为键,以视图为值.
@end

@implementation SNNewsViewController
-(void)dealloc
{
    self.model = nil;
    self.SNNVDelegates = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.SNNVDelegates = [NSMutableArray arrayWithCapacity: 42];
        self.SNNVLoadedViews = [NSMutableDictionary dictionaryWithCapacity: 42];
        
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
    self.navigationItem.title = @"影子";
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
- (void)SNNVCAddDelegateForCell: (SNNewsPageView *) cell
{
    SNNewsDelegate * delegate = [SNNewsDelegate delegateWithCell: cell];
    
    [self.SNNVDelegates addObject: delegate];
    
    // ???:建议只保留左右两端的代理对象或者只保留已加载视图的代理对象.
//    if (3 < self.SNNVDelegates.count) { // 最多存储3个代理即可.
//        [self.SNNVDelegates removeObjectAtIndex: 0];
//    }
}

/**
 *  为某个新闻版块添加视图.
 *
 *  @param view  新闻版块视图.
 *  @param title 新闻版块名.
 */
- (void)SNNVCAddLoadedView: (UIView *) view forTitle: (NSString *) title
{
    [self.SNNVLoadedViews setObject: view forKey: title];
    
    //!!!:暂时先不进行回收.算法有点复杂,需要考虑往返.
    // ???:建议只考虑
    // !!!:建议只存储 预加载视图.
    // !!!:建议,让视图自己去管理 "预加载" 到 "加载"的转换.
    // !!!:建议,让视图自己去管理delegate和dataSource的retain和release.
}

/**
 *  获取某个分区的预加载视图.
 *
 *  @param title 新闻版块名.
 *
 *  @return 新闻版块的预加载视图.
 */
- (SNNewsPageView *)SNNVCLoadedViewForTitle: (NSString *) title
{
    return [self.SNNVLoadedViews objectForKey: title];
}

/**
 *  菜单按钮的响应方法.
 *
 *  @param aButton 菜单按钮.
 */
- (void) SNNVCDidClickMenuButtonAction: (id) aButton
{
    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle: @"提示" message: @"菜单页面,还没写好呢!" delegate: nil cancelButtonTitle: @"确认" otherButtonTitles:nil];
    [alerView show];
    SNRelease(alerView);
}

/**
 *  菜单按钮的响应方法.
 *
 *  @param aButton 菜单按钮.
 */
- (void) SNNVCDidClickUserButtonAction: (id) aButton
{
    UIAlertView * alerView = [[UIAlertView alloc] initWithTitle: @"提示" message: @"用户页面,还没写好呢!" delegate: nil cancelButtonTitle: @"确认" otherButtonTitles:nil];
    [alerView show];
    SNRelease(alerView);
}


#pragma mark - SNNewsViewDataSource 协议方法
- (SNNewsPageView *)newsView:(SNNewsView *)newsView viewForTitle:(NSString *) title preLoad:(BOOL)preLoad
{
    SNNewsPageView * pageView = [self SNNVCLoadedViewForTitle: title];
    if (nil == pageView) {
        pageView = [SNNewsPageView pageWithTitle:title preLoad: preLoad];
        [self SNNVCAddLoadedView: pageView forTitle: title];
    }
    
    pageView.preLoad = preLoad;
    
    // !!!:有必要重设代理吗?有可能是预加载的东西.
    // !!!:建议让代理检测preLoad属性.或者重写 pageView preLoad的设置器.
    [self SNNVCAddDelegateForCell: pageView];
    // !!!:预加载,优先从本地读取数据,且只从本地读取数据.(除非本地数据不存在,再发起网络请求.).
    
    // !!!: title对应的url,应从配置文件或网络中动态获取.最好支持,动态从网络中更新.
    pageView.backgroundColor = [UIColor whiteColor];
    return pageView;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}

#pragma mark - SNNewsViewDelegate 协议方法.

@end
