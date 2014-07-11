//
//  SNNewsDetailViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailViewController.h"
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
        self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    [SNNewsModel detailModelWithDocId:self.docId success:^(id responseObject) {
        self.SNNDDVCDetail = responseObject;
        [self SNNDVCSetUpTitleView];
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
    [[SNNavigationController sharedInstance] popViewControllerAnimated: YES];
}


/**
 *  自定义导航栏.
 */
// !!!: 这个方法的命名有问题!
- (void) SNNDVCSetUpTitleView
{
    // !!!: 下面这个逻辑,应该封装到view中.
    // !!!: 使用"约束语法".改造下.
    /* 返回按钮. */
//    self.navigationItem.hidesBackButton = YES;
//    UIView * titleView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 3200, 44)];
//    titleView.backgroundColor = [UIColor redColor];
//    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contenttoolbar_hd_back"] style:UIBarButtonItemStylePlain target:self action:@selector(SNNDVCDidClickBackButtonItemAction:)];
//    backButtonItem.tintColor = [UIColor grayColor];
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView: titleView];
////    self.navigationItem.leftBarButtonItem = item;
////    [titleView addSubview: backButtonItem];
////    self.navigationItem.leftBarButtonItem = backButtonItem;
//    SNRelease(backButtonItem);
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//    [self.navigationController setNavigationBarHidden: YES animated: YES];
//    self.navigationItem.titleView = titleView
    ;
    /* 跟帖按钮. */
//    UIBarButtonItem * commentBackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contentview_commentback@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(SNNDCDidClickCommentBackButtonItemAciton:)];
//    NSString * replyStr = [NSNumber numberWithUnsignedInteger:self.SNNDDVCDetail.replyCount];
    UIBarButtonItem * commentBackButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat: @"%@ 跟帖", [NSNumber numberWithUnsignedInteger:self.SNNDDVCDetail.replyCount]] style:UIBarButtonItemStyleBordered target:self action:@selector(SNNDCDidClickCommentBackButtonItemAciton:)];
    
    [commentBackButtonItem setBackgroundImage:[UIImage imageNamed:@"contentview_commentbacky@2x.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    commentBackButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES;
    
//    self.navigationItem.rightBarButtonItem = commentBackButtonItem;
    
    /* 底部页面 */
    // ???:这个视图,和webView应该是平级关系.
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 500, 320, 68)];
//    view.backgroundColor = [UIColor grayColor];
//    
//    // !!!:此处应该还有一个编辑按钮.
//    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 180, 48)];
//    field.placeholder = @"写跟帖";
//    field.backgroundColor = [UIColor blueColor];
//    [view addSubview: field];
//    SNRelease(field);
//    
//    UIButton * favButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    favButton.frame = CGRectMake(200, 10, 50, 48);
//    [favButton setImage:[UIImage imageNamed: @"contenttoolbar_hd_fav_light.png"] forState:UIControlStateNormal];
//    [favButton addTarget: self action:@selector(SNNDVCDidClickFavButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview: favButton];
//    
//    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [shareButton addTarget: self action:@selector(SNNDVCDidClickShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    shareButton.frame = CGRectMake(240, 10, 50, 48);
//    [shareButton setImage: [UIImage imageNamed: @"contenttoolbar_hd_share_light.png"] forState:UIControlStateNormal];
//    [view addSubview: shareButton];
//    
//    [self.view addSubview: view];
//    SNRelease(view);
}

// !!!: 跟帖的借口,是get请求,与docid存在对应关系.,但是需要分析,预处理一下,才可以显示.
// !!!: 关于跟帖借口:
/*1.发起网络请求先,做了一次判断,所以本地必然存在字段记录登陆状态.
 */
// !!!:第三方登陆:只提供对微博和扣扣的登陆即可,只允许第三方登陆.
// !!!:验证下:网易的评论接口,是不是只要格式对,就可以评论,并没有严格的本地验证?还是服务端已经存储了相关会话信息,才可以评论的?(注意: 不是同一款应用哦,意思是说,伪造session了?什么时候?)
- (void)SNNDVCDidClickShareButtonAction: (UIButton *) button
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享页面还没做好呢!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)SNNDVCDidClickFavButtonAction: (UIButton *) button
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏功能还没实现呢!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)SNNDCDidClickCommentBackButtonItemAciton:(UIBarButtonItem *) item
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"跟帖页面还没做好呢!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - 协议方法.
- (SNNewsDetail *)detailInNewsDetailView:(SNNewsDetailView *)newsDetailView
{
    return self.SNNDDVCDetail;
}

@end
