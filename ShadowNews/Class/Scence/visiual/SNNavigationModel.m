//
//  SNNavigationModel.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-21.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNavigationModel.h"

@implementation SNNavigationModel
- (instancetype) init
{
    self = [super init];
    if (nil != self) {
        self.navItemTitles = @[@"新闻", @"订阅", @"图片", @"视频", @"跟帖", @"电台"];
        self.navItemImgs = @[@"sidebar_nav_news", @"sidebar_nav_reading", @"sidebar_nav_photo", @"sidebar_nav_video", @"sidebar_nav_comment", @"sidebar_nav_radio"];
    }
    
    return self;
}
@end
