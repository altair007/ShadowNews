//
//  SNNews.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNews.h"
@interface SNNews ()
@property (retain, nonatomic, readwrite) NSArray * imgs;
@property (copy, nonatomic, readwrite) NSString * title;
@property (copy, nonatomic, readwrite) NSString * digest;
@property (assign, nonatomic, readwrite) NSUInteger replyCount;
@property (copy, nonatomic, readwrite) NSString * docId;
@property (assign, nonatomic, readwrite) SNNewsSkipType skipType;
@property (copy, nonatomic, readwrite) NSString * photosetID;
@end

@implementation SNNews
- (void)dealloc
{
    self.imgs = nil;
    self.title = nil;
    self.digest = nil;
    self.docId = nil;
    self.photosetID = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (instancetype) newsWithDocId: (NSString *) docId
                        tittle: (NSString *) title
                        digest: (NSString *) digest
                    replyCount: (NSUInteger) replyCount
                          imgs: (NSArray *) imgs
{
    SNNews * news = [[[SNNews class] alloc] initWithDocId:docId tittle:title digest: digest replyCount: replyCount imgs: imgs];
    SNAutorelease(news);
    return news;
}

+ (instancetype) newsWithPhotosetId: (NSString *) photosetId
                             tittle: (NSString *) title
                             digest: (NSString *) digest
                         replyCount: (NSUInteger) replyCount
                               imgs: (NSArray *) imgs
{
    SNNews * news = [[[SNNews class] alloc] initWithPhotosetId: photosetId tittle: title digest: digest replyCount: replyCount imgs: imgs];
    SNAutorelease(news);
    return news;
}

- (instancetype) initWithTittle: (NSString *) title
                         digest: (NSString *) digest
                     replyCount: (NSUInteger) replyCount
                           imgs: (NSArray *) imgs
                       skipType: (SNNewsSkipType) skipType
                          docId: (NSString *) docId
                     photosetId: (NSString *) photosetId
{
    if (self = [super init]) {
        self.title = title;
        self.digest = digest;
        self.replyCount = replyCount;
        self.imgs = imgs;
        self.skipType = skipType;
        self.docId = docId;
        self.photosetID = photosetId;
    }
    
    return self;
}

- (instancetype) initWithDocId: (NSString *) docId
                        tittle: (NSString *) title
                        digest: (NSString *) digest
                    replyCount: (NSUInteger) replyCount
                          imgs: (NSArray *) imgs
{
    if (self = [self initWithTittle: title digest: digest replyCount:replyCount imgs: imgs skipType: SNNewsSkipTypeDoc docId:docId photosetId: nil]) {
        // 暂不需要额外的初始外操作.
    }
    
    return self;
}

- (instancetype) initWithPhotosetId: (NSString *) photosetId
                             tittle: (NSString *) title
                             digest: (NSString *) digest
                         replyCount: (NSUInteger) replyCount
                               imgs: (NSArray *) imgs
{
    if (self = [self initWithTittle:title digest:digest replyCount:replyCount imgs: imgs skipType: SNNewsSkipTypePhotoSet docId:nil photosetId: photosetId]) {
        // 暂不需要额外的初始化操作.
    }
    
    return self;
}
@end
