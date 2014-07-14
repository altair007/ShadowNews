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
#import "SNNewsPageViewBigImageCell.h"
#import "SNNewsPageViewPhotosetCell.h"
#import "SNNewsPageViewTextCell.h"

@interface SNNewsDelegate ()
@property (retain, nonatomic) SNNewsPageView * SNNDPageView; //!< 新闻视图页面.
@property (retain, nonatomic) SNNewsModel * SNNDModel; //!< 新闻视图数据模型.
@property (retain, nonatomic) NSArray * SNNDNewsArray; //!< 存储新闻的数组.
@end
@implementation SNNewsDelegate
+ (instancetype) delegateWithPageView: (SNNewsPageView *) pageView
{
    SNNewsDelegate * delegate = [[[self class] alloc] initWithPageView: pageView];
    SNAutorelease(delegate);
    return delegate;
}

- (void)dealloc
{
    
    [self removeObserver: self forKeyPath:@"SNNDNewsArray" context: NULL];
    
    // ???: 真的有必要监测?
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
        [pageView registerClass:[SNNewsPageViewBigImageCell class] forCellReuseIdentifier: @"SNNewsPageViewBigImageCell"];
        [pageView registerClass: [SNNewsPageViewPhotosetCell class] forCellReuseIdentifier: @"SNNewsPageViewPhotosetCell"];
        [pageView registerClass: [SNNewsPageViewTextCell class] forCellReuseIdentifier: @"SNNewsPageViewTextCell"];
        
        // ???:真的有必要检测自身的SNNDNewsArray属性?
        [self addObserver: self forKeyPath:@"SNNDNewsArray" options:0 context:NULL];
        
        // !!!: 应该设置用户用户刷新的时间,比如五分钟内同一页面只允许刷新一次等.
        /* 当视图由预加载状态变为加载状态时,可能需要额外请求数据. */
        [self.SNNDPageView addObserver:self forKeyPath:@"preLoad" options:NSKeyValueObservingOptionNew context:NULL];
        // !!!: 无论是什么请求有,都先用本地数据获取数据,进行初始化.
        // !!!: 可能有一个潜在的BUG,本地数据不存在,第一次使用,可能会崩溃.
        // !!!: 具体方案是:是"预加载" 则不执行下一步: 异步联网请求.
        // ???:应该根据是否是"预加载",采用不同的获取数据的策略.
        if (YES != self.SNNDPageView.preLoad) {
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
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.SNNDPageView == object &&
        [keyPath isEqualToString: @"preLoad"]) {
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
        return;
    }
    
    // ???:总感觉,这个对代理自身的观察者,有些鸡肋.
    [self.SNNDPageView reloadData];
}

- (NSArray *)SNNDNewsArray
{
    if (nil == _SNNDNewsArray) { // 从数据库获取最新数据.
        // ???:暂时不考虑,上拉加载,下拉刷新的情况.
        // !!!:一个思路:给代理添加一个值,用它来确定请求多少条数据.暂时只获取20条,且数据库中数据暂时不清空.或者此处持有SNNewsArray.其他处可以修改它的值,检测某个量.
        // !!!: 一个建议: 数据库中只保留 20 条数据.
        // !!!: 一个简单的策略: 每次都从数据库中完全读取数据,让它们去关心数据库容量和优化的问题吧.(不过,逻辑上有些混乱.).
       self.SNNDNewsArray = [SNNewsModel localNewsForTitle: self.SNNDPageView.title];
    }
    
    return _SNNDNewsArray;
}
#pragma mark - UITableViewDelegate协议方法.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNNews * news = [self.SNNDNewsArray objectAtIndex: indexPath.row];
    
    if (0 == indexPath.row) {
        if (nil != news.imgs) {
            return 156;
        }
    }
    
    if (3 == news.imgs.count) { // 图集,高度适当变高.
        return 78+20;
    }
    
    return 78;
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
    // !!!: 视图封装的很失败!其实只需要代理返回一个"新闻对象"就可以了.即使是代理,也应该最小化暴漏信息.
 
    // !!!: 优化一下.逻辑组合.本质上只是cell的"标识符"不同而已.
    SNNews * news = [self.SNNDNewsArray objectAtIndex: indexPath.row];
    
    // 如果第一条新闻有图片,则用大图风格单元格,单独显示.
    if (0 == indexPath.row && nil != news.imgs) {
        SNNewsPageViewBigImageCell * cell = [tableView dequeueReusableCellWithIdentifier: @"SNNewsPageViewBigImageCell" forIndexPath: indexPath];
        cell.news = news;
        return cell;
    }

    // 如果是图片集,且照片数为3,单独处理.
    if (3 == news.imgs.count) {
        SNNewsPageViewPhotosetCell * cell = [tableView dequeueReusableCellWithIdentifier: @"SNNewsPageViewPhotosetCell" forIndexPath: indexPath];
        cell.news = news;
        return cell;
    }
    
    if (0 == news.imgs.count) { // 纯文本新闻.
        // !!!: 封装时,可以借助此方法NSStringFromClass,让cell自己产生"标识符".
        SNNewsPageViewTextCell * cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([SNNewsPageViewTextCell class]) forIndexPath: indexPath];
        cell.news = news;
        return cell;
    }
    
    
    SNNewsPageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SNNewsPageViewCell" forIndexPath: indexPath];
    
    cell.news = news;
    
    return cell;
}


@end
