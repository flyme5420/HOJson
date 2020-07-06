//
//  NSString+CustomString.m
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import "NSString+CustomString.h"

@implementation NSString (CustomString)

- (NSString *)firstCharUpper
{
    NSString *newStr = [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1]];
    return newStr;
}

- (NSString *)firstCharlower
{
    NSString *newStr = [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] lowercaseString], [self substringFromIndex:1]];
    return newStr;
}

- (NSString *)includeFile
{
    return [NSString stringWithFormat:@"%@.h", self];
}

- (NSString *)mfile
{
    return [NSString stringWithFormat:@"%@.m", self];
}

- (NSString *)xibfile
{
    return [NSString stringWithFormat:@"%@.xib", self];
}

- (NSString *)convertkey
{
    NSString *s = self;
    if ([self isEqualToString:@"id"]) {
        s = NEWID;
    } else if ([self isEqualToString:@"description"]) {
        s = NEWDESC;
    } else if ([self characterAtIndex:0] <= '9')
    {
        s = [NSString stringWithFormat:@"%@%@", NEW, self];
    } else if ([self rangeOfString:@"-"].location != NSNotFound)
    {
        NSArray *arr = [s componentsSeparatedByString:@"-"];
        s = [NSString stringWithFormat:@"%@%@", arr[0], [arr[1] firstCharUpper]];
    }
    NSAssert(s != nil, @"key 转换之后为nil");
    return s;
}

- (NSString *)addPrefix:(NSString *)prefix
{
    return [NSString stringWithFormat:@"%@%@", prefix, [self firstCharUpper]];
}

@end
