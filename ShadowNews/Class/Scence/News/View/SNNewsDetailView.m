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
@property (retain, nonatomic) UITextField * SNNDVReplyTF; //!< 跟帖编辑框.
@property (retain, nonatomic) UIButton * SNNDVShareButton; //!< 分享按钮.
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
    self.SNNDVDetail = nil;
    
    [self.SNNDVWebView loadHTMLString: self.SNNDVDetail.body baseURL:nil];
}

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
    [self setTranslatesAutoresizingMaskIntoConstraints: YES];
    // !!!: 临时测试UIView
    // TODO: 迭代至此,不建议重写导航栏.
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [view setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self addSubview: view];
    
    /* 设置视图. */
    UIWebView * webView = [[UIWebView alloc] init];
    webView.scrollView.bounces = NO;
    [webView setTranslatesAutoresizingMaskIntoConstraints: NO];
    self.SNNDVWebView = webView;
    SNRelease(webView);
    [self addSubview: self.SNNDVWebView];
    self.SNNDVWebView.backgroundColor = [UIColor redColor];
    // 设置视图约束,布局视图.
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    // !!!: 临时测试.
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[view]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(view)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[webView(==300)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(webView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-(64)-[webView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(view, webView)]];
    [self addConstraints: constraintsArray];
    
    // 初始化视图内容.
    [self reloadData];
}
@end
