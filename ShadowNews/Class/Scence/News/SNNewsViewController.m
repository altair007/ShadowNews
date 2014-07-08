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
        
        // 不让控制器自动调整UIScrollview位置.
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        // ???:或许应该设置一个数组,来存储代理,因为可能有多个代理.
        self.SNNVDelegates = [NSMutableArray arrayWithCapacity: 42];
        
        self.SNNVLoadedViews = [NSMutableDictionary dictionaryWithCapacity: 42];
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
    self.navigationItem.title = @"影子";
    // !!!:此处需要加按钮事件.
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle: @"菜单" style:UIBarButtonItemStylePlain target:nil action: NULL];
    self.navigationItem.leftBarButtonItem = leftItem;
    SNRelease(leftItem);
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle: @"用户" style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.rightBarButtonItem = rightItem;
    SNRelease(rightItem);
    
    self.model = [SNNewsModel model];
}

// ???:有一个综合BUG:  程序一段时间后,会无缘无故崩掉.
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
    
    // ???:综合BUG出现的原因可能是,数组的顺序是固定的,左右往返滑动时,顺序错乱,会出现错误的提前释放.
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
// ???:感觉方法的命名有问题.
- (void)SNNVCAddLoadedView: (UIView *) view forTitle: (NSString *) title
{
    [self.SNNVLoadedViews setObject: view forKey: title];
    
    //!!!:暂时先不进行回收.算法有点复杂,需要考虑往返.
    // !!!:建议只存储 预加载视图.
}

/**
 *  获取某个分区的预加载视图.
 *
 *  @param title 新闻版块名.
 *
 *  @return 新闻版块的预加载视图.
 */
// ???:感觉方法的命名有问题.
- (SNNewsPageView *)SNNVCLoadedViewForTitle: (NSString *) title
{
    return [self.SNNVLoadedViews objectForKey: title];
}

#pragma mark - SNNewsViewDataSource 协议方法
- (SNNewsPageView *)newsView:(SNNewsView *)newsView viewForTitle:(NSString *) title preLoad:(BOOL)preLoad
{
    // ???:应该让谁管理预加载的视图????
    // ???:迭代至此!让控制器管理预加载视图.
    // ???:cellWithTitle: 的方法名有问题.
    SNNewsPageView * pageView = [self SNNVCLoadedViewForTitle: title];
    if (nil == pageView) {
        pageView = [SNNewsPageView cellWithTitle:title preLoad: preLoad];
        [self SNNVCAddLoadedView: pageView forTitle: title];
    }
    
    pageView.preLoad = preLoad;
    
    // !!!:有必要重设代理吗?有可能是预加载的东西.
    // !!!:建议让代理检测preLoad属性.或者重写 pageView preLoad的设置器.
    [self SNNVCAddDelegateForCell: pageView];
    // !!!:预加载,优先从本地读取数据,且只从本地读取数据.(除非本地数据不存在,再发起网络请求.).
    
    // !!!: title对应的url,应从配置文件或网络中动态获取.最好支持,动态从网络中更新.
    pageView.backgroundColor = [UIColor grayColor];
    return pageView;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}

#pragma mark - SNNewsViewDelegate 协议方法.

@end
