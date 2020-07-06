//
//  ConstString.h
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#ifndef HOJson_ConstString_h
#define HOJson_ConstString_h

#define INTERFACE @"\n\n@interface %@ : NSObject\n\n"
#define INTERFACE_END @"+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;\n- (instancetype)initWithDictionary:(NSDictionary *)dict;\n\n@end\n"

#define PROPERTY_COPY @"@property (nonatomic, copy) NSString *%@;\n"
#define PROPERTY_ASSIGN @"@property (nonatomic, assign) double %@;\n"
#define PROPERTY_ARRAY @"@property (nonatomic, strong) NSArray *%@;\n"
#define PROPERTY_DICTIONARY @"@property (nonatomic, strong) %@ *%@;\n"
#define PROPERTY_NULL @"@property (nonatomic, assign) id %@;\n"

#define HEADERFILE @"#import \"%@.h\"\n"
#define FOUNDATION @"#import <Foundation/Foundation.h>\n"

#define PROPERTY_OBJNumber @"          self.%@ = [[self objectOrNilForKey:@\"%@\" fromDictionary:dict] doubleValue];\n"
#define PROPERTY_OBJString @"          self.%@ = [self objectOrNilForKey:@\"%@\" fromDictionary:dict];\n"
#define PROPERTY_OBJDIC @"          self.%@ = [%@ modelObjectWithDictionary:[dict objectForKey:@\"%@\"]];\n"

#define PROPERTY_OBJARRAY @"\n          NSObject *receivedNAME = [dict objectForKey:@\"%@\"];   \
\n          NSMutableArray *parsedNAME = [NSMutableArray array];                    \
\n          if ([receivedNAME isKindOfClass:[NSArray class]]) {                     \
\n              for (NSDictionary *ONE in (NSArray *)receivedNAME) {               \
\n                  if ([ONE isKindOfClass:[NSDictionary class]]) {                     \
\n                      [parsedNAME addObject:[NAME modelObjectWithDictionary:ONE]];    \
\n                  }                                                                   \
\n              }                                                                       \
\n          } else if ([receivedNAME isKindOfClass:[NSDictionary class]]) {             \
\n              [parsedNAME addObject:[NAME modelObjectWithDictionary:(NSDictionary *)receivedNAME]];   \
\n          }                                                                                           \
\n          self.%@ = [NSArray arrayWithArray:parsedNAME];                              \
\n  "


#define MMACRO @"#import \"%@.h\"\n                                     \
\n@interface %@ ()                                                         \
\n                                                                        \
\n- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;   \
\n                                                                        \
\n@end                                                                    \
\n                                                                        \
\n@implementation %@                                               \
\n                                                                        \
\n+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict          \
\n{                                                                   \
\n    return [[self alloc] initWithDictionary:dict];                      \
\n}                                                                   \
\n                                                                        \
\n- (instancetype)initWithDictionary:(NSDictionary *)dict                     \
\n{                                                                       \
\n    self = [super init];                                                        \
\n                                                                            \
\n    if(self && [dict isKindOfClass:[NSDictionary class]]) {                         \
\n%@                                                                      \
\n                                                                                            \
\n    }                                                                                        \
\n                                                                                            \
\n    return self;                                                                            \
\n                                                                                            \
\n}                                                                                           \
\n                                                                                            \
\n- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict                        \
\n{                                                                                           \
\n    id object = [dict objectForKey:aKey];                                                  \
\n    return [object isEqual:[NSNull null]] ? nil : object;                                   \
\n}                                                                                   \
\n                                                                        \
\n@end                                            \
                                            \
" \

#endif
