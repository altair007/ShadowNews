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
@property (retain, nonatomic) SNNewsPageView * SNNDCell; //!< 新闻视图单元格.
@property (retain, nonatomic) SNNewsModel * SNNDModel; //!< 新闻视图数据模型.
@property (retain, nonatomic) NSArray * SNNDNewsArray; //!< 存储新闻的数组.
@end
@implementation SNNewsDelegate
+ (instancetype) delegateWithCell: (SNNewsPageView *) cell
                            model: (SNNewsModel *) model;
{
    SNNewsDelegate * delegate = [[[self class] alloc] initWithCell: cell model:model];
    SNAutorelease(delegate);
    return delegate;
}

- (void)dealloc
{
    self.SNNDCell = nil;
    self.SNNDModel = nil;
    
    [self removeObserver: self forKeyPath:@"SNNDNewsArray" context: NULL];
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype) initWithCell: (SNNewsPageView *) cell
                        model: (SNNewsModel *) model;
{
    if (self = [super init]) {
        self.SNNDCell = cell;
        
        [self addObserver: self forKeyPath:@"SNNDNewsArray" options:0 context:NULL];
        
        // ???:应该根据是否是"预加载",采用不同的获取数据的策略.
        [SNNewsModel newsForTitle: self.SNNDCell.title range: NSMakeRange(0, 20) success:^(NSArray *newsArray) {
            self.SNNDCell.delegate = self;
            self.SNNDCell.dataSource = self;
            self.SNNDNewsArray = newsArray;
        } fail:^(NSError *error) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"网络故障,暂无法连接到互联网!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            SNRelease(alertView);
        }];
        
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // ???:会闪屏!意思是,需要保留预加载的那个视图吗?(建议让控制器去做这件事.)
    
    [self.SNNDCell reloadData];
}

// ???:在tableView显示之后,只改变代理,不调用reloadData方法,会自动刷新页面吗?

#pragma mark - UITableViewDelegate协议方法.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
// !!!: 有一个BUG:点返回时,可能崩掉.先左移几次!可能和代理的不正确retai,有关.
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
    // ???:尝试使用另外一种可以绑定类和cell标志名的语法初始化
    
    // ???:建议使用自定义cell.
    SNNewsPageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"news"];
    if (nil == cell) {
            cell = [[SNNewsPageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"news"];
    }
    
    
    cell.news = news;

    return cell;
}
@end
