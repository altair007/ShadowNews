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

#pragma mark - 私有方法.
- (void)addDelegateForCell: (SNNewsPageView *) cell
{
    SNNewsDelegate * delegate = [SNNewsDelegate delegateWithCell: cell model:self.model];
    
    [self.SNNVDelegates addObject: delegate];
    
    if (3 < self.SNNVDelegates.count) { // 最多存储3个代理即可.
        [self.SNNVDelegates removeObjectAtIndex: 0];
    }
}

#pragma mark - SNNewsViewDataSource 协议方法
- (SNNewsPageView *)newsView:(SNNewsView *)newsView viewForTitle:(NSString *) title preLoad:(BOOL)preLoad
{
    SNNewsPageView * cell = [SNNewsPageView cellWithTitle:title preLoad: preLoad];
    
    [self addDelegateForCell: cell];
    // !!!:预加载,优先从本地读取数据,且只从本地读取数据.(除非本地数据不存在,再发起网络请求.).
    
    // !!!: title对应的url,应从配置文件或网络中动态获取.最好支持,动态从网络中更新.
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (SNNewsMenu *) menuInNewsView: (SNNewsView *) newsView
{
    return self.model.menu;
}

#pragma mark - SNNewsViewDelegate 协议方法.

@end
