//
//  SNNewsDetail.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "SNNewsDetail.h"

@interface SNNewsDetail ()
@property (copy, nonatomic, readwrite) NSString * docId;
@property (assign, nonatomic, readwrite) NSUInteger replyCount;
@property (copy, nonatomic, readwrite) NSString * htmlStr;
@end

@implementation SNNewsDetail
+ (instancetype) detailWithDocId: (NSString *) docId
                      replyCount: (NSUInteger) replyCount
                         htmlStr: (NSString *) htmlStr
{
    SNNewsDetail * detail = [[[SNNewsDetail class] alloc] initWithDocId: docId replyCount: replyCount htmlStr: htmlStr];
    SNAutorelease(detail);
    return detail;
}

- (instancetype) initWithDocId: (NSString *) docId
                    replyCount: (NSUInteger) replyCount
                       htmlStr: (NSString *) htmlStr
{
    if (self = [super init]) {
        self.docId = docId;
        self.replyCount = replyCount;
        self.htmlStr = htmlStr;
    }
    
    return self;
}
@end
