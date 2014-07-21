//
//  SNNewsDetailViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailViewController.h"

@interface SNNewsDetailViewController ()

@end

@implementation SNNewsDetailViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.model detailModelWithDocId: self.docId success:^(id responseObject) {
        [self.webView loadHTMLString: responseObject baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    } fail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    self.view.window.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end
