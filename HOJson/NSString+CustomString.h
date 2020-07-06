//
//  NSString+CustomString.h
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NEWID @"getNewid"
#define NEWDESC @"desc"
#define NEW @"getNew"

@interface NSString (CustomString)

- (NSString *)firstCharUpper;
- (NSString *)firstCharlower;
- (NSString *)includeFile;
- (NSString *)mfile;
- (NSString *)xibfile;
- (NSString *)convertkey;
- (NSString *)addPrefix:(NSString *)prefix;

@end
