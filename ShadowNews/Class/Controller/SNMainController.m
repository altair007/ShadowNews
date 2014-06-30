//
//  SNMainController.m
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNMainController.h"

@interface SNMainController ()
@property (retain, nonatomic, readwrite) SNShadowNewsModel * model; //!< 数据模型.
@property (retain, nonatomic, readwrite) SNNavigationController * navigationController; //!< 页面主导航栏
@end
@implementation SNMainController
#pragma mark - 实现单例
static SNMainController * sharedObj = nil;
+ (instancetype) sharedInstance
{
    if (nil == sharedObj) {
        sharedObj = [[self alloc] init];
    }
    
    return sharedObj;
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
    if (nil == sharedObj) {
        sharedObj = [super allocWithZone:zone];
        return sharedObj;
    }
    
    return nil;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    return  self;
}

#if ! __has_feature(objc_arc)
- (instancetype)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
    return;
}

- (instancetype) autorelease
{
    return self;
}
#endif


#pragma mark - 实例方法
-(void)dealloc
{
    self.model = nil;
    self.navigationController = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype) init
{
    if (self = [super init]) {
    }
    
    return self;
}
@end
