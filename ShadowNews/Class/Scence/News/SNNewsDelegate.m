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

@interface SNNewsDelegate ()
@property (retain, nonatomic) SNNewsPageView * SNNDPage; //!< 新闻视图页面.
@property (retain, nonatomic) SNNewsModel * SNNDModel; //!< 新闻视图数据模型.
@property (retain, nonatomic) NSArray * SNNDNewsArray; //!< 存储新闻的数组.
@end
@implementation SNNewsDelegate
+ (instancetype) delegateWithCell: (SNNewsPageView *) cell
{
    SNNewsDelegate * delegate = [[[self class] alloc] initWithCell: cell];
    SNAutorelease(delegate);
    return delegate;
}

- (void)dealloc
{
    self.SNNDPage = nil;
    self.SNNDModel = nil;
    
    [self removeObserver: self forKeyPath:@"SNNDNewsArray" context: NULL];
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype) initWithCell: (SNNewsPageView *) cell;
{
    if (self = [super init]) {
        self.SNNDPage = cell;
        [cell registerClass:[SNNewsPageViewCell class] forCellReuseIdentifier:@"SNNewsPageViewCell"];
        
        [self addObserver: self forKeyPath:@"SNNDNewsArray" options:0 context:NULL];
        
        // ???:应该根据是否是"预加载",采用不同的获取数据的策略.
        [SNNewsModel newsForTitle: self.SNNDPage.title range: NSMakeRange(0, 20) success:^(NSArray *newsArray) {
            self.SNNDPage.delegate = self;
            self.SNNDPage.dataSource = self;
            self.SNNDNewsArray = newsArray;
        } fail:^(NSError *error) {
            if (YES != self.SNNDPage.preLoad) {
                // ???:优化方向:网易的"弹窗"会自动消失哦!
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"网络故障,暂无法连接到互联网!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                SNRelease(alertView);
            }
        }];
        
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.SNNDPage reloadData];
}

#pragma mark - UITableViewDelegate协议方法.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    // !!!:优化方向:区分图片新闻与普通新闻cell.
    SNNewsPageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SNNewsPageViewCell" forIndexPath: indexPath];
    
    cell.news = news;

    return cell;
}
@end
