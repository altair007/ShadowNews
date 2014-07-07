//
//  SNNewsPageView.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsPageView.h"

@interface SNNewsPageView ()
@property (copy, nonatomic, readwrite) NSString * title; //!< 新闻板块名称.
@property (assign, nonatomic, readwrite) BOOL preLoad; //!< 是否是预加载.出于用户体验的考虑,新闻视图可能会预加载某些页面.对于预加载的页面,往往可以暂不发起网络请求,获取最新数据.
@end

@implementation SNNewsPageView
+ (instancetype)cellWithTitle: (NSString *) title
                      preLoad: (BOOL) preLoad
{
    SNNewsPageView * cell = [[[self class] alloc] initWithTitle: title preLoad:preLoad];
    SNAutorelease(cell);
    return cell;
}

-(void)dealloc
{
    self.title = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

// ???:观察下,表视图,触发代理的时机是 moveToWindow,还是movweToSuperView?
// ???:中间的轮转页面,是不是在 moveToSuperView时,触发代理,更合适呢?
- (instancetype)initWithTitle: (NSString *) title
                      preLoad: (BOOL) preLoad
{
    if (self = [super init]) {
        self.title = title;
        self.preLoad = preLoad;
    }
    
    return self;
}
@end
