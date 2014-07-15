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
        NSArray * itemsAdded = @[@"精选", @"社会", @"财经", @"体育", @"娱乐", @"科技", @"博客", @"军事", @"教育"];
        NSString * itemLastScan = @"精选";
        NSArray * itemsNotAdded = nil;
        
        self.itemsAdded = itemsAdded;
        self.itemsNotAdded = itemsNotAdded;
        self.itemLastScan = itemLastScan;
    }
    
    return self;
}
@end
