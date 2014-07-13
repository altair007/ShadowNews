//
//  SNNewsPageView.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

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
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    // !!!: 应该把这些逻辑放到初始化或者一个单独的方法里吧?
    // !!!: 根据模式,动态判断.
    self.separatorColor = [UIColor blackColor];
    self.backgroundColor = self.superview.backgroundColor;
}
@end
