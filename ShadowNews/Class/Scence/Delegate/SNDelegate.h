//
//  SNDelegate.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-16.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SNNewsMenuDelegate <NSObject>


@end

@protocol SNNewsModelDelegateT <NSObject>
@required
- (id<SNNewsMenuDelegate>) menu;

@end