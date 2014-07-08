//
//  SNNewsPageViewCell.m
//  ShadowNews
//
//  Created by lanou3g on 14-6-28.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "UIKit+AFNetworking.h"
#import "SNNewsPageViewCell.h"
#import "SNNews.h"

@interface SNNewsPageViewCell ()
@property (retain, nonatomic) UIImageView * SNNPVCImageView; //!< 图片视图.
@property (retain, nonatomic) UILabel * SNNPVCTitleLabel; //!< 新闻主题.
@property (retain, nonatomic) UILabel * SNNPVCDigestLabel; //!< 新闻摘要.
@property (retain, nonatomic) UILabel * SNNPVCReplyCoutLabel; //!< 回帖数.
@end

@implementation SNNewsPageViewCell
- (void)dealloc
{
    self.SNNPVCImageView = nil;
    self.SNNPVCTitleLabel = nil;
    self.SNNPVCDigestLabel = nil;
    self.SNNPVCReplyCoutLabel = nil;
    
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

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)setNews:(SNNews *)news
{
    [news retain];
    [_news release];
    _news = news;
    
    [self.SNNPVCImageView setImageWithURL:[NSURL URLWithString: self.news.imgSrc] placeholderImage:[UIImage imageNamed:@"default.png"] ];
    self.SNNPVCTitleLabel.text = news.title;

    // !!!:自动截断 digest,它可能过长,盖住"跟帖数."
    self.SNNPVCDigestLabel.text = news.digest;
    self.SNNPVCReplyCoutLabel.text = [NSString stringWithFormat: @"%@跟帖", [NSNumber numberWithUnsignedInteger: news.replyCount]];
}

- (void)SNNPVCSetUpSubviews
{
    // ???:需要考虑另一种情况,可能有的视图无图片啊!
    UIImageView * imageView = [[UIImageView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] init];
    UILabel * digestLabel = [[UILabel alloc] init];
    UILabel * replyCoutLabel = [[UILabel alloc] init];
    // ???:还可以设置自动换行吗?
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    
    digestLabel.numberOfLines = 2;
    digestLabel.font = [UIFont systemFontOfSize: 12.0];
    
    replyCoutLabel.font = digestLabel.font;


    // !!!:迭代至此,看一下 系统的label的字号.此处的label应该固定字号.
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    [digestLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    [replyCoutLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    self.SNNPVCImageView = imageView;
    self.SNNPVCTitleLabel = titleLabel;
    self.SNNPVCDigestLabel = digestLabel;
    self.SNNPVCReplyCoutLabel = replyCoutLabel;
    
    SNRelease(imageView);
    SNRelease(titleLabel);
    SNRelease(digestLabel);
    SNRelease(replyCoutLabel);
    
    [self.contentView addSubview: self.SNNPVCImageView];
    [self.contentView addSubview: self.SNNPVCTitleLabel];
    [self.contentView addSubview: self.SNNPVCDigestLabel];
    [self.SNNPVCDigestLabel addSubview: self.SNNPVCReplyCoutLabel];
    
    // 设置约束.
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    /* 横向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[imageView(==70)]-[titleLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, titleLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[imageView]-[digestLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, digestLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[replyCoutLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCoutLabel)]];
    
    /* 竖向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleLabel(==20)]" options:0 metrics: nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[digestLabel(==30)]-8-|" options:0 metrics: nil views:NSDictionaryOfVariableBindings(digestLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[imageView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[replyCoutLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCoutLabel)]];
    
    [self addConstraints: constraints];
}
@end
