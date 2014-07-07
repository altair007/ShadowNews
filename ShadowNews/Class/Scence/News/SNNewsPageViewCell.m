//
//  SNNewsPageViewCell.m
//  ShadowNews
//
//  Created by lanou3g on 14-6-28.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "SNNewsPageViewCell.h"
#import "SNNews.h"

@interface SNNewsPageViewCell ()
// !!!:改一下私有属性的命名.
@property(nonatomic,retain)UIImageView * newsImage;
@property(nonatomic,retain)UILabel * titleLabel;
@property(nonatomic,retain)UILabel * detailLabel;
@property(nonatomic,retain)UILabel * replyCountLabel;

@end

@implementation SNNewsPageViewCell
- (void)dealloc
{
    self.news = nil;
    self.newsImage = nil;
    self.titleLabel = nil;
    self.detailLabel = nil;
    self.replyCountLabel = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       [self setupSubview];
    }
    return self;
}
- (void)setupSubview
{
    CGFloat height = 60;
    CGFloat width = 310;
    self.newsImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width/4, height)] autorelease];
    self.newsImage.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_newsImage];
    
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(width/4 +5, 0, width-width/4-15, height/3)] autorelease];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(width/4+5, height/3, width-width/4-15, 2 *height/3)] autorelease];
    self.detailLabel.backgroundColor = [UIColor greenColor];
    self.detailLabel.font = [UIFont systemFontOfSize:10];
    self.detailLabel.numberOfLines = 0;

    [self.contentView addSubview:self.detailLabel];
    
    self.replyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-width/4-15-60 ,2 *height/3-10, 60, 10)];
    self.replyCountLabel.backgroundColor = [UIColor yellowColor];
    self.replyCountLabel.textAlignment = NSTextAlignmentRight;
    self.replyCountLabel.font = [UIFont systemFontOfSize:10];
    [self.detailLabel addSubview:self.replyCountLabel];
    
}

// !!!:在这个地方设置,或许不合适.当用"约束语法"的时候.猜测!
- (void)setNews:(SNNews *)news
{
    CGFloat height = 60;
    CGFloat width = 310;
    if (_news != news) {
        [_news release];
        _news = [news retain];
    }
    self.titleLabel.text = news.title;
    self.titleLabel.frame = CGRectMake(width/4 +5, 0, width-width/4-15, height/3);
    
    // ???:news定义有遗漏?
//    self.detailLabel.text = news.digest;
    self.detailLabel.frame = CGRectMake(width/4+5, height/3, width-width/4-15, 2 *height/3);
    if (news.replyCount > 10000) {
    self.replyCountLabel.text = [NSString stringWithFormat:@"%.1f万跟帖",news.replyCount/10000.0];
    }else{
    self.replyCountLabel.text = [NSString stringWithFormat:@"%ld跟帖",news.replyCount];
    }
//    if (nil != news.tag) {
//        UIImageView * tagIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:news.tag]];
//        
//        tagIV.backgroundColor = [UIColor redColor];
//        tagIV.frame = CGRectMake(width-width/4-15-60+30,2 *height/3-10, 30, 10);
//        
//        self.replyCountLabel.frame = CGRectMake(width-width/4-15-60-30 ,2 *height/3-10, 60, 10);
//        [self.detailLabel addSubview:tagIV];
//    }else{
//        
//    self.replyCountLabel.frame = CGRectMake(width-width/4-15-60 ,2 *height/3-10, 60, 10);
//    }
    self.replyCountLabel.frame = CGRectMake(width-width/4-15-60 ,2 *height/3-10, 60, 10);
    NSURL * url = [NSURL URLWithString:news.imgSrc];
    self.newsImage.frame = CGRectMake(0, 0, width/4, height);
    // !!!:此处是要添加图片.
//    [self.newsImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
