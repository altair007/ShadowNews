//
//  SNNewsViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsViewController.h"
#import "SNNewsPageTableViewController.h"

@interface SNNewsViewController ()

@end

@implementation SNNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString * topic = [self.navSC titleForSegmentAtIndex: self.navSC.selectedSegmentIndex];
    SNNewsPageTableViewController * pageVC = segue.destinationViewController;
    pageVC.topic = topic;
    pageVC.newsArray = @[@"新闻1", @"新闻2", @"新闻3", @"新闻四"];
}


- (void)dealloc {
    [_navSC release];
    [super dealloc];
}
- (IBAction)handleSegmentedControlValueChangedAction:(UISegmentedControl *)sender {
    
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message: [NSString stringWithFormat: @"您点击了第 %@ 个按钮!", [NSNumber numberWithUnsignedInteger: sender.selectedSegmentIndex]] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
    [alertView show];
}
@end
