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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        SNNewsViewController * newsVC = [[SNNewsViewController alloc] init];
        [self pushViewController: newsVC animated:YES];
        
        self.navigationBarHidden = YES;
    }
    return self;
}

// !!!:一个建议: 导航栏控制器根据当前正在显示的控制器,自动更新导航栏内容.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
