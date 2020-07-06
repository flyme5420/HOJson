//
//  ConstControllerString.h
//  HOJson
//
//  Created by Chris on 15/8/22.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#ifndef HOJson_ConstControllerString_h
#define HOJson_ConstControllerString_h

#define CONTROLLERH @"//  Created by Chris Hu\n       \
\n                                                      \
\n#import <UIKit/UIKit.h>                               \
\n                                                      \
\n@interface %@ : UIViewController                      \
\n                                                      \
\n@end                                                  \
\n                                                      \
"

#define CONTROLLERM @"//  Created by Chris Hu\n       \
\n                                                    \
\n#import \"%@.h\"                                    \
\n#import \"%@.h\"                                    \
\n#import \"AFNetworking.h\"                            \
\n#import \"DataManager.h\"                           \
\n                                                    \
\n@interface %@ ()<UITableViewDataSource, UITableViewDelegate>                   \
\n{                                                   \
\n}                                                   \
\n@property (strong, nonatomic) IBOutlet UITableView *tableView;  \
\n@property (strong, nonatomic) NSArray *urlArray;                  \
\n@property (strong, nonatomic) NSArray *modelsArray;               \
\n@end                                                            \
\n                                                                \
\n@implementation %@                             \
\n                                                                \
\n- (void)viewDidLoad {                                               \
\n    [super viewDidLoad];                                            \
\n                                                                    \
\n    self.urlArray = @[%@];               \
\n    self.modelsArray = @[%@];               \
\n                                                                    \
\n    NSArray *cellNames = @[%@];                                     \
\n                                                                    \
\n    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain]; \
\n    _tableView.dataSource = self;                                     \
\n    _tableView.delegate = self;                                       \
\n    [self.view addSubview:_tableView];                                \
\n    //注册cell                                                        \
\n    for (int i = 0; i < _urlArray.count; i++) {                         \
\n        NSString *reuseIndetifer = [NSString stringWithFormat:@\"cell%@\", i];            \
\n        NSString *cellName = [NSString stringWithFormat:@\"%@\", cellNames[i]];               \
\n        [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:  reuseIndetifer];                                                    \
\n    }                                                                           \
\n                                                                                \
\n    _tableView.rowHeight = 100;                                                 \
\n                                                                                \
\n    [self startAsyncRequest];                                                   \
\n                                                                                \
\n}                                                                               \
\n                                                                                \
\n- (void)startAsyncRequest                                                       \
\n{                                                                               \
\n    [[DataManager manager] startAsyncRequest:_urlArray modelsArray:_modelsArray refreshHeadler:^(int index) {      \
\n        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:(index)] withRowAnimation: UITableViewRowAnimationAutomatic];                                                  \
\n    } completionHeadler:^{                                                                      \
\n    }];                                                                                         \
\n}                                                                                               \
\n                                                                                                \
\n#pragma mark - Table view data source                                                           \
\n                                                                                                \
\n- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {                             \
\n    return _urlArray.count;                                                                     \
\n}                                                                                               \
\n                                                                                                \
\n- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {      \
\n    id jsonModel = [[DataManager sharedManager].jsonDic objectForKey:@(section)];      \
\n    %@ *model = (%@ *)jsonModel;                                                                \
\n    return model.%@.count;                                                                          \
\n}                                                                                               \
\n                                                                                                \
\n- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    \
\n    NSString *reuseIndentifer = [NSString stringWithFormat:@\"cell%@\", (int)indexPath.section];              \
\n    %@ *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifer forIndexPath:indexPath];        \
\n    id jsonModel = [DataManager sharedManager].jsonDic[@(indexPath.section)];                      \
\n    %@ *model = (%@ *)jsonModel;                                                                \
\n    [cell set%@Info:model.%@[indexPath.row]];                                                                \
\n    return cell;                                                                                            \
\n}                                                                                                           \
\n                                                                                                            \
\n- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath                 \
\n{                                                                                                           \
\n}                                                                                                           \
\n                                                                                                            \
\n@end                                                                                                        \
\n                                                                                                            \
\n"

#define CONTROLLERXIB @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>            \
\n<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.XIB\" version=\"3.0\" toolsVersion=\"6211\" systemVersion=\"14A298i\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">              \
\n<dependencies>                                                                                                            \
\n<plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"6204\"/>                                       \
\n</dependencies>                                                                                                           \
\n<objects>                                                                                                                 \
\n<placeholder placeholderIdentifier=\"IBFilesOwner\" id=\"-1\" userLabel=\"File's Owner\" customClass=\"%@\">         \
\n<connections>                                                                                                             \
\n<outlet property=\"view\" destination=\"i5M-Pr-FkT\" id=\"sfx-zR-JGt\"/>                                                        \
\n</connections>                                                                                                            \
\n</placeholder>                                                                                                            \
\n<placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"-2\" customClass=\"UIResponder\"/>                                 \
\n<view clearsContextBeforeDrawing=\"NO\" contentMode=\"scaleToFill\" id=\"i5M-Pr-FkT\">                                          \
\n<rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>                                                              \
\n<autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>                                         \
\n<color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>                 \
\n</view>                                                                                                                   \
\n</objects>                                                                                                                \
\n</document>                                                                                                               \
\n"

#endif
