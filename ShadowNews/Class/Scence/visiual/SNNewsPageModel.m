//
//  SNNewsPageModel.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "AFNetworking.h"
#import "SNNewsPageModel.h"

@implementation SNNewsPageModel
- (void)dealloc
{
    self.queue = nil;
    
    [super dealloc];
}

- (instancetype) init
{
    self = [super init];
    if (nil != self) {
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (void) newsForTopic: (NSString *) topic
                range: (NSRange) range
              success: (SNNewsPageModelSuccessBlock) success
                 fail: (SNNewsPageModelFailBlock) fail
{
    NSString * urlStr = [self urlForTopic: topic range: range];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * newsOriginalArray = [responseObject objectForKey: [self urlSegmentForTopic: topic]];
        success(newsOriginalArray);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        fail(error);
    }];
}

- (NSString *) urlForTopic: (NSString *) topic range: (NSRange) range
{
    NSString * urlStr = [NSString stringWithFormat: @"%@/%@/%@-%@.html", [self baseUrlForTopic: topic], [self urlSegmentForTopic: topic],[NSNumber numberWithInteger:range.location], [NSNumber numberWithInteger:range.length]];
    return urlStr;
}

- (NSString *) urlSegmentForTopic: (NSString *) topic
{
    NSDictionary * urlSegmentsOfTitles = @{@"财经": @"T1348648756099",
                                       @"体育": @"T1348649079062",
                                       @"军事": @"T1348648141035",
                                       @"娱乐": @"T1348648517839",
                                       @"论坛": @"T1349837670307",
                                       @"博客": @"T1349837698345",
                                       @"社会": @"T1348648037603",
                                       @"电影": @"T1348648650048",
                                       @"汽车": @"T1348654060988",
                                       @"中超": @"T1348649503389",
                                       @"世界杯": @"T1399700447917",
                                       @"彩票": @"T1356600029035",
                                       @"NBA": @"T1348649145984",
                                       @"国际足球": @"T1348649176279",
                                       @"CBA": @"T1348649475931",
                                       @"科技": @"T1348649580692",
                                       @"手机": @"T1348649654285",
                                       @"数码": @"T1348649776727",
                                       @"移动互联": @"T1351233117091",
                                       @"轻松一刻": @"T1350383429665",
                                       @"原创": @"T1367050859308",
                                       @"精选": @"T1370583240249",
                                       @"家居": @"T1348654105308",
                                       @"游戏": @"T1348654151579",
                                       @"读书": @"T1401272877187",
                                       @"教育": @"T1348654225495",
                                       @"旅游": @"T1348654204705",
                                       @"酒香": @"T1385429690972",
                                       @"暴雪游戏": @"T1397016069906",
                                       @"亲子": @"T1397116135282",
                                       @"葡萄酒": @"T1402031665628",
                                       @"时尚": @"T1348650593803",
                                       @"情感": @"T1348650839000"};
    
    NSString * segment = [urlSegmentsOfTitles objectForKey: topic];
    
    if (nil == segment ) {
        segment = [urlSegmentsOfTitles objectForKey: @"轻松一刻"];
    }
    return segment;
}

- (NSString *) baseUrl
{
    return @"http://c.3g.163.com";
}

- (NSString *) baseUrlForTopic: (NSString *) topic
{
    return [NSString stringWithFormat: @"%@/nc/article/list", [self baseUrl]];
}

@end
