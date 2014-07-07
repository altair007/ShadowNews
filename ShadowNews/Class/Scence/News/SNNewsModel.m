//
//  SNNewsModel.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNNewsModel.h"
#import "SNNewsMenu.h"
#import "AFNetworking.h"
#import "SNNews.h"
#import "SNNewsDetail.h"

@interface SNNewsModel ()
@property (retain, nonatomic, readwrite) SNNewsMenu * menu;//!< 新闻菜单.
@end
@implementation SNNewsModel
-(void)dealloc
{
    self.menu = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (instancetype)model
{
    SNNewsModel * model = [[[self class] alloc] init];
    SNAutorelease(model);
    return model;
}

+ (void) newsForTitle: (NSString *) title
                range: (NSRange) range
              success: (SNNewsModelSuccessBlock) success
                 fail: (SNNewsModelFailBlock) fail
{
    // !!!:暂只处理占80%的通用界面的显示.
    // ???:每个主题都有一个唯一对应的值,暂在此存储.
    NSDictionary * secretsOfTitles = @{@"财经": @"T1348648756099",
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
    
    NSString * secret = [secretsOfTitles objectForKey: title];
    NSString * urlStr = [NSString stringWithFormat: @"http://c.3g.163.com/nc/article/list/%@/%lu-%lu.html",secret,range.location, range.length];
    NSLog(@"-----urlStr %@",urlStr);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * newsOriginalArray = [responseObject objectForKey: secret];
        NSMutableArray * newsArray = [NSMutableArray arrayWithCapacity: 42];
        [newsOriginalArray enumerateObjectsUsingBlock:^(NSDictionary * newsOriginal, NSUInteger idx, BOOL *stop) {
            
            // ???:news对象,可能还需要一个 tag 属性.
            NSString * imgSrc = [newsOriginal objectForKey: @"imgsrc"];
            NSString * title = [newsOriginal objectForKey: @"title"];
            NSString * digest = [newsOriginal objectForKey: @"digest"];
            NSUInteger replyCount = [(NSNumber *)[newsOriginal objectForKey: @"replyCount"] unsignedIntegerValue];
            NSString * docId = [newsOriginal objectForKey: @"docid"];
            [newsArray addObject:[SNNews newsWithImgSrc:imgSrc title:title publishTime:digest replyCount:replyCount docId:docId]];
        }];
        success(newsArray);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        fail(error);
    }];
}

+ (void) detailModelWithDocId: (NSString *) docId
                      success: (SNNewsModelSuccessBlock) success
                         fail: (SNNewsModelFailBlock) fail
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
        
        success([SNNewsDetail detailWithDocId: docId title: title source: source publishTime: publishTime replyCount: replyCount sourceUrl: sourceUrl templateType: templateType body: body]);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        fail(error);
    }];

}

- (instancetype) init
{
    if (self = [super init]) {
        self.menu = [SNNewsMenu menu];
    }
    
    return self;
}

@end
