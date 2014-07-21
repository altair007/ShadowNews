//
//  SNNavigationModelDelegate.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-21.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNNavigationModelDelegate <NSObject>
@required
@property (retain, nonatomic) NSArray * navItemTitles; //!< 存储导航栏标题.
@property (retain, nonatomic) NSArray * navItemImgs; //!< 存储用于导航栏的图片.
@end
