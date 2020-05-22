//
//  TFHttpClient.m
//  AFNetworking-TFKit
//
//  Created by Twisted Fate on 2020/5/21.
//  Copyright © 2020 Twisted Fate. All rights reserved.
//

#import "TFHttpClient.h"
#import <AFNetworking.h>
#import "TFResponse.h"
#import "AFNetworking-TFKit.h"

@interface TFHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation TFHttpClient

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [_manager.requestSerializer setTimeoutInterval:10];
    }
    return self;
}

+ (TFHttpClient *)client {
    TFHttpClient *client = [[[self class] alloc ] init];
    return client;
}

/// 请求结果处理
- (TFResponse *)handleTask:(NSURLSessionDataTask *)task responseObject:(nullable id)responseObject error:(NSError *)error {
    TFResponse *response = [[TFResponse alloc] init];
    if (error) {
        response.success = NO;
        NSHTTPURLResponse *URLResponse = (NSHTTPURLResponse *)task.response;
        response.statusCode = URLResponse.statusCode;
        NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:error.userInfo];
        if ([userInfo.allKeys containsObject:@"body"]) {
            NSString *bodyStr = userInfo[@"body"];
            NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *body = [NSJSONSerialization JSONObjectWithData:bodyData options:0 error:nil];
            if ([body.allKeys containsObject:@"message"]) {
                if (![body[@"message"] isKindOfClass:[NSNull class]]) {
                    response.errMsg = body[@"message"];
                }
            }
            if ([body.allKeys containsObject:@"code"]) {
                if (![[body objectForKey:@"code"] isKindOfClass:[NSNull class]]) {
                    response.statusCode = [[body objectForKey:@"code"] integerValue];
                }
            }
        }
    } else {
        response.success = YES;
        response.statusCode = [responseObject integerForKey:@"statusCode"];
        response.data = responseObject[@"data"];
    }
    return response;
}


/// GET
- (void)GET:(NSString *)URLString parameters:(nonnull id)parameters success:(nullable TFResponseBlock)success failure:(nullable TFResponseBlock)failure {
    [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        TFResponse *response = [self handleTask:task responseObject:responseObject error:nil];
        BLOCK_EXEC(success, response);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        TFResponse *response = [self handleTask:task responseObject:nil error:error];
        BLOCK_EXEC(failure, response);
    }];
}


@end
