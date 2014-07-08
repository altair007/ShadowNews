//
//  SNNewsMenu.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsMenu.h"

@implementation SNNewsMenu

- (void)dealloc
{
    self.itemsAdded = nil;
    self.itemsNotAdded = nil;
    self.itemLastScan = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (instancetype)menu
{
    SNNewsMenu * menu = [[[self class]alloc] init];
    SNAutorelease(menu);
    return menu;
}

- (instancetype) init
{
    if (self = [super init]) {
        // !!!:建议,已添加,未添加的栏目,和上次浏览的节目,应从本地数据库中读取数据.此处暂时用固定值.
        NSArray * itemsAdded = @[@"财经", @"体育", @"军事", @"娱乐", @"社会", @"论坛", @"NBA", @"中超", @"CBA", @"电影", @"国际足球", @"数码", @"彩票", @"世界杯", @"博客", @"科技", @"轻松一刻", @"原创", @"汽车", @"手机", @"移动互联", @"精选", @"家居", @"游戏", @"读书", @"教育", @"旅游", @"酒香", @"暴雪游戏",@"亲子", @"葡萄酒", @"时尚", @"情感"];
        NSArray * itemsNotAdded = @[@"本地", @"推荐", @"聚合阅读", @"头条", @"房产"];
        NSString * itemLastScan = @"轻松一刻";
        
        self.itemsAdded = itemsAdded;
        self.itemsNotAdded = itemsNotAdded;
        self.itemLastScan = itemLastScan;
    }
    
    return self;
}
@end
