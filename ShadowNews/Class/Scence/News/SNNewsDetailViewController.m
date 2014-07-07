//
//  SNNewsDetailViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetailViewController.h"
#import "SNNewsDetailView.h"
#import "SNNewsModel.h"
#import "SNNewsDetail.h"

@interface SNNewsDetailViewController ()
@property (retain, nonatomic) SNNewsDetail * SNNDDVCDetail; //!< 新闻详情.
@end

@implementation SNNewsDetailViewController
- (instancetype) initWIthDocId: (NSString *) docId
{
    if (self = [super init]) {
        self.docId = docId;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    SNNewsDetailView * view = [[SNNewsDetailView alloc] init];
    self.view = view;
    SNRelease(view);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SNNewsModel detailModelWithDocId:self.docId success:^(id responseObject) {
        self.SNNDDVCDetail = responseObject;
        self.view.delegate = self;
        self.view.dataSource = self;
        [self.view reloadData];
    } fail:^(NSError *error) {
        //!!!:此处可以弹窗提示网络故障.
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
}

#pragma mark - 协议方法.
- (SNNewsDetail *)detailInNewsDetailView:(SNNewsDetailView *)newsDetailView
{
    return self.SNNDDVCDetail;
}

@end
