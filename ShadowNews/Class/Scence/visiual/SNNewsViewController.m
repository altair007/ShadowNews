//
//  SNNewsViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsViewController.h"
#import "SNNewsPageViewController.h"
#import "SNNewsPageModel.h"

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
    NSString * topic = [self currentTopic];
    SNNewsPageViewController * pageVC = segue.destinationViewController;
    pageVC.topic = topic;
    pageVC.model = [[[SNNewsPageModel alloc] init] autorelease];
    self.embedVC = pageVC;
}

- (void)dealloc {
    [_embedVC release];
    
    [_navSC release];
    [super dealloc];
}

- (IBAction)handleSegmentedControlValueChangedAction:(UISegmentedControl *)sender {
    if (YES == [self.embedVC isKindOfClass: [SNNewsPageViewController class]]) {
        SNNewsPageViewController * pageVC = (SNNewsPageViewController *)self.embedVC;
        pageVC.topic = [self currentTopic];
        [pageVC reloadData];
    }
}

- (NSString *) currentTopic
{
    return [self.navSC titleForSegmentAtIndex: self.navSC.selectedSegmentIndex];
}

@end
