//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNewsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIToolbar *navigation;
@property (retain, nonatomic) IBOutletCollection(UIToolbar) NSArray *navCollection;

@end
