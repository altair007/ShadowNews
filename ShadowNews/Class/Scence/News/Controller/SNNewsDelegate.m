//
//  SNNewsDelegate.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDelegate.h"
#import "SNNewsPageView.h"
#import "SNNewsModel.h"
#import "SNNews.h"
#import "SNNewsPageViewCell.h"
#import "SNNavigationController.h"
#import "SNNewsDetailViewController.h"
#import "SNNewsPageViewImageCell.h"

@interface SNNewsDelegate ()
@property (retain, nonatomic) SNNewsPageView * SNNDPageView; //!< 新闻视图页面.
@property (retain, nonatomic) SNNewsModel * SNNDModel; //!< 新闻视图数据模型.
@property (retain, nonatomic) NSArray * SNNDNewsArray; //!< 存储新闻的数组.
@end
@implementation SNNewsDelegate
+ (instancetype) delegateWithCell: (SNNewsPageView *) cell
{
    SNNewsDelegate * delegate = [[[self class] alloc] initWithPageView: cell];
    SNAutorelease(delegate);
    return delegate;
}

- (void)dealloc
{
    
    [self removeObserver: self forKeyPath:@"SNNDNewsArray" context: NULL];
    [self.SNNDPageView removeObserver: self forKeyPath:@"preLoad" context: NULL];
    
    self.SNNDPageView = nil;
    self.SNNDModel = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype) initWithPageView: (SNNewsPageView *) pageView;
{
    if (self = [super init]) {
        self.SNNDPageView = pageView;
        [pageView registerClass:[SNNewsPageViewCell class] forCellReuseIdentifier:@"SNNewsPageViewCell"];
        [pageView registerClass:[SNNewsPageViewImageCell class] forCellReuseIdentifier: @"SNNewsPageViewImageCell"];
        
        // ???:真的有必要检测自身的SNNDNewsArray属性?
        [self addObserver: self forKeyPath:@"SNNDNewsArray" options:0 context:NULL];
        
        // !!!: 应该设置用户用户刷新的时间,比如五分钟内同一页面只允许刷新一次等.
        /* 当视图由预加载状态变为加载状态时,可能需要额外请求数据. */
        [self.SNNDPageView addObserver:self forKeyPath:@"preLoad" options:NSKeyValueObservingOptionNew context:NULL];
//        self.SNNDPage.delegate = self;
//        self.SNNDPage.dataSource = self;
        // !!!: 无论是什么请求有,都先用本地数据获取数据,进行初始化.
        // !!!: 可能有一个潜在的BUG,本地数据不存在,第一次使用,可能会崩溃.
        // !!!: 具体方案是:是"预加载" 则不执行下一步: 异步联网请求.
        // ???:应该根据是否是"预加载",采用不同的获取数据的策略.
        [SNNewsModel newsForTitle: self.SNNDPageView.title range: NSMakeRange(0, 20) success:^(NSArray *newsArray) {
            self.SNNDNewsArray = newsArray;
        } fail:^(NSError *error) {
            if (YES != self.SNNDPageView.preLoad) {
                // ???:优化方向:网易的"弹窗"会自动消失哦!
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"网络故障,暂无法连接到互联网!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                SNRelease(alertView);
            }
        }];
        
    }
    
    return self;
}


// ???:簇语法,是怎么做到的?超类,怎么可以创建并返回子类对象?这个思路,将有利于实现,cell的自定义与使用.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // !!!: 备用!实现数据库相关操作.
    if (self.SNNDPageView == object &&
        [keyPath isEqualToString: @"preLoad"]) {
        
    }
    
    // ???:总感觉,这个对代理自身的观察者,有些鸡肋.
    [self.SNNDPageView reloadData];
}

#pragma mark - UITableViewDelegate协议方法.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        SNNews * news = [self.SNNDNewsArray objectAtIndex: indexPath.row];
        if (nil != news.imgSrc) {
            return 140;
        }
    }
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * docId = [(SNNews *)self.SNNDNewsArray[indexPath.row] docId];
    SNNewsDetailViewController * detailVC = [[SNNewsDetailViewController alloc] initWIthDocId:docId];
    [[SNNavigationController sharedInstance] pushViewController:detailVC animated: YES];
}

#pragma mark - UITableViewDataSource协议方法.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.SNNDNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNNews * news = [self.SNNDNewsArray objectAtIndex: indexPath.row];
    
    // 如果第一条新闻有图片,则用大图风格单元格,单独显示.
    if (0 == indexPath.row && nil != news.imgSrc) {
        SNNewsPageViewImageCell * cell = [tableView dequeueReusableCellWithIdentifier: @"SNNewsPageViewImageCell" forIndexPath: indexPath];
        cell.news = news;
        return cell;
    }

    // !!!:优化方向:区分图片新闻与普通新闻cell.
    SNNewsPageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SNNewsPageViewCell" forIndexPath: indexPath];
    
    cell.news = news;

    // !!!: 迭代至此:  还剩首页网络图集.
    
    return cell;
}
@end
