//
//  SNNewsDetailView.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailView.h"
#import "SNNewsDetail.h"

// ???:点击超链接,跳转到ios应用界面,怎么实现的?
@interface SNNewsDetailView ()
@property (retain, nonatomic) SNNewsDetail * SNNDVDetail; //!< 新闻详情.
@property (retain, nonatomic) UIWebView * SNNDVWebView; //!< 用于显示新闻主体信息.
@property (retain, nonatomic) UIButton * SNNDVFavorButton; //!< 收藏按钮.
@end
@implementation SNNewsDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (nil == self.window) {
        [self SNNDSetUpSubviews];
    }
}

- (void)reloadData
{
    // 重置和数据相关的属性.
    self.SNNDVDetail = [self.dataSource detailInNewsDetailView: self];
    
    [self.SNNDVWebView loadHTMLString: self.SNNDVDetail.htmlStr baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    self.SNNDVWebView.allowsInlineMediaPlayback = YES;
    [self.SNNDVWebView loadHTMLString: self.SNNDVDetail.htmlStr baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
    
    if (IOS_VERSION >= 4.3)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification"object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullcreenNotification"object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullcreenNotification"object:nil];
    }
}

- (void)enterFullScreen:(id)nocc
{

}
- (void)exitFullScreen:(id)nocc
{
    [self.SNNDVWebView loadHTMLString: self.SNNDVDetail.htmlStr baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

// !!!: 使用属性,很鸡肋的方法.而且和reloadData中原来的    self.SNNDVDetail = nil; 容易一起误解.
- (SNNewsDetail *)SNNDVDetail
{
    if (nil == _SNNDVDetail) {
        self.SNNDVDetail = [self.dataSource detailInNewsDetailView: self];
    }
    
    return _SNNDVDetail;
}

/**
 *  设置子视图.
 */
- (void) SNNDSetUpSubviews
{
    // ???:webView有一定几率可以左移,部分视图中.
    // !!!: 完善"写跟帖"和"分享"界面.
    
    /* 创建视图. */
    UIView * navigationView = [[UIView alloc] init];
    [navigationView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self addSubview: navigationView];
    navigationView.backgroundColor = [UIColor whiteColor];
    SNRelease(navigationView);
    
    UIView * navigationContentView = [[UIView alloc] init];
    [navigationContentView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [navigationView addSubview: navigationContentView];
    
    // !!!: 这个颜色,可以根据主题改变.详情页面应该再加个属性.
    navigationContentView.backgroundColor = [UIColor blackColor];
    SNRelease(navigationContentView);
    
    // !!!:看一下其他按钮样式的效果.
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [backButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    [backButton setTitle: @"返回" forState: UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton addTarget: self.delegate action: @selector(newsDetailView:didClickBackButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    [navigationContentView addSubview: backButton];
    
//    UIButton * scanCommentsButton = [UIButton buttonWithType: UIButtonTypeSystem];
//    [scanCommentsButton setTranslatesAutoresizingMaskIntoConstraints: NO];
//    [scanCommentsButton setTitle: @"查看评论(+0)" forState: UIControlStateNormal];
//    scanCommentsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [scanCommentsButton setTintColor:[UIColor whiteColor]];
//    [scanCommentsButton addTarget: self.delegate action: @selector(newsDetailView:didClickScanReplyButtonAction:) forControlEvents: UIControlEventTouchUpInside];
//    [navigationContentView addSubview: scanCommentsButton];
    
    UIWebView * webView = [[UIWebView alloc] init];
    [webView setTranslatesAutoresizingMaskIntoConstraints: NO];
    webView.scrollView.bounces = NO;
    [self addSubview: webView];
    SNRelease(webView);
    self.SNNDVWebView = webView;
    [self sendSubviewToBack: webView];
    
    
    // ???: 暂时先用自身做代理.
    // !!!: 迭代至此!
    webView.delegate = self;
    
//    UIView * bottomView = [[UIView alloc] init];
//    [bottomView setTranslatesAutoresizingMaskIntoConstraints: NO];
//    bottomView.backgroundColor = [UIColor blackColor];
//    [self addSubview: bottomView];
//    SNRelease(bottomView);
//    
//    UITextField * commentTF = [[UITextField alloc] init];
//    [commentTF setTranslatesAutoresizingMaskIntoConstraints: NO];
//    commentTF.backgroundColor = [UIColor whiteColor];
//    commentTF.placeholder = @"说点什么吧...";
//    [bottomView addSubview: commentTF];
//    SNRelease(commentTF);
//    
//    UIButton * shareButton = [UIButton buttonWithType: UIButtonTypeSystem];
//    [shareButton setTranslatesAutoresizingMaskIntoConstraints: NO];
//    [shareButton setTitle: @"分享" forState: UIControlStateNormal];
//    [shareButton setTintColor: [UIColor whiteColor]];
//    [shareButton addTarget: self.delegate action: @selector(newsDetailView:didClickShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview: shareButton];
//    
//    UIButton * favorButton = [UIButton buttonWithType: UIButtonTypeSystem];
//    [favorButton setTranslatesAutoresizingMaskIntoConstraints: NO];
//    [favorButton setTitle: @"收藏(未)" forState: UIControlStateNormal];
//    [favorButton setTintColor: [UIColor whiteColor]];
//    [favorButton addTarget: self.delegate action: @selector(newsDetailView:didClickFavorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview: favorButton];
    
    /* 设置视图约束. */
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[navigationView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[navigationContentView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationContentView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-20-[navigationContentView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationContentView)]];
    
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|-(8)-[backButton(==35)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(backButton)]];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|-(8)-[backButton(==35)]-(>=0)-[scanCommentsButton(==100)]-(8)-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(backButton, scanCommentsButton)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[backButton(==44)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(backButton)]];

//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scanCommentsButton(==backButton)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scanCommentsButton, backButton)]];
//    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[webView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(webView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[navigationView(==64)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationView,webView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[webView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationView,webView)]];
    
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[navigationView(==64)][webView][bottomView(==44)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(navigationView,webView,bottomView)]];
//    
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[bottomView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(bottomView)]];
//    
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|-(8)-[commentTF]-[shareButton(==50)]-[favorButton(==70)]-(8)-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(commentTF, shareButton, favorButton)]];
    
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-(8)-[commentTF]-(8)-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(commentTF)]];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-(8)-[shareButton]-(8)-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(shareButton)]];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-(8)-[favorButton]-(8)-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(favorButton)]];
    
    [self addConstraints: constraintsArray];
}

#pragma mark - 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
