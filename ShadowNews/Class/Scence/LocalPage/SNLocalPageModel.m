//
//  SNLocalPageModel.m
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNLocalPageModel.h"
#import "Base64.h"
#import "AFNetworking.h"
#import "SNLocalNewsModel.h"

@implementation SNLocalPageModel
+ (void) localPageModelWithCity: (NSString *) city
                          range: (NSRange) range
                        success: (SNLocalPageModelSuccessBlock) success
                           fail: (SNLocalPageModelFailBlock) fail;
{
    NSString * urlStr = [NSString stringWithFormat: @"http://c.3g.163.com/nc/article/local/%@/%lu-%lu.html", [city base64EncodedString], range.location, range.length];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * newsOriginalArray = [responseObject objectForKey: city];
        NSMutableArray * localNewsArray = [NSMutableArray arrayWithCapacity: 42];
        [newsOriginalArray enumerateObjectsUsingBlock:^(NSDictionary * newsOriginal, NSUInteger idx, BOOL *stop) {
            NSString * imgSrc = [newsOriginal objectForKey: @"imgsrc"];
            NSString * title = [newsOriginal objectForKey: @"title"];
            NSString * publishTime = [newsOriginal objectForKey: @"ptime"];
            NSUInteger replyCount = [(NSNumber *)[newsOriginal objectForKey: @"replyCount"] unsignedIntegerValue];
            NSString * docId = [newsOriginal objectForKey: @"docid"];
            [localNewsArray addObject:[SNLocalNewsModel localNewsWithImgSrc: imgSrc title: title publishTime: publishTime replyCount: replyCount docId: docId]];
        }];
        
        success(localNewsArray);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
         fail(error);
    }];
}
@end
