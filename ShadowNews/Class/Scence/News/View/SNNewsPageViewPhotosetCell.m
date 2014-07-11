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
        [self SNNPVCSetUpSubviews];
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
    /* 创建视图. */
    UIView * placeHolderViewOfContent = [[UIView alloc] init];
    [placeHolderViewOfContent setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self.contentView addSubview: placeHolderViewOfContent];
    SNRelease(placeHolderViewOfContent);
    
    UIView * placeHolderViewOfImages = [[UIView alloc] init];
    [placeHolderViewOfImages setTranslatesAutoresizingMaskIntoConstraints: NO];
    [placeHolderViewOfContent addSubview: placeHolderViewOfImages];
    SNRelease(placeHolderViewOfImages);
    
    UILabel * titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    [placeHolderViewOfContent addSubview: titleLabel];
    self.SNNPVPCTitleLabel = titleLabel;
    SNRelease(titleLabel);
    
    UILabel * replyCountLabel = [[UILabel alloc] init];
    [replyCountLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    replyCountLabel.font = [UIFont systemFontOfSize: 12.0];
    [titleLabel addSubview: replyCountLabel];
    self.SNNPVPCReplyCountLable = replyCountLabel;
    SNRelease(replyCountLabel);
    replyCountLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView * leftImageView = [[UIImageView alloc] init];
    [leftImageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [placeHolderViewOfImages addSubview: leftImageView];
    SNRelease(leftImageView);
    self.SNNPVPCImageViewLeft = leftImageView;
    
    UIImageView * middleImageView = [[UIImageView alloc] init];
    [middleImageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [placeHolderViewOfImages addSubview: middleImageView];
    SNRelease(middleImageView);
    self.SNNPVPCImageViewMiddle = middleImageView;
    
    UIImageView * rightImageView = [[UIImageView alloc] init];
    [rightImageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [placeHolderViewOfImages addSubview: rightImageView];
    SNRelease(rightImageView);
    self.SNNPVPCImageViewRight = rightImageView;
    
    /* 设置约束. */
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[placeHolderViewOfContent]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(placeHolderViewOfContent)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[placeHolderViewOfContent]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(placeHolderViewOfContent)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel(==20)]-(>=0)-[placeHolderViewOfImages]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, placeHolderViewOfImages)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[placeHolderViewOfImages]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(placeHolderViewOfImages)]];
    
    // ???:lable如何设置文字居左显示.
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[replyCountLabel(==60)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCountLabel)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[replyCountLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCountLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[leftImageView]-[middleImageView(==leftImageView)]-[rightImageView(==leftImageView)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftImageView, middleImageView, rightImageView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftImageView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[middleImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(middleImageView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightImageView)]];
    
    [self addConstraints: constraints];
}

@end
