//
//  ConstSingleton.h
//  HOJson
//
//  Created by Chris on 15/8/22.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#ifndef HOJson_ConstSingleton_h
#define HOJson_ConstSingleton_h

#define SINGLEH @"//  Created by Chris Hu\n      \
\n#import <Foundation/Foundation.h>               \
\n#import \"%@.h\"                                    \
\n                                                \
\n@interface DataManager : NSObject               \
\n{                                               \
\n}                                               \
\n                                                \
\n@property (strong) NSMutableDictionary *jsonDic;        \
\n                                                        \
\n+ (DataManager *)sharedManager;                         \
\n- (void)startAsyncRequest:(NSArray *)urlArray modelsArray:(NSArray *)modelsArray refreshHeadler:(void (^)(int))refresh completionHeadler:(void (^) \())completion;                                     \
\n                                                            \
\n@end                                                    \
\n                                                            \
\n"                                                       \


#define SINGLEM @"//  Created by Chris Hu\n                             \
\n                                                \
\n#import \"DataManager.h\"                                 \
\n#import \"AFNetworking.h\"                            \
\n                                                    \
\n@implementation DataManager                             \
\n                                                        \
\n- (instancetype)init                                \
\n{                                                   \
\n    self = [super init];                                \
\n    if (self) {                                     \
\n        _jsonDic = [[NSMutableDictionary alloc]init];   \
\n    }                                                   \
\n    return self;                                        \
\n}                                                       \
\n                                                        \
\n+ (id)sharedManager {                                       \
\n    static dispatch_once_t once;                            \
\n    static id instance;                                 \
\n    dispatch_once(&once, ^{                             \
\n        instance = [self new];                              \
\n    });                                                 \
\n    return instance;                                    \
\n}                                                       \
\n                                                        \
\n- (void)startAsyncRequest:(NSArray *)urlArray modelsArray:(NSArray *)modelsArray refreshHeadler:(void (^)(int))refresh completionHeadler:(void (^)())completion                                                                                                    \
\n{                                                                                                                                 \
\n    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];                                   \
\n    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@\"application/json\", @\"text/json\", @\"text/html\", nil];                                                                                                            \
\n    for (int i = 0; i < urlArray.count; i++) {                                                                         \
\n        [manager GET:urlArray[i] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {       \
\n              NSDictionary *jsonDic = responseObject;                                                                         \
\n            NSString *modelStr = modelsArray[i];                            \
\n            id modelObj = [NSClassFromString(modelStr) modelObjectWithDictionary:jsonDic];        \
\n            [_jsonDic setObject:modelObj forKey:@(i)];                                                                    \
\n            refresh(i);                                                                                                 \
\n            if (manager.operationQueue.operations.count == 0) {                                                         \
\n                completion();                                                                                           \
\n            }                                                                                                           \
\n        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {                                                \
\n            completion();                                                                                               \
\n        }];                                                                                                             \
\n    }                                                                                                                   \
\n}                                                                                                                       \
\n                                                                                                                        \
\n@end                                                                                                                    \
                                                                                                                        \
"                                                                                                                       \


#endif

