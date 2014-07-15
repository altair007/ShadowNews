//
//  SNNewsModel.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
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
    // !!!: 如果静态分析报警,可以把它设为类静态变量,然后在dealloc中假释放一次.这样就需要把此类变为单例或者重写它的realse等方法了.
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
            // !!!: 临时屏蔽 "轻松一刻", @"论坛", @"原创".
            
            NSArray * topicData = @[@{@"ID": @"T1348648756099", @"NAME": @"财经"},
                                    @{@"ID": @"T1348649079062", @"NAME": @"体育"},
                                    @{@"ID": @"T1348648141035", @"NAME": @"军事"},
                                    @{@"ID": @"T1348648517839", @"NAME": @"娱乐"},
                                    @{@"ID": @"T1349837698345", @"NAME": @"博客"},
                                    @{@"ID": @"T1348648037603", @"NAME": @"社会"},
                                    @{@"ID": @"T1348649580692", @"NAME": @"科技"},
                                    @{@"ID": @"T1370583240249", @"NAME": @"精选"},
                                    @{@"ID": @"T1348654225495", @"NAME": @"教育"}];
            [db insert:@"SNTOPIC" batch: topicData];
        }
        
        /* 创建存储新闻信息的表. */
        if (0 == [db countAllResults:@"SNNEWS"]) {
            NSString * newsSql = @"CREATE TABLE IF NOT EXISTS SNNEWS (IMGS TEXT DEFAULT NULL, TITLE TEXT,DIGEST TEXT DEFAULT NULL,REPLY_COUNT integer,DOC_ID TEXT  DEFAULT NULL,SKIP_TYPE integer,PHOTOSET_ID TEXT DEFAULT NULL, TOPIC TEXT DEFAULT NULL)";
            [db executeUpdate: newsSql];
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

+ (void) newsForTopic: (NSString *) topic
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
    
    NSString * secret = [secretsOfTitles objectForKey: topic];
    NSString * urlStr = [NSString stringWithFormat: @"http://c.3g.163.com/nc/article/list/%@/%@-%@.html",secret,[NSNumber numberWithInteger:range.location], [NSNumber numberWithInteger:range.length]];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * newsOriginalArray = [responseObject objectForKey: secret];
        NSMutableArray * newsArray = [NSMutableArray arrayWithCapacity: 42];
        [newsOriginalArray enumerateObjectsUsingBlock:^(NSDictionary * newsOriginal, NSUInteger idx, BOOL *stop) {
            NSMutableArray * imgs = [NSMutableArray arrayWithCapacity: 42];
            NSString * imgSrc = [newsOriginal objectForKey: @"imgsrc"];
            NSArray * imgExtra = [newsOriginal objectForKey:@"imgextra"];
            
            if (YES != [imgSrc isEqualToString: @""]) {
                [imgs addObject: imgSrc];
            }
            
            if (nil != imgExtra) {
                [imgExtra enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                    [imgs addObject: [obj objectForKey: @"imgsrc"]];
                }];
            }
            
            if (0 == imgs.count) {
                imgs = nil;
            }
            
            NSString * title = [newsOriginal objectForKey: @"title"];
            NSString * digest = [newsOriginal objectForKey: @"digest"];
            NSUInteger replyCount = [(NSNumber *)[newsOriginal objectForKey: @"replyCount"] unsignedIntegerValue];
            NSString * docId = [newsOriginal objectForKey: @"docid"];
            NSString * photosetId = [newsOriginal objectForKey: @"photosetID"];
            SNNews * news = nil;
            if (nil != photosetId) {
                news = [SNNews newsWithPhotosetId: photosetId tittle:title digest: digest replyCount: replyCount imgs: imgs];
            }
            
            if (nil == news) {
                news = [SNNews newsWithDocId: docId tittle: title digest: digest replyCount: replyCount imgs: imgs];
            }
            
            [newsArray addObject: news];
        }];
        
        
        // 尽量保证第一条数据是有图新闻.
        if (0 == [newsArray[0] imgs].count) {
            [newsArray enumerateObjectsUsingBlock:^(SNNews * news, NSUInteger idx, BOOL *stop) {
                if (0 != news.imgs.count) {
                    [newsArray exchangeObjectAtIndex: 0 withObjectAtIndex: idx];
                    * stop = YES;
                }
            }];
        }
        
        success(newsArray);
        
        /* 根据range决定如何插入数据. */
        NSString * newsTable = @"SNNEWS";
        
        NSMutableArray * newsArraySql = [NSMutableArray arrayWithCapacity: 42];
        [newsArray enumerateObjectsUsingBlock:^(SNNews * news, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * newsDicSql = [NSMutableDictionary dictionaryWithCapacity: 42];
            
            [newsDicSql setValue: [news.imgs componentsJoinedByString: @","] forKey: @"IMGS"];
            [newsDicSql setValue: news.title forKey: @"TITLE"];
            [newsDicSql setValue: news.digest forKey: @"DIGEST"];
            [newsDicSql setValue: [NSNumber numberWithUnsignedInteger: news.replyCount] forKey: @"REPLY_COUNT"];
            [newsDicSql setValue: news.docId forKey: @"DOC_ID"];
            [newsDicSql setValue: [NSNumber numberWithInteger: news.replyCount] forKey: @"SKIP_TYPE"];
            [newsDicSql setValue: news.photosetID forKey: @"PHOTOSET_ID"];
            [newsDicSql setValue: topic forKey: @"TOPIC"];
            
            NSArray * keys = @[@"IMGS", @"TITLE", @"DIGEST", @"REPLY_COUNT", @"DOC_ID", @"SKIP_TYPE", @"PHOTOSET_ID", @"TOPIC"];
            [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL *stop) {
                if (nil == [newsDicSql objectForKey: key]) {
                    [newsDicSql setObject: @"" forKey: key];
                }
            }];
            
            [newsArraySql addObject: newsDicSql];
        }];
        
        [db open];
        if (0 == range.location) { // 说明是刷新数据.
            [db remove: newsTable  where: @{@"TOPIC" : topic}];
        }
        
        [db insert: newsTable batch: newsArraySql];
        [db close];
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
        // 用你所选择的匹配器设置模板引擎。
        MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
        [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
        
        // 获取模板地址.
        NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"];
        
        // 去除空结果.
        NSMutableDictionary * variables = [NSMutableDictionary dictionaryWithCapacity: 42];
        [(NSDictionary *)[responseObject objectForKey: docId] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]] && [(NSString *)obj isEqualToString: @""]) {
                return;
            }
            [variables setObject: obj forKey: key];
        }];
        
        // !!!: 此处应该是从数据库中获取字体。（对应设置页面的"字体设置".
        [variables setObject: @"'Times New Roman',Georgia,Serif" forKey: @"normalFont"];
        
        // !!!: 主题应该是从数据库中获取,对应"日间/夜间"模式的切换.
        [variables setObject: @"" forKey: @"theme"];
        
        // !!!: 字体大小应该是从数据中获取,可选:font_small font_normal font_large font_largex font_largexx font_largexxx.  对应设置页面的"正文字号".
        [variables setObject: @"font_normal" forKey: @"fontClass"];
        
        // 处理模板,并输出结果.
        NSMutableString * htmlStr = [NSMutableString stringWithString: [engine processTemplateInFileAtPath:templatePath withVariables:variables]];
        
        NSArray * imgArray = [variables objectForKey:@"img"];
        NSArray * videoArray = [variables objectForKey:@"video"];
        
        // !!!: 此处的HTML5标签,可能是不合适的.
        // !!!: 尝试关闭银屏,视频的全屏模式.
        if (imgArray.count > 0) {
            [imgArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                
                NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"<!--IMG#%@-->", [NSNumber numberWithUnsignedInteger: idx]] options:NSRegularExpressionCaseInsensitive error:nil];
                NSString * src = [imgArray[idx] objectForKey:@"src"];
                NSArray * sizeArray = [[imgArray[idx] objectForKey:@"pixel"] componentsSeparatedByString:@"*"];
                
                // ???:此处的逻辑,好像是不合适的.
                CGFloat  width = 280;
                CGFloat height = 280 *([sizeArray[1] floatValue]/3)/([sizeArray[0] floatValue]/3);
                
                // !!!: 网络图片加载时,应该有一个占位图片.本地占位图片.这个效果怎么实现?
                [regex replaceMatchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length]) withTemplate:[NSString stringWithFormat:@"<img src= %@ width = %f height = %f/>",src,width,height]];
            }];
            
        }
        if (videoArray.count > 0) {
            [videoArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
                
                NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"<!--VIDEO#%@-->", [NSNumber numberWithUnsignedInteger: idx]] options:NSRegularExpressionCaseInsensitive error:nil];
                [regex replaceMatchesInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length]) withTemplate:[NSString stringWithFormat:@"<embed src= %@ width = 280 height = 150 volume = 200 autostart = true webkit-playsinline/embed>",[videoArray[idx] objectForKey:@"url_mp4"]]];
            }];
        }
        
        NSString * docId = [variables objectForKey: @"docid"];
        NSUInteger replyCoutn = [[variables objectForKey: @"replyCount"] integerValue];
        
        SNNewsDetail * detail = [SNNewsDetail detailWithDocId: docId replyCount: replyCoutn htmlStr: htmlStr];
        success(detail);
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

