//
//  SNNewsPageViewController.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "UIKit+AFNetworking.h"
#import "SNNewsPageViewController.h"
#import "SNNewsPageViewCell.h"
#import "SNNewsDetailViewController.h"
#import "SNNewsDetailModel.h"

@interface SNNewsPageViewController ()

@end

@implementation SNNewsPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setUpData];
    [self reloadData];
}

- (void) setUpData
{
    /* 从数据库中获取数据进行初始化. */
    self.newsArray = @[@{@"title": [NSString stringWithFormat:@"%@ 板块,数据库中缓存的内容", self.topic]}];
    [self.tableView reloadData];
}

- (void) reloadData
{
    [self.model newsForTopic: self.topic range: NSMakeRange(0, 20) success:^(id responseObject) {
        self.newsArray = responseObject;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (YES == [self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (0 == self.newsArray.count) { //  考虑新闻数组还没被初始化的情况.
        return 0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 == section) { // 容错处理.也方便后期功能扩展.
        return self.newsArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNNewsPageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SNNewsPageViewCell class]) forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary * news = [self.newsArray objectAtIndex: indexPath.row];

    NSString * imgsrc = [news objectForKey: @"imgsrc"];
    [cell.relatedImageView setImageWithURL: [NSURL URLWithString: imgsrc]];
    cell.titleLabel.text = [news objectForKey: @"title"];
    cell.digestLabel.text = [news objectForKey: @"digest"];
    cell.replyLabel.text =  [NSString stringWithFormat:@"%@ 跟帖数", [news objectForKey: @"replyCount"]];
    cell.docId = [news objectForKey: @"docid"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (YES == [segue.identifier isEqualToString: @"newsDigestToNewsDetailSegue"]) {
        SNNewsDetailViewController * detailVC = segue.destinationViewController;
        detailVC.docId = [(SNNewsPageViewCell *)sender docId];
        SNNewsDetailModel * model = [[SNNewsDetailModel alloc] init];
        detailVC.model = model;
        [model release];
    }
}

- (void)dealloc {
    [_newsArray release];
    [_topic release];
    [_model release];
    
    [super dealloc];
}
@end
