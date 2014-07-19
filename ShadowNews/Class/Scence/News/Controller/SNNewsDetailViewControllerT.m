//
//  SNNewsDetailViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailViewControllerT.h"
#import "SNNewsModel.h"
#import "SNNewsDetail.h"
#import "SNNavigationController.h"

@interface SNNewsDetailViewControllerT ()
@property (retain, nonatomic) SNNewsDetail * SNNDDVCDetail; //!< 新闻详情.
@end

@implementation SNNewsDetailViewControllerT
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
    
    /* 自定义导航栏. */
    
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
    [[SNNavigationController sharedInstance] popViewControllerAnimated: YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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

- (void)newsDetailView:(SNNewsDetailView *)newsDetailView didClickBackButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated: YES];
}
@end
