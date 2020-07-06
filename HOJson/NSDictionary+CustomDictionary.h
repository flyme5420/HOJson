//
//  NSDictionary+CustomDictionary.h
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CustomDictionary)

//递归合并两个字典
- (NSMutableDictionary *)mergeDictionary:(NSDictionary *)dictionary;
- (NSString *)getKeyPathWithKey:(NSString *)oneKey;

@end
