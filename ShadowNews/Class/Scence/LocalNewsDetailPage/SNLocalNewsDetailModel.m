//
//  SNLocalNewsDetailModel.m
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNLocalNewsDetailModel.h"
#import "AFNetworking.h"

@interface SNLocalNewsDetailModel ()
@property (copy, nonatomic, readwrite) NSString * title; //!< 文章标题.
@property (copy, nonatomic, readwrite) NSString * source; //!< 来源.
@property (copy, nonatomic, readwrite) NSString * publishTime; //!< 发表时间.
@property (assign, nonatomic, readwrite) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readwrite) NSString * sourceUrl; //!< 文章原文地址.
@property (copy, nonatomic, readwrite) NSString * templateType; //!< 模板类型.
@property (copy, nonatomic, readwrite) NSString * body; //!< 新闻主要内容.
@property (copy, nonatomic, readwrite) NSString * docId; //!< 新闻唯一标识符.s
@end

@implementation SNLocalNewsDetailModel

- (void) dealloc
{
    self.title = nil;
    self.source = nil;
    self.publishTime = nil;
    self.sourceUrl = nil;
    self.templateType = nil;
    self.body = nil;
    self.docId = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (void) localNewsDetailModelWithDocId: (NSString *) docId
                               success: (SNLocalNewsDetailModelSuccessBlock) success
                                  fail: (SNLocalNewsDetailModelFailBlock) fail
{
    NSString * urlStr = [NSString stringWithFormat: @"http://c.3g.163.com/nc/article/%@/full.html", docId];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * detailNews = [responseObject objectForKey: docId];
        NSString * title = [detailNews objectForKey: @"title"];
        NSString * source = [detailNews objectForKey: @"source"];
        NSString * publishTime = [detailNews objectForKey: @"ptime"];
        NSUInteger replyCount = [[detailNews objectForKey: @"replyCount"] unsignedIntegerValue];
        NSString * sourceUrl = [detailNews objectForKey: @"source_url"];
        NSString * templateType= [detailNews objectForKey: @"template"];
        NSString * body = [detailNews objectForKey: @"body"];
        
        success([SNLocalNewsDetailModel localNewsDetailModelWithDocId: docId title: title source: source publishTime: publishTime replyCount: replyCount sourceUrl: sourceUrl templateType: templateType body: body]);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        fail(error);
    }];
}

+ (instancetype) localNewsDetailModelWithDocId: (NSString *) docId
                                         title: (NSString *) title
                                        source: (NSString *) source
                                   publishTime: (NSString *) publishTime
                                    replyCount: (NSUInteger) replyCount
                                     sourceUrl: (NSString *) sourceUrl
                                  templateType: (NSString *) templateType
                                          body: (NSString *) body
{
    SNLocalNewsDetailModel * model = [[[self class] alloc] initWithDocId: docId title: title source: source publishTime: publishTime replyCount: replyCount sourceUrl: sourceUrl templateType: templateType body: body];
    SNAutorelease(model);
    return model;
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

- (instancetype) init
{
    if (self = [self initWithDocId: nil title: nil source: nil publishTime:nil replyCount:NSUIntegerMax sourceUrl: nil templateType: nil body: nil]) {
        /* 暂不需要额外的操作. */
    }
    return self;
}
@end
