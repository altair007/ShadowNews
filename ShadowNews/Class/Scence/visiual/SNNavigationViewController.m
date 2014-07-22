//
//  SNNavigationViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-21.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNavigationViewController.h"
#import "SNNavigationTableViewCell.h"
#import "SNNewsViewController.h"
#import "SNNavigationTableViewCell.h"

@interface SNNavigationViewController ()

@end

@implementation SNNavigationViewController

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SNNewsViewController * pageVC = segue.destinationViewController;
    SNNavigationTableViewCell * cell = sender;
    pageVC.category = cell.topicTitleLabel.text;
}


#pragma mark - UITableViewDelegate协议方法.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  SCREEN_HEIGHT / (self.model.navItemTitles.count + 1);
    return height;
}

#pragma mark - UITableViewDataSource协议方法.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.navItemTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNNavigationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"SNNavigationTableViewCell" forIndexPath: indexPath];
    cell.topicTitleLabel.text = self.model.navItemTitles[indexPath.row];
    cell.topicImgView.image = [UIImage imageNamed:self.model.navItemImgs[indexPath.row]];
    
    return cell;
}

@end
