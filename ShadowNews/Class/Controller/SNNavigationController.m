//
//  SNNavigationController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNavigationController.h"
#import "SNNewsViewController.h"

@interface SNNavigationController ()

@end

@implementation SNNavigationController
static SNNavigationController * sharedObj = nil; //!< 单例对象.

+ (SNNavigationController *)sharedInstance
{
    if (nil == sharedObj) {
        sharedObj = [[self alloc] init];
    }
    
    return sharedObj;
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
    if (nil == sharedObj) {
        sharedObj = [super allocWithZone: zone];
    }
    
    return sharedObj;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    return self;
}

#if ! __has_feature(objc_arc)
- (NSUInteger)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    
}

- (instancetype)autorelease
{
    return self;
}
#endif


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
