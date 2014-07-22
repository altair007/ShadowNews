//
//  SNNavigationViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-21.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNavigationModelDelegate.h"

@interface SNNavigationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) id<SNNavigationModelDelegate> model;

@end
