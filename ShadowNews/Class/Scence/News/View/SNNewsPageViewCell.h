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

// !!!: 一个建议: 可以只使用一种新闻model,一种单元格,view可以根据数据自动判断应该使用哪一种风格.即,强view,弱Controller,实现封装.
/**
 *  用于各个新闻页面的单元格类
 */
@interface SNNewsPageViewCell : UITableViewCell
@property(nonatomic,retain) SNNews * news; //!< 单条概要新闻.

@end
