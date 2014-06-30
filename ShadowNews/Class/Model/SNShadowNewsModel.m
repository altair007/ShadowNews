//
//  SNShadowNewsModel.m
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import "SNShadowNewsModel.h"
#import "Base64.h"
#import "AFNetworking.h"

@implementation SNShadowNewsModel
#pragma mark - 实例方法.
- (void) localNews: (NSString *) city
             range: (NSRange) range
           success: (void(^)(NSArray * array)) success
              fail: (void(^)(NSError * error)) fail
{
    NSString * urlStr = [NSString stringWithFormat: @"http://c.3g.163.com/nc/article/local/%@/%lu-%lu.html", [city base64EncodedString], range.location, range.length];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    [manager GET: urlStr parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        // !!!:迭代至此!封装字典.
        NSLog(@"%@", dict);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        fail(error);
    }];

//    
//    // 第二步: 设置网路需求
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    
//    NSLog(@"%@", request);
//    
//    // 使用异步链接,使用block 接受数据
//    
//    [request setHTTPMethod:@"GET"];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        // 判断
//        if (data != nil) {
//            
//            
//            // 使用类目进行解析
//            NSDictionary *all = [data objectFromJSONData];
//            
//            // NSLog(@"%@", all);
//            
//            // 根据key 获取字典的内容
//            NSArray *array = [all objectForKey:@"T1348649079062"];
//            
//            // NSLog(@"array = %@", array);
//            
//            NSMutableArray *newGroup = [NSMutableArray array];
//            
//            for (int i = 0; i < [array count]; i++) {
//                
//                NSDictionary *dic = [array objectAtIndex:i];
//                
//                //NSLog(@"dic = %@", dic);
//                
//                
//                News *new = [[News alloc]initWithDictionary:dic];
//                
//                [newGroup addObject:new];
//                
//                
//                //                NSString *newString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/local/%d-%d.html", 0, 20];
//                //
//                //                NSLog(@"%@", newString);
//                //
//                //
//                //                NSString *str2 = [@"北京"base64EncodedString];
//                //
//                //
//                //                NSLog(@"str2 = %@",str2);
//                
//                
//                
//                
//                
//                
//                
//                
//                // ???:这里如果不注销掉new就会崩,不知道为何
//                // [new release];
//                
//            }
//            
//            
//            
//            //成功获取数据,执行这个block
//            success(newGroup);
//            
//        } else {
//            
//            // 获取数据失败,执行这个block
//            
//            fail(connectionError);
//            NSLog(@"数据接受失败");
//            
//        }
//        
//        
//        
//        
//        
//    }];
//    
//    
}
@end
