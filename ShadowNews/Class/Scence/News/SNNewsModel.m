//
//  SNNewsModel.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsModel.h"
#import "SNNewsMenu.h"

@implementation SNNewsModel
-(void)dealloc
{
    self.menu = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (instancetype)model
{
    SNNewsModel * model = [[[self class] alloc] init];
    SNAutorelease(model);
    return model;
}

- (instancetype) init
{
    if (self = [super init]) {
        self.menu = [SNNewsMenu menu];
    }
    
    return self;
}
@end
