//
//  SNNewsPageViewImageCell.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-10.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsPageViewImageCell.h"
#import "SNNews.h"
#import "UIKit+AFNetworking.h"

@interface SNNewsPageViewImageCell ()
@property (retain, nonatomic) UIImageView * SNNNPICImageView; //!< 图片视图.
@property (retain, nonatomic) UILabel * SNNPVICTitleLabel; //!< 标题文本框.
@end

@implementation SNNewsPageViewImageCell
- (void)dealloc
{
    self.SNNNPICImageView = nil;
    self.SNNPVICTitleLabel = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self SNNPVCSetUpSubviews];
    }
    return self;
}

- (void)setNews:(SNNews *)news
{
    [news retain];
    [_news release];
    _news = news;
    
    [self.SNNNPICImageView setImageWithURL:[NSURL URLWithString: self.news.imgs[0]] placeholderImage:[UIImage imageNamed:@"default.png"] ];
    
    // !!!: 用来实现文本不贴着边缘!好鸡肋,换个实现方式吧!
    self.SNNPVICTitleLabel.text = [NSString stringWithFormat: @"      %@", news.title];
}

/**
 *  初始化设置子视图.
 */
- (void)SNNPVCSetUpSubviews
{
    UIImageView * imageView = [[UIImageView alloc] init];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.alpha = 0.6;
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    self.SNNNPICImageView= imageView;
    self.SNNPVICTitleLabel = titleLabel;
    
    SNRelease(imageView);
    SNRelease(titleLabel);
    
    [self.contentView addSubview: self.SNNNPICImageView];
    [self.SNNNPICImageView addSubview: self.SNNPVICTitleLabel];
    
    // 设置约束.
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    /* 横向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    /* 竖向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(==20)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [self addConstraints: constraints];
}

@end
