//
//  SNNewsViewCell.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsViewCell.h"

@interface SNNewsViewCell ()
@property (copy, nonatomic, readwrite) NSString * title; //!< 新闻板块名称.
@end

@implementation SNNewsViewCell
+ (instancetype)cellWithTitle: (NSString *) title
{
    SNNewsViewCell * cell = [[[self class] alloc] initWithTitle: title];
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
{
    if (self = [super init]) {
        self.title = title;
    }
    
    return self;
}
@end
