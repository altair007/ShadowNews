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
        
        self.bounces = NO;
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    if (nil != self.superview) { // 说明可能是在从父视图移除.
        return;
    }
    
    self.separatorColor = [UIColor lightGrayColor];
}
@end