+ (NSArray *) localNewsForTitle: (NSString *) title
{
    NSMutableArray * newsArray = [NSMutableArray arrayWithCapacity: 42];
    
    YFDataBase * db =  [[self class] db];
    [db open];
    
    YFResultSet * result = [db getWhere: @"SNNEWS" where: @{@"TOPIC": title}];
    
    while ([result next]) {
        NSArray * imgsTemp = [[result stringForColumn: @"IMGS"] componentsSeparatedByString: @","];
        NSMutableArray * imgs = [NSMutableArray arrayWithCapacity: 42];
        [imgsTemp enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            if (YES != [obj isEqualToString: @""]) {
                [imgs addObject: obj];
            }
        }];
        
        if (0 == imgs.count) {
            imgs = nil;
        }
        
        NSString * title = [result stringForColumn: @"TITLE"];
        NSString * digest = [result stringForColumn: @"DIGEST"];
        NSUInteger replyCount = [result intForColumn: @"REPLY_COUNT"];
        NSString * docId = [result stringForColumn: @"DOC_ID"];
        NSString * photosetId = [result stringForColumn: @"PHOTOSET_ID"];
        
        SNNews * news = nil;
        if (nil != photosetId) {
            news = [SNNews newsWithPhotosetId: photosetId tittle:title digest: digest replyCount: replyCount imgs: imgs];
        }
        
        if (nil == news) {
            news = [SNNews newsWithDocId: docId tittle: title digest: digest replyCount: replyCount imgs: imgs];
        }
        
        [newsArray addObject: news];
    }
    [db close];
    return newsArray;
}
@end
