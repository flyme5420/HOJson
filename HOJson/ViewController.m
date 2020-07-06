//
//  ViewController.m
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import "ViewController.h"
#import "ConstString.h"
#import "ConstCellString.h"
#import "ConstControllerString.h"
#import "ConstSingleton.h"
#import "ConstPodfile.h"
#import "NSString+CustomString.h"
#import "NSDictionary+CustomDictionary.h"

@interface ViewController ()<NSTextViewDelegate>
{
    NSFileManager *_fm;
    NSMutableDictionary *_filesDictionary;
    NSDictionary *_tmpDictionary;
    NSString *_keypath;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fm = [NSFileManager defaultManager];
    _filesDictionary = [[NSMutableDictionary alloc]init];
    
    NSMutableSet *set = [NSMutableSet set];
    [set addObject:@"12"];
    [set addObject:@"12"];
    NSLog(@"set:%@", set);
    
    _jsonTextView.delegate = self;

//    NSLog(@"%@", ms);
//    NSDictionary *dic1 = @{@"d1":@{@"i": @"o"}, @"a":@"1"};
//    NSDictionary *dic2 = @{@"d1":@{@"i1": @"o1"}, @"b":@"2"};
//    NSDictionary *dic3 = [dic1 mergeDictionary:dic2];
//    NSLog(@"dic:%@", dic3);
}

//手动粘贴
- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    NSData *data = [replacementString dataUsingEncoding:NSUTF8StringEncoding];
    if ([replacementString isEqualToString:@""]) {
        return YES;
    }else{
        NSError *err;
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            [self alertWithView:_jsonErrLabel];
            return NO;
        }
    }
    [self generateFilesAndRadioDictionary:data];
    return YES;
}

