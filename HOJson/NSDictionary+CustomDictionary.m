//
//  NSDictionary+CustomDictionary.m
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import "NSDictionary+CustomDictionary.h"

@implementation NSDictionary (CustomDictionary)

- (NSMutableDictionary *)mergeDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:self];
    if ([dictionary isKindOfClass:[NSNull class]]) {
        return mdic;
    }
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mdic[key] == nil) {
            [mdic setObject:obj forKey:key];
        }else{
            //如果存在相同项并且是字典则合并
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *adic = [obj mergeDictionary:self[key]];
                [mdic setObject:adic forKey:key];
            }
        }
    }];
    return mdic;
}

- (NSString *)getKeyPathWithKey:(NSString *)oneKey
{
    NSMutableString *keyPathString = [NSMutableString string];
    //    NSLog(@"self:%@", self);
    if (self[oneKey] != nil) {
        [keyPathString appendFormat:@"%@", oneKey];
        return keyPathString;
    } else {
        for (id key in self) {
            id obj = self[key];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *str = [obj getKeyPathWithKey:oneKey];
                [keyPathString appendFormat:@"%@.%@", key, str];
                return keyPathString;
            }else if ([obj isKindOfClass:[NSArray class]]) {
                if ([(NSArray *)obj count] > 0) {
                    id aobj = [(NSArray *)obj firstObject];
                    if ([aobj isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                        for (NSDictionary *dic in (NSArray *)obj) {
                            mdic = [mdic mergeDictionary:dic];
                        }
                        NSString *str = [mdic getKeyPathWithKey:oneKey];
                        [keyPathString appendFormat:@"%@.%@", key, str];
                        return keyPathString;
                    }
                }
            }
        }
    }
    
    return keyPathString;
}

@end
