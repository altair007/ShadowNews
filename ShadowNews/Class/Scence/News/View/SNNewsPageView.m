//
//  SNNewsPageView.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

//#import "MJRefresh.h"
#import "SNNewsPageView.h"

@interface SNNewsPageView ()
@property (copy, nonatomic, readwrite) NSString * title;
@end

@implementation SNNewsPageView
+ (instancetype)pageWithTitle: (NSString *) title
                      preLoad: (BOOL) preLoad
{
    SNNewsPageView * cell = [[[self class] alloc] initWithTitle: title preLoad:preLoad];
    SNAutorelease(cell);
    return cell;
}

-(void)dealloc
{
    self.title = nil;

//    self.footerRefreshView = nil;
//    self.headerRefreshView = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)initWithTitle: (NSString *) title
                      preLoad: (BOOL) preLoad
{
    if (self = [super init]) {
        self.title = title;
        self.preLoad = preLoad;
        
        // !!!:临时关闭回弹效果.因为不需要支持下拉刷新等操作.
        self.bounces = NO;
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    if (nil != self.superview) { // 说明可能是在从父视图移除.
        return;
    }
    
    // !!!: 应该把这些逻辑放到初始化或者一个单独的方法里吧?
    // !!!: 根据模式,动态判断.
    self.separatorColor = [UIColor lightGrayColor];

    
//    self.backgroundColor = self.superview.backgroundColor;
    
    // !!!: 暂时屏蔽:上拉加载,下拉刷新.
//    /* 支持上拉加载,下拉刷新. */
//    // !!!:待优化的地方.
//    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    
//    // ???:30,好像不美观.
//    self.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)] autorelease];
////    self.headerView = [[[SNHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 140)] autorelease];
////    [self.tableHeaderView addSubview:self.headerView];
//    self.footerRefreshView = [MJRefreshFooterView footer];
//    self.footerRefreshView.scrollView = self;
//    self.headerRefreshView = [MJRefreshHeaderView header];
//    self.headerRefreshView.scrollView = self;
    
}
@end
