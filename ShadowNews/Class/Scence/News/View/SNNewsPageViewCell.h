//
//  SNNewsPageViewCell.h
//  ShadowNews
//
//  Created by 颜风. on 14-6-28.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNNews;

// !!!: 一种新的cell创建方式: 同步+异步,相结合,即先同步获取cell的样式,并布局,然后等待异步数据,更新下table即可(或者是更新下cell,以cell为最小单位进行更新.)

// !!!: 传说中的簇语法.
// !!!: 一个建议: 可以只使用一种新闻model,一种单元格,view可以根据数据自动判断应该使用哪一种风格.即,强view,弱Controller,实现封装.
// !!!: 很有创意的一个建议: 只要重写方法,使cell有一个属性或者有一个类方法,可以根据cell生成对应的重用标志.可能还需要重写 PageView的重用deque....方法.
/**
 *  用于各个新闻页面的单元格类
 */
@interface SNNewsPageViewCell : UITableViewCell
// !!!: 总感觉cell也要通过代理获取news,这样的好处是,灵活性非常高,可以自由决定在是什么时机去请求数据.
@property(nonatomic,retain) SNNews * news; //!< 单条概要新闻.

@end
