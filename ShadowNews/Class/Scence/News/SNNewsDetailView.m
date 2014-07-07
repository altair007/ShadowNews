//
//  SNNewsDetailView.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailView.h"
#import "SNNewsDetail.h"

@interface SNNewsDetailView ()
@property (retain, nonatomic) SNNewsDetail * SNNDDetail; //!< 新闻详情.
@property (retain, nonatomic) UIWebView * SNNDWebView; //!< 用于显示新闻主体信息.
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

// ???: moveToSuperView,是不是更合适?
- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (nil == self.window) {
        [self SNNDSetUpSubviews];
    }
}

- (void)reloadData
{
    // 重置和数据相关的属性.
    self.SNNDDetail = nil;
    
    [self.SNNDWebView loadHTMLString: self.SNNDDetail.body baseURL:nil];
}

- (SNNewsDetail *)SNNDDetail
{
    if (nil == _SNNDDetail) {
        self.SNNDDetail = [self.dataSource detailInNewsDetailView: self];
    }
    
    return _SNNDDetail;
}

/**
 *  设置子视图.
 */
- (void) SNNDSetUpSubviews
{
    // ???:ipad的导航栏,也是(44+20)?
    // ???:暂只进行数据展示.
    UIWebView * webView = [[UIWebView alloc] init];
    [webView setTranslatesAutoresizingMaskIntoConstraints: NO];
    self.SNNDWebView = webView;
    SNRelease(webView);
    [self addSubview: self.SNNDWebView];
    
    // 设置视图约束,布局视图.
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[webView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(webView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[webView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(webView)]];
    [self addConstraints: constraintsArray];
    
    // 初始化视图内容.
    [self reloadData];
}
@end
