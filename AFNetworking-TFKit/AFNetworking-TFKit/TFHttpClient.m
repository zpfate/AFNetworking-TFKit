//
//  TFHttpClient.m
//  AFNetworking-TFKit
//
//  Created by Twisted Fate on 2020/5/21.
//  Copyright © 2020 Twisted Fate. All rights reserved.
//

#import "TFHttpClient.h"
#import <AFNetworking.h>

@interface TFHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation TFHttpClient

- (instancetype)init {
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

//+ (TFHttpClient *)loginClient {
//    
//}


@end
