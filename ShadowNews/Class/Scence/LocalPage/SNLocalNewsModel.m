//
//  SNLocalNewsModel.m
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNLocalNewsModel.h"

@interface SNLocalNewsModel ()
#pragma mark - 属性.
@property (copy, nonatomic, readwrite) NSString * imgSrc; //!< 主题图片网址.
@property (copy, nonatomic, readwrite) NSString * title; //!< 新闻标题.
@property (copy, nonatomic, readwrite) NSString * publishTime; //!< 发表时间.
@property (assign, nonatomic, readwrite) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readwrite) NSString * docId; //!< 文章唯一标识.
@end

@implementation SNLocalNewsModel
#pragma mark - 实例方法.
- (void)dealloc
{
    self.imgSrc = nil;
    self.title = nil;
    self.publishTime = nil;
    self.docId = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (instancetype) localNewsWithImgSrc: (NSString *) imgSrc
                               title: (NSString *) title
                         publishTime: (NSString *) pulishTime
                          replyCount: (NSUInteger) replyCount
                               docId: (NSString *) docId
{
    SNLocalNewsModel * model = [[[self class] alloc] initWithImgSrc: imgSrc title: title publishTime: pulishTime replyCount: replyCount docId: docId];
    SNAutorelease(model);
    return model;
}

/**
 *  便利初始化.
 *
 *  @param imgSrc     主题图片网址.
 *  @param title      新闻标题.
 *  @param pulishTime 发表时间.
 *  @param replyCount 跟帖数.
 *  @param docId      文章唯一标识.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithImgSrc: (NSString *) imgSrc
                          title: (NSString *) title
                    publishTime: (NSString *) pulishTime
                     replyCount: (NSUInteger) replyCount
                          docId: (NSString *) docId
{
    if (self = [super init]) {
        self.imgSrc = imgSrc;
        self.title = title;
        self.publishTime = pulishTime;
        self.replyCount = replyCount;
        self.docId = docId;
    }
    
    return self;
}

- (instancetype) init
{
    if (self = [self initWithImgSrc: nil title:nil publishTime: nil replyCount: NSUIntegerMax docId: nil]) {
        /* 暂不需要额外的初始化工作. */
    }
    
    return self;
}
@end