- (NSString *)filePathWithName:(NSString *)filename  hasPrefix:(BOOL)hasPrefix
{
    NSString *prefixStr = (hasPrefix ? _prefix.stringValue : @"");
    NSString *prefixFilename = [NSString stringWithFormat:@"%@%@", prefixStr, filename];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pathString = [path stringByAppendingPathComponent:@"MVC"];
    if (![_fm createDirectoryAtPath:pathString withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSLog(@"model目录创建失败，已经存在");
    }
    NSString *filePath = [pathString stringByAppendingPathComponent:prefixFilename];
    if (![_fm fileExistsAtPath:filePath]) {
        [_fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

- (void)appString:(NSString *)s toPath:(NSString *)filename position:(POSITION)position hasPrefix:(BOOL)hasPrefix
{
    
    NSString *filePath = [self filePathWithName:filename hasPrefix:hasPrefix];
    
    NSFileHandle  *outFile;
    NSData *buffer;
    
    outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    if(outFile == nil)
    {
        NSLog(@"Open of file for writing failed");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
//    if (position == BEGIN) {
//        [outFile seekToFileOffset:0];
//    } else {
        [outFile seekToEndOfFile];
//    }
    
    //读取inFile并且将其内容写到outFile中
    NSString *bs = [NSString stringWithFormat:@"%@",s];
    buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
    
    [outFile writeData:buffer];  
    
    //关闭读写文件  
    [outFile closeFile];  
    
}

- (void)writeFileWithProperty:(NSString *)propertyStr key:(NSString *)key filename:(NSString *)name
{
    NSString *tmpStr;
    if ([propertyStr isEqualToString:PROPERTY_DICTIONARY]) {
        NSString *className = [key firstCharUpper];
        tmpStr = [NSString stringWithFormat:propertyStr, [className addPrefix:_prefix.stringValue], key];
    } else {
        tmpStr = [NSString stringWithFormat:propertyStr, [key convertkey]];
    }
    [self appString:tmpStr toPath:[name includeFile] position:END hasPrefix:YES];

}

- (void)writeFileWithHeader:(NSString *)header filename:(NSString *)filename
{
    NSString *aheader = [NSString stringWithFormat:INTERFACE, [header addPrefix:_prefix.stringValue]];
    [self appString:aheader toPath:[filename includeFile]  position:END hasPrefix:YES];
}

- (void)writeFileWithEnd:(NSString *)end filename:(NSString *)filename
{
    [self appString:INTERFACE_END toPath:[filename includeFile]  position:END hasPrefix:YES];
}

- (void)importHeaderFileFromJson:(NSDictionary *)dic filename:(NSString *)filename
{
    [self appString:FOUNDATION toPath:[filename includeFile] position:END hasPrefix:YES];
    for (NSString *key in dic) {
        id obj = dic[key];
        if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSArray class]]) {
            if ([obj isKindOfClass:[NSArray class]]) {
                //如果数组里面包含的是NSString，或NSNumber，则不用包含头文件
                if ([(NSArray *)obj count] == 0) {
                    continue;
                }
                else if ([[(NSArray *)obj firstObject] isKindOfClass:[NSString class]]|| [[(NSArray *)obj firstObject] isKindOfClass:[NSNumber class]]) {
                    continue;
                }
            }
            [self appString:[NSString stringWithFormat:HEADERFILE, [[key firstCharUpper] addPrefix:_prefix.stringValue]] toPath:[filename includeFile] position:END hasPrefix:YES];
        }
    }
}

- (void)createMfile:(NSDictionary *)jsondic filename:(NSString *)filename
{
    NSMutableString *mStr = [NSMutableString string];
    [jsondic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *s;
        if ([obj isKindOfClass:[NSString class]])
        {
            s = [NSString stringWithFormat:PROPERTY_OBJString, [key convertkey], key];
        }
        else if ([obj isKindOfClass:[NSNumber class]])
        {
            s = [NSString stringWithFormat:PROPERTY_OBJNumber, [key convertkey], key];
        }
        else if ([obj isKindOfClass:[NSDictionary class]])
        {
            s = [NSString stringWithFormat:PROPERTY_OBJDIC, key, [[key firstCharUpper] addPrefix:_prefix.stringValue], key];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            if ([(NSArray *)obj count] == 0) {
                s = [NSString stringWithFormat:PROPERTY_OBJString, key, key];
            }
            else if ([[(NSArray *)obj firstObject] isKindOfClass:[NSNumber class]] || [[(NSArray *)obj firstObject] isKindOfClass:[NSString class]]) {
                s = [NSString stringWithFormat:PROPERTY_OBJString, key, key];
            } else {
                s = [NSString stringWithFormat:PROPERTY_OBJARRAY, key, key];
                NSMutableString *ms = [NSMutableString stringWithString:s];
                [ms replaceOccurrencesOfString:@"NAME" withString:[[key firstCharUpper] addPrefix:_prefix.stringValue] options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
                [ms replaceOccurrencesOfString:@"ONE" withString:key options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
                s = ms;
            }
        }
        else if ([obj isKindOfClass:[NSNull class]])
        {
            s = [NSString stringWithFormat:PROPERTY_OBJString, key, key];
        }
        
        [mStr appendString:s];
    }];
    NSString *contentStr = [NSString stringWithFormat:MMACRO, [filename addPrefix:_prefix.stringValue], [filename addPrefix:_prefix.stringValue], [filename addPrefix:_prefix.stringValue], mStr];
    [self appString:contentStr toPath:[filename mfile] position:BEGIN hasPrefix:YES];
}

- (void)mergeDictionaryToFileDictionary:(NSDictionary *)dic key:(NSString *)key
{
    if (_filesDictionary[key] == nil) {
        _filesDictionary[key] = dic;
    }else{
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:_filesDictionary[key]];
        mdic = [mdic mergeDictionary:dic];
        _filesDictionary[key] = mdic;
    }
}

//需要创建文件的信息 储存在文件字典中
- (void)filesDictionary:(NSDictionary *)jsondic
{
    if (_filesDictionary[@"DataModel"] == nil) {
        _filesDictionary[@"DataModel"] = jsondic;
    }
    [jsondic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]])
        {
            if ([(NSArray *)obj count] > 0) {
                id aobj = [(NSArray *)obj firstObject];
                if ([aobj isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                    for (NSDictionary *dic in (NSArray *)obj) {
                        mdic = [mdic mergeDictionary:dic];
                    }
                    NSString *newFilename = [key firstCharUpper];
//                    _filesDictionary[newFilename] = mdic;
                    [self mergeDictionaryToFileDictionary:mdic key:newFilename];
                    [self filesDictionary:mdic];
                }
            }
        }
        else if ([obj isKindOfClass:[NSDictionary class]]){
            NSString *newFilename = [key firstCharUpper];
            //需要创建文件的信息 储存在文件字典中
//            _filesDictionary[newFilename] = obj;
            [self mergeDictionaryToFileDictionary:obj key:newFilename];
            [self filesDictionary:obj];
        }
    }];

}

