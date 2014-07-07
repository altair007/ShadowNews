//
//  SNNews.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNews.h"

@interface SNNews ()
@property (copy, nonatomic, readwrite) NSString * imgSrc;
@property (copy, nonatomic, readwrite) NSString * title;
@property (copy, nonatomic, readwrite) NSString * digest;
@property (assign, nonatomic, readwrite) NSUInteger replyCount;
@property (copy, nonatomic, readwrite) NSString * docId;
@end

@implementation SNNews
- (void)dealloc
{
    self.imgSrc = nil;
    self.title = nil;
    self.digest = nil;
    self.docId = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (instancetype) newsWithImgSrc:(NSString *)imgSrc title:(NSString *)title publishTime:(NSString *)pulishTime replyCount:(NSUInteger)replyCount docId:(NSString *)docId
{
    SNNews * news = [[[self class] alloc] initWithImgSrc: imgSrc title: title publishTime: pulishTime replyCount: replyCount docId: docId];
    SNAutorelease(news)
    return news;
}


- (instancetype) initWithImgSrc: (NSString *) imgSrc
                          title: (NSString *) title
                    publishTime: (NSString *) pulishTime
                     replyCount: (NSUInteger) replyCount
                          docId: (NSString *) docId
{
    if (self = [super init]) {
        self.imgSrc = imgSrc;
        self.title = title;
        self.digest = pulishTime;
        self.replyCount = replyCount;
        self.docId = docId;
    }
    
    return self;
}
@end
