//
//  SNNewsPageViewPhotosetCell.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-11.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "UIKit+AFNetworking.h"
#import "SNNewsPageViewPhotosetCell.h"
#import "SNNews.h"

@interface SNNewsPageViewPhotosetCell ()
@property (retain, nonatomic) UILabel * SNNPVPCTitleLabel; //!< 展示新闻标题的标签.
@property (retain, nonatomic) UILabel * SNNPVPCReplyCountLable; //!< 展示跟帖数的标签.
@property (retain, nonatomic) UIImageView * SNNPVPCImageViewLeft; //!< 左侧图片视图.
@property (retain, nonatomic) UIImageView * SNNPVPCImageViewMiddle; //!< 中间图片视图.
@property (retain, nonatomic) UIImageView * SNNPVPCImageViewRight; //!< 右侧图片视图.
@end

@implementation SNNewsPageViewPhotosetCell
- (void)dealloc
{
    self.SNNPVPCTitleLabel = nil;
    self.SNNPVPCReplyCountLable = nil;
    self.SNNPVPCImageViewLeft = nil;
    self.SNNPVPCImageViewMiddle = nil;
    self.SNNPVPCImageViewRight = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setNews:(SNNews *)news
{
    [news retain];
    [_news release];
    _news = news;
    
    // !!!:在设置器中,设置值并不总是合适.期待代理传值.
    self.SNNPVPCTitleLabel.text  = news.title;
    self.SNNPVPCReplyCountLable.text = [NSString stringWithFormat: @"%@跟帖",[NSNumber numberWithUnsignedInteger: news.replyCount]];
    [self.SNNPVPCImageViewLeft setImageWithURL:[NSURL URLWithString: self.news.imgs[0]] placeholderImage:[UIImage imageNamed:@"default.png"]];
    [self.SNNPVPCImageViewMiddle setImageWithURL:[NSURL URLWithString: self.news.imgs[1]] placeholderImage:[UIImage imageNamed:@"default.png"]];
    [self.SNNPVPCImageViewRight setImageWithURL:[NSURL URLWithString: self.news.imgs[2]] placeholderImage:[UIImage imageNamed:@"default.png"]];
}

/**
 *  初始化设置子视图.
 */
- (void)SNNPVCSetUpSubviews
{
    // TODO: 迭代至此:初始化子视图.
//    UIImageView * imageView = [[UIImageView alloc] init];
//    
//    UILabel * titleLabel = [[UILabel alloc] init];
//    titleLabel.font = [UIFont boldSystemFontOfSize: 12.0];
//    titleLabel.backgroundColor = [UIColor whiteColor];
//    titleLabel.alpha = 0.6;
//    
//    [imageView setTranslatesAutoresizingMaskIntoConstraints: NO];
//    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
//    
//    self.SNNNPICImageView= imageView;
//    self.SNNPVICTitleLabel = titleLabel;
//    
//    SNRelease(imageView);
//    SNRelease(titleLabel);
//    
//    [self.contentView addSubview: self.SNNNPICImageView];
//    [self.SNNNPICImageView addSubview: self.SNNPVICTitleLabel];
//    
//    // 设置约束.
//    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
//    
//    /* 横向约束. */
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
//    
//    /* 竖向约束. */
//    // !!!: 小写的V也会有效吗?
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(==20)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
//    
//    [self addConstraints: constraints];
}

@end