- (void)createFileWithDictionary:(NSDictionary *)jsondic
{
    [jsondic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        //在文件中添加头文件
        [self importHeaderFileFromJson:obj filename:key];
        //将类头写进去
        [self writeFileWithHeader:key filename:key];
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *skey, id sobj, BOOL *stop) {
            if ([sobj isKindOfClass:[NSNumber class]])
            {
                [self writeFileWithProperty:PROPERTY_ASSIGN key:skey filename:key];
            }
            else if ([sobj isKindOfClass:[NSString class]])
            {
                [self writeFileWithProperty:PROPERTY_COPY key:skey filename:key];
            }
            else if ([sobj isKindOfClass:[NSArray class]])
            {
                [self writeFileWithProperty:PROPERTY_ARRAY key:skey filename:key];
            }
            else if ([sobj isKindOfClass:[NSDictionary class]]){
                [self writeFileWithProperty:PROPERTY_DICTIONARY key:skey filename:key];
            }
            else if ([sobj isKindOfClass:[NSNull class]])
            {
                [self writeFileWithProperty:PROPERTY_NULL key:skey filename:key];
            }
//            else {
//                [self writeFileWithProperty:PROPERTY_NULL key:skey filename:key];
//            }
        }];
        [self writeFileWithEnd:INTERFACE_END filename:key];
        //创建.m文件
        [self createMfile:obj filename:key];

    }];
}

NSString* encodeURL(NSString* dString ) {
    NSString *encodedString = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)dString,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8);
    return encodedString;
}

- (void)generateFilesAndRadioDictionary:(NSData *)data
{
    NSDictionary *dic = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)jsonObj;
    } else if ([jsonObj isKindOfClass:[NSArray class]]) {
        dic = @{@"BaseClass": jsonObj};
    } else {
        NSAssert(NO, @"json not dictionary or array");
    }
    
    [_filesDictionary removeAllObjects];
    
    _tmpDictionary = dic;
    
    //生成文件字典
    [self filesDictionary:dic];
    //显示字典radio信息
    [self setRadioWithFileDictionary:_filesDictionary];
}

- (void)setRadioWithFileDictionary:(NSDictionary *)filesDictionary
{
    //初始化radio group
    NSMutableArray *cellTitles = [NSMutableArray array];
    [filesDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [cellTitles addObject:key];
    }];
    int num = (int)[_radio numberOfRows];
    for (int i = num-1; i > 0; i--) {
        [_radio removeRow:i];
    }
    
    for (int i = 0; i < cellTitles.count-1; i++) {
        [_radio addRow];
    }
    NSArray *cellArray = [_radio cells];
    for (int i = 0; i < cellTitles.count; i++) {
        [[cellArray objectAtIndex:i] setTitle:cellTitles[i]];
    }
}

#pragma mark - Clicked Event

- (IBAction)onClickedSendRequest:(NSButton *)sender {
    NSString *input = encodeURL(_urlText.stringValue);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:input]];
    [_progressIndicator startAnimation:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [_progressIndicator stopAnimation:nil];
        if (connectionError) {
            NSLog(@"err:%@", connectionError);
            [self alertWithView:_errLabel];
        } else {
            _jsonTextView.string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self generateFilesAndRadioDictionary:data];
        }
    }];
}

- (void)alertWithView:(NSView *)view
{
    [view setHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view setHidden:YES];
    });
}

- (IBAction)onClickedGenerat:(NSButton *)sender {
    
    if ([_jsonTextView.string isEqualToString:@""]) {
        return;
    }
    //根据文件字典创建所有文件
    [self createFileWithDictionary:_filesDictionary];
    
    //创建model单例
//    NSString *dataModelStr = [NSString stringWithFormat:@"%@%@", _prefix.stringValue, @"DataModel"];
//    NSString *singlehContent = [NSString stringWithFormat:SINGLEH, dataModelStr];
//    
//    [self appString:singlehContent toPath:@"DataManager.h" position:END hasPrefix:NO];
//    [self appString:SINGLEM toPath:@"DataManager.m" position:END hasPrefix:NO];
}

