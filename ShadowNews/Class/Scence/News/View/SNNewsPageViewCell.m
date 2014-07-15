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
    
    [self.SNNPVCImageView setImageWithURL:[NSURL URLWithString: self.news.imgs[0]] placeholderImage:[UIImage imageNamed:@"default.png"] ];
    
    
}

// !!!: 统一下各cell的布局.
- (void)SNNPVCSetUpSubviews
{
    
    
    UIImageView * imageView = [[UIImageView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] init];
    UILabel * digestLabel = [[UILabel alloc] init];
    UILabel * replyCoutLabel = [[UILabel alloc] init];

    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    
    // !!!:这个值,需要根据"日间/夜间"模式,进行调整.
    // !!!:建议:和"日间/夜间"有关的或者和背景色有关的,统一在layoutSubView里.(好像不太现实,没必要暴露那么多属性.)
//    titleLabel.textColor = [UIColor grayColor];
    
    digestLabel.numberOfLines = 2;
    digestLabel.font = [UIFont systemFontOfSize: 12.0];
    
    replyCoutLabel.font = digestLabel.font;
    replyCoutLabel.textAlignment = NSTextAlignmentRight;

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
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[replyCoutLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCoutLabel)]];
    
    /* 竖向约束. */
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[titleLabel(==20)]" options:0 metrics: nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[digestLabel(==30)]-8-|" options:0 metrics: nil views:NSDictionaryOfVariableBindings(digestLabel)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[imageView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[replyCoutLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(replyCoutLabel)]];
    
    [self addConstraints: constraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // !!!:选中时,有一个闪屏BUG.
    [super setSelected: selected animated: animated];
    // Configure the view for the selected state
    
//    // !!!: 夜间模式的另一中实现思路: 加图层罩.
//    if (YES == selected) {
//        // !!!:根据"日间/夜间"模式设置背景色.
//        self.contentView.backgroundColor = [UIColor colorWithRed: 0x1F/255.0 green: 0x20/255.0 blue: 0x23/255.0 alpha:1.0];
//        self.SNNPVCTitleLabel.textColor = [UIColor blackColor];
//    }
}
@end
