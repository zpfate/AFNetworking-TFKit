//
//  TFResponse.h
//  AFNetworking-TFKit
//
//  Created by Twisted Fate on 2020/5/22.
//  Copyright © 2020 Twisted Fate. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TFResponse;
typedef void(^TFResponseBlock)(TFResponse * _Nonnull response);

@interface TFResponse : NSObject
/// 请求是否成功
@property (nonatomic, assign) BOOL success;
/// data返回
@property (nonatomic, strong) id data;
/// 错误码
@property (nonatomic, assign) NSInteger statusCode;
/// 错误消息
@property (nonatomic, strong) NSString *errMsg;

@end

NS_ASSUME_NONNULL_END