- (IBAction)onCreateController:(NSButton *)sender {
    if ([_cellText.stringValue isEqualToString:@""]) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"@\"%@\"", _urlText.stringValue];
    NSString *modelArrayStr = [NSString stringWithFormat:@"@\"%@DataModel\"", _prefix.stringValue];
    NSString *modelClassStr = [NSString stringWithFormat:@"%@DataModel", _prefix.stringValue];
    NSString *cellsArrayStr = [NSString stringWithFormat:@"@\"%@\"", _cellText.stringValue];
    NSCell *cell = [_radio selectedCell];
    NSString *modelName = cell.title;
    
    NSString *keyPath = [_tmpDictionary getKeyPathWithKey:[modelName firstCharlower]];
    
    NSString *controllerStr = [NSString stringWithFormat:CONTROLLERM, _controllerText.stringValue, _cellText.stringValue, _controllerText.stringValue, _controllerText.stringValue, urlstr, modelArrayStr, cellsArrayStr, @"%d", @"%@", modelClassStr, modelClassStr, keyPath, @"%d", _cellText.stringValue, modelClassStr, modelClassStr, _cellText.stringValue, keyPath];
    //生成m文件
    [self appString:controllerStr toPath:[_controllerText.stringValue mfile] position:END hasPrefix:NO];
    //生成h文件
    NSString *controllerhStr = [NSString stringWithFormat:CONTROLLERH, _controllerText.stringValue];
    [self appString:controllerhStr toPath:[_controllerText.stringValue includeFile] position:BEGIN hasPrefix:NO];
    //生成xib文件
    NSString *controllerXibStr = [NSString stringWithFormat:CONTROLLERXIB, _controllerText.stringValue];
    [self appString:controllerXibStr toPath:[_controllerText.stringValue xibfile] position:BEGIN hasPrefix:NO];
    //生成Podfile文件
    [self appString:PODFILE toPath:@"Podfile" position:BEGIN hasPrefix:NO];
}

- (IBAction)onCreateCell:(NSButton *)sender {
    //获取选中的cell
    NSCell *cell = [_radio selectedCell];
    NSString *modelName = cell.title;
    
    NSString *cellName = _cellText.stringValue;
    //生成cell的h文件
    [self appString:UIKIT toPath:[cellName includeFile] position:BEGIN hasPrefix:NO];
    [self appString:[NSString stringWithFormat:HEADERFILE, [modelName addPrefix:_prefix.stringValue]] toPath:[cellName includeFile] position:BEGIN hasPrefix:NO];
//    [self importHeaderFileFromJson:_filesDictionary[modelName] filename:cellName];
    //增加属性
    NSMutableString *propertyStr = [NSMutableString string];
    NSDictionary *propertyDic = _filesDictionary[modelName];
    [propertyDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            NSString *newString = [NSString stringWithFormat:@"%@", obj];
            NSString *pStr;
            if ([newString length] > 9 && [newString hasPrefix:ImagePrefix]) {
                pStr = [NSString stringWithFormat:CELLPROPERTY, @"UIImageView", [key convertkey]];
            }else{
                pStr = [NSString stringWithFormat:CELLPROPERTY, @"UILabel", [key convertkey]];
            }
            [propertyStr appendString:pStr];
        }
    }];
    
    NSString *hconentString = [NSString stringWithFormat:CELLHFILE, cellName, propertyStr, [modelName addPrefix:_prefix.stringValue], [modelName lowercaseString]];
    [self appString:hconentString toPath:[cellName includeFile] position:BEGIN hasPrefix:NO];
    
    //生成cell的m文件
    //cell赋值
    NSMutableString *propertyInitStr = [NSMutableString string];
    [propertyDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            NSString *newString = [NSString stringWithFormat:@"%@", obj];
            NSString *pStr;
            if ([newString length] > 9 && [newString hasPrefix:ImagePrefix]) {
                pStr = [NSString stringWithFormat:AFNIMAGE, [key convertkey], [modelName lowercaseString], [key convertkey]];
            }else{
                if ([obj isKindOfClass:[NSNumber class]]) {
                    pStr = [NSString stringWithFormat:SETVALUENUMBER, [key convertkey], @"%f", [modelName lowercaseString], [key convertkey]];
                }else
                {
                    pStr = [NSString stringWithFormat:SETVALUE, [key convertkey], [modelName lowercaseString], [key convertkey]];
                }
            }
            [propertyInitStr appendString:pStr];
        }
    }];
    
    NSString *mconentString = [NSString stringWithFormat:CELLMFILE, cellName, cellName, [modelName addPrefix:_prefix.stringValue], [modelName lowercaseString], propertyInitStr];
    [self appString:mconentString toPath:[cellName mfile] position:BEGIN hasPrefix:NO];
    
    //生成cell的xib文件
    NSString *xibString = [NSString stringWithFormat:CELLXIB, cellName];
    [self appString:xibString toPath:[cellName xibfile] position:END hasPrefix:NO];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
