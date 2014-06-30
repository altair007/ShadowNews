//
//  SNMainController.m
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNMainController.h"

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

@end
