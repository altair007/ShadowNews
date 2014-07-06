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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // !!!:或许需要将新闻作为默认的rootViewController.
        // !!!:优化方向:此处应该在用户退出时记录上次访问的页面或栏目,并在应用初始化时继续翻到上次浏览的页面或栏目.
        SNNewsViewController * newsVC = [[SNNewsViewController alloc] init];
        [self pushViewController: newsVC animated:YES];
    }
    return self;
}

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
