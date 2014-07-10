//
//  SNNewsDetail.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsDetail.h"
@interface SNNewsDetail ()
@property (copy, nonatomic, readwrite) NSString * title;
@property (copy, nonatomic, readwrite) NSString * source;
@property (copy, nonatomic, readwrite) NSString * publishTime;
@property (assign, nonatomic, readwrite) NSUInteger replyCount;
@property (copy, nonatomic, readwrite) NSString * sourceUrl;
@property (copy, nonatomic, readwrite) NSString * templateType;
@property (copy, nonatomic, readwrite) NSString * body;
@property (copy, nonatomic, readwrite) NSString * docId;
@end

@implementation SNNewsDetail
+ (instancetype) detailWithDocId: (NSString *) docId
                           title: (NSString *) title
                          source: (NSString *) source
                     publishTime: (NSString *) publishTime
                      replyCount: (NSUInteger) replyCount
                       sourceUrl: (NSString *) sourceUrl
                    templateType: (NSString *) templateType
                            body: (NSString *) body
{
    SNNewsDetail * detail = [[[self class] alloc]initWithDocId:docId title: title source:source publishTime:publishTime replyCount:replyCount sourceUrl: sourceUrl templateType: templateType body:body];
    SNAutorelease(detail);
    return detail;
}
- (instancetype) initWithDocId: (NSString *) docId
                         title: (NSString *) title
                        source: (NSString *) source
                   publishTime: (NSString *) publishTime
                    replyCount: (NSUInteger) replyCount
                     sourceUrl: (NSString *) sourceUrl
                  templateType: (NSString *) templateType
                          body: (NSString *) body
{
    if (self = [super init]) {
        self.docId = docId;
        self.title = title;
        self.source = source;
        self.publishTime = publishTime;
        self.replyCount = replyCount;
        self.sourceUrl = sourceUrl;
        self.templateType = templateType;
        self.body = body;
    }
    
    return self;
}
@end
