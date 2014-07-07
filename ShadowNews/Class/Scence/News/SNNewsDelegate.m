//
//  SNNewsDelegate.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "UIKit+AFNetworking.h"
#import "SNNewsDelegate.h"
#import "SNNewsPageView.h"
#import "SNNewsModel.h"
#import "SNNews.h"
#import "SNNewsPageViewCell.h"

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
    
    // ???:真的能被移除吗?
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
        
        // ???: 观察自身属性,会不会造成循环引用问题?
        [self addObserver: self forKeyPath:@"SNNDNewsArray" options:0 context:NULL];
        
        // ???:应该根据是否是"预加载",采用不同的获取数据的策略.
        [SNNewsModel newsForTitle: self.SNNDCell.title range: NSMakeRange(0, 20) success:^(NSArray *newsArray) {
            self.SNNDCell.delegate = self;
            self.SNNDCell.dataSource = self;
            self.SNNDNewsArray = newsArray;
        } fail:^(NSError *error) {
            // ???:如果是网络原因,应该提示用户网络未连接.
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

#pragma mark - UITableViewDataSource协议方法.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // ???:不应该用固定值.
    return self.SNNDNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNNews * news = [self.SNNDNewsArray objectAtIndex: indexPath.row];
    // !!!:暂不区分图片新闻与普通新闻cell.
    // ???:尝试使用另外一种可以绑定类和cell标志名的语法初始化
    
    // ???:暂时不使用自定义cell.
    // !!!:迭代至此,先重新规划新闻的属性.
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"news"];
    [cell.imageView setImageWithURL:[NSURL URLWithString: news.imgSrc]];
    cell.textLabel.text = news.title;
    cell.detailTextLabel.text = @"啊哈adsfsfsdsdgsgksjglas撒的结构i啊哈adsfsfsdsdgsgksjglas撒的结构i";
    
    return cell;
}
@end
