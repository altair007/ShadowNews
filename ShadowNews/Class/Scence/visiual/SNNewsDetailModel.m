//
//  SNNewsDetailModel.m
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "ICUTemplateMatcher.h"
#import "MGTemplateEngine.h"
#import "AFNetworking.h"
#import "SNNewsDetailModel.h"

@implementation SNNewsDetailModel
- (void) detailModelWithDocId: (NSString *) docId
                      success: (SNNewsDetailModelSuccessBlock) success
                         fail: (SNNewsDetailModelFailBlock) fail
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
        success(htmlStr);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        fail(error);
    }];
  
}

@end
