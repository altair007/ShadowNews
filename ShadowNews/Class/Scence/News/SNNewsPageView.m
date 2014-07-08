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
@end
