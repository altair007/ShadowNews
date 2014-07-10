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
#import "YFDataBase.h"

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

+ (YFDataBase *)db
{
    // !!!:一个更优雅的实现策略: 把这个类制成单例,把db作为此单例的一个属性.
    static YFDataBase * db = nil; //!< 唯一数据库实例对象.
    if (nil == db) { // 仅在第一次使用时创建并初始化数据库.
        /* 创建并打开数据库. */
        NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"ShadowNews.sqlite"];
        db = [[YFDataBase alloc]initWithPath: path];
        if (![db open]) {
            db = nil;
            return db;
        }
    
        /* 初始化数据库. */
        /* 创建存储新闻版块相关信息的表. */
        if (0 == [db countAllResults:@"SNTOPIC"]) {
            NSString * topicSql = @"CREATE TABLE IF NOT EXISTS SNTOPIC(ID TEXT PRIMARY KEY  NOT NULL  DEFAULT (null) ,NAME TEXT);";
            [db executeUpdate: topicSql];
            
            NSArray * topicData = @[@{@"ID": @"T1348648756099", @"NAME": @"财经"},
                                    @{@"ID": @"T1348649079062", @"NAME": @"体育"},
                                    @{@"ID": @"T1348648141035", @"NAME": @"军事"},
                                    @{@"ID": @"T1348648517839", @"NAME": @"娱乐"},
                                    @{@"ID": @"T1349837670307", @"NAME": @"论坛"},
                                    @{@"ID": @"T1349837698345", @"NAME": @"博客"},
                                    @{@"ID": @"T1348648037603", @"NAME": @"社会"},
                                    @{@"ID": @"T1348648650048", @"NAME": @"电影"},
                                    @{@"ID": @"T1348654060988", @"NAME": @"汽车"},
                                    @{@"ID": @"T1348649503389", @"NAME": @"中超"},
                                    @{@"ID": @"T1399700447917", @"NAME": @"世界杯"},
                                    @{@"ID": @"T1356600029035", @"NAME": @"彩票"},
                                    @{@"ID": @"T1348649145984", @"NAME": @"NBA"},
                                    @{@"ID": @"T1348649176279", @"NAME": @"国际足球"},
                                    @{@"ID": @"T1348649475931", @"NAME": @"CBA"},
                                    @{@"ID": @"T1348649580692", @"NAME": @"科技"},
                                    @{@"ID": @"T1348649654285", @"NAME": @"手机"},
                                    @{@"ID": @"T1348649776727", @"NAME": @"数码"},
                                    @{@"ID": @"T1351233117091", @"NAME": @"移动互联"},
                                    @{@"ID": @"T1350383429665", @"NAME": @"轻松一刻"},
                                    @{@"ID": @"T1367050859308", @"NAME": @"原创"},
                                    @{@"ID": @"T1370583240249", @"NAME": @"精选"},
                                    @{@"ID": @"T1348654105308", @"NAME": @"家居"},
                                    @{@"ID": @"T1348654151579", @"NAME": @"游戏"},
                                    @{@"ID": @"T1401272877187", @"NAME": @"读书"},
                                    @{@"ID": @"T1348654225495", @"NAME": @"教育"},
                                    @{@"ID": @"T1348654204705", @"NAME": @"旅游"},
                                    @{@"ID": @"T1385429690972", @"NAME": @"酒香"},
                                    @{@"ID": @"T1397016069906", @"NAME": @"暴雪游戏"},
                                    @{@"ID": @"T1397116135282", @"NAME": @"亲子"},
                                    @{@"ID": @"T1402031665628", @"NAME": @"葡萄酒"},
                                    @{@"ID": @"T1348650593803", @"NAME": @"时尚"},
                                    @{@"ID": @"T1348650839000", @"NAME": @"情感"}];
            [db insert:@"SNTOPIC" batch: topicData];
        }
        

        
        // 关闭数据库连接.
        [db close];
    }
    
    return db;
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
    NSMutableDictionary * secretsOfTitles = [NSMutableDictionary dictionaryWithCapacity: 42];
    
    YFDataBase * db = [[self class] db];
    [db open];
    YFResultSet * result = [db get:@"SNTOPIC"];
    while (YES == [result next]) {
        NSString * topicId = [result stringForColumn: @"ID"];
        NSString * topicName = [result stringForColumn: @"NAME"];
        [secretsOfTitles setObject: topicId forKey: topicName];
    }
    [db close];
    
    NSString * secret = [secretsOfTitles objectForKey: title];
    NSString * urlStr = [NSString stringWithFormat: @"http://c.3g.163.com/nc/article/list/%@/%@-%@.html",secret,[NSNumber numberWithInteger:range.location], [NSNumber numberWithInteger:range.length]];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * newsOriginalArray = [responseObject objectForKey: secret];
        NSMutableArray * newsArray = [NSMutableArray arrayWithCapacity: 42];
        [newsOriginalArray enumerateObjectsUsingBlock:^(NSDictionary * newsOriginal, NSUInteger idx, BOOL *stop) {
            
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
