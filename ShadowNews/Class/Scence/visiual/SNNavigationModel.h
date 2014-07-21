//
//  SNNavigationModel.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-21.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNNavigationModelDelegate.h"

@interface SNNavigationModel : NSObject <SNNavigationModelDelegate>
@property (retain, nonatomic) NSArray * navItemTitles;
@property (retain, nonatomic) NSArray * navItemImgs;

@end
