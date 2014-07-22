//
//  SNNavigationTableViewCell.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-21.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNavigationTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *topicImgView; //!< 新闻板块图标.
@property (retain, nonatomic) IBOutlet UILabel *topicTitleLabel; //!< 新闻板块名称.

@end
