//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNewsViewController : UIViewController
- (IBAction)handleSegmentedControlValueChangedAction:(UISegmentedControl *)sender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *navSC;

@end
