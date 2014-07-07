//
//  SNNewsDelegate.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDelegate.h"
#import "SNNewsViewCell.h"

@interface SNNewsDelegate ()
@property (retain, nonatomic, readwrite) SNNewsViewCell * cell; //!< 新闻视图单元格.
@end
@implementation SNNewsDelegate
+ (instancetype) delegateWithCell: (SNNewsViewCell *) cell
{
    SNNewsDelegate * delegate = [[[self class] alloc] initWithCell: cell];
    SNAutorelease(delegate);
    return delegate;
}

- (void)dealloc
{
    self.cell = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype) initWithCell: (SNNewsViewCell *) cell
{
    if (self = [super init]) {
        self.cell = cell;
        
        // ???:应该在获取到数据之后,再设置代理.
        // ???:应该根据是否是"预加载",采用不同的获取数据的策略.
        // ???:初始化方法,少了个参数:preLoad.或者为单元格视图建一个属性:预加载.
        // ???:迭代至此!
        // ???:好像应该传一个MODEL进来.
        
        cell.dataSource = self;
        cell.delegate = self;
    }
    
    return self;
}

// ???:应该在请求过数据之后再设置代理,并reloadData?
// ???:在tableView显示之后,只改变代理,不调用reloadData方法,会自动刷新页面吗?

#pragma mark - UITableViewDelegate协议方法.

#pragma mark - UITableViewDataSource协议方法.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: self.cell.title];
    cell.textLabel.text = self.cell.title;
    return cell;
}
@end
