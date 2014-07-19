//
//  SNNewsPageViewCell.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNewsPageViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *relatedImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *digestLabel;
@property (retain, nonatomic) IBOutlet UILabel *replyLabel;

@property (copy, nonatomic) NSString * docId; //!< 唯一新闻标识符.
@end
