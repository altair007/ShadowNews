//
//  SNNewsPageViewTextCell.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-13.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsPageViewTextCell.h"
#import "SNNews.h"

@interface SNNewsPageViewTextCell ()
@property (retain, nonatomic) UILabel * SNNPVCTitleLabel; //!< 新闻主题.
@property (retain, nonatomic) UILabel * SNNPVCDigestLabel; //!< 新闻摘要.
@property (retain, nonatomic) UILabel * SNNPVCReplyCoutLabel; //!< 回帖数.
@end

@implementation SNNewsPageViewTextCell
- (void)dealloc
{
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
        
        // !!!: 下面这个逻辑,应该在didMoveToSuperview中,对应的,应该提供一个代理方法,而不是直接通过news属性传值.
        [self SNNPVCSetUpSubviews];
    }
    return self;
}

- (void)setNews:(SNNews *)news
{
    [news retain];
    [_news release];
    _news = news;
    
    self.SNNPVCTitleLabel.text = news.title;
    
    NSString * digest = news.digest;
    if (news.digest.length > 30) {
        digest = [news.digest substringToIndex:30];
    }
    self.SNNPVCDigestLabel.text = digest;
    
    self.SNNPVCReplyCoutLabel.text = [NSString stringWithFormat: @"%@跟帖", [NSNumber numberWithUnsignedInteger: news.replyCount]];
}

- (void)SNNPVCSetUpSubviews
{
    UILabel * titleLabel = [[UILabel alloc] init];
    UILabel * digestLabel = [[UILabel alloc] init];
    UILabel * replyCoutLabel = [[UILabel alloc] init];
    
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    
    digestLabel.numberOfLines = 2;
    digestLabel.font = [UIFont systemFontOfSize: 12.0];
    
    replyCoutLabel.font = digestLabel.font;
    replyCoutLabel.textAlignment = NSTextAlignmentRight;
    
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    [digestLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    [replyCoutLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    self.SNNPVCTitleLabel = titleLabel;
    self.SNNPVCDigestLabel = digestLabel;
    self.SNNPVCReplyCoutLabel = replyCoutLabel;
    
    SNRelease(titleLabel);
    SNRelease(digestLabel);
    SNRelease(replyCoutLabel);
    
    [self.contentView addSubview: self.SNNPVCTitleLabel];
    [self.contentView addSubview: self.SNNPVCDigestLabel];
    [self.SNNPVCDigestLabel addSubview: self.SNNPVCReplyCoutLabel];
    
    // 设置约束.
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    /* 横向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[titleLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[digestLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(digestLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[replyCoutLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCoutLabel)]];
    
    /* 竖向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleLabel(==20)]" options:0 metrics: nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[digestLabel(==30)]-8-|" options:0 metrics: nil views:NSDictionaryOfVariableBindings(digestLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[replyCoutLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCoutLabel)]];
    
    [self addConstraints: constraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected: selected animated: animated];
    // Configure the view for the selected state
    
}
@end