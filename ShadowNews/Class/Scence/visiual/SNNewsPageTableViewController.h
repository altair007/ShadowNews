//
//  SNNewsPageTableViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNewsPageTableViewController : UITableViewController
@property (copy, nonatomic) NSString * topic;
@property (retain, nonatomic) NSArray * newsArray;
@end
