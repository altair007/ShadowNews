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
@end

@implementation SNNewsPageViewCell
- (void)dealloc
{
    
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
    
    // ???:应该支持自适应高度.
    if (nil != self.news.imgSrc) {
        [self.imageView setImageWithURL:[NSURL URLWithString: news.imgSrc] placeholderImage:[UIImage imageNamed:@"default.png"]];
    }
    self.textLabel.text = news.title;
    self.detailTextLabel.text = news.digest;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
