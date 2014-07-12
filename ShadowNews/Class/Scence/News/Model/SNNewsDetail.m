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

- (NSString *) htmlStr
{
    // 用你所选择的匹配器设置模板引擎。
	MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
	[engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
	// 获取模板地址.
	NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"];
    
    // ???:有一个技术问题： js文件，能否被正确加载？
	// 设置用于某个特定模板的变量。
    NSMutableDictionary * variables = [NSMutableDictionary dictionaryWithCapacity: 42];
    
    // !!!: 此处应该是从数据库中获取字体。（对应设置页面的"字体设置"）.
    [variables setObject: @"'Times New Roman',Georgia,Serif" forKey: @"normalFont"];
    
    // !!!: 主题应该是从数据库中获取,对应"日间/夜间"模式的切换.
    [variables setObject: @"night" forKey: @"theme"];
    
    // !!!: 字体大小应该是从数据中获取,可选:font_small font_normal font_large font_largex font_largexx font_largexxx.  对应设置页面的"正文字号".
    [variables setObject: @"font_normal" forKey: @"fontClass"];
    
    if (nil != self.title) {
        [variables setObject: self.title forKey: @"title"];
    }
    
    if (nil != self.source) {
        [variables setObject: self.source forKey: @"source"];
    }
    
    if (nil != self.publishTime) {
        [variables setObject: self.publishTime forKey: @"ptime"];
    }
    
    // ???:竟然漏了一个重要属性.
//    if (nil != self.digest) {
//        [variables setObject: self.digest forKey: @"digest"];
//    }
    
    if (nil != self.body) {
        [variables setObject: self.body forKey: @"body"];
    }
    
//	NSDictionary *variables = @{@"title": self.title,
//                                @"source": self.source,
//                                @"ptime": self.publishTime,
//                                @"body": self.body};
    
	// 处理模板,并输出结果.
	NSString * result = [engine processTemplateInFileAtPath:templatePath withVariables:variables];

    return result;
}
@end
