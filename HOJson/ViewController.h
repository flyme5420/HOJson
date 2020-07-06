//
//  ViewController.h
//  HOJson
//
//  Created by Chris on 15/8/15.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum : NSUInteger {
    BEGIN,
    END,
} POSITION;

@interface ViewController : NSViewController

//@property (strong) IBOutlet NSScrollView *jsonText;
@property (strong) IBOutlet NSTextView *jsonTextView;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;
@property (strong) IBOutlet NSTextField *errLabel;
@property (strong) IBOutlet NSTextField *urlText;
@property (strong) IBOutlet NSTextField *prefix;
@property (strong) IBOutlet NSTextField *controllerText;
@property (strong) IBOutlet NSTextField *cellText;
@property (strong) IBOutlet NSMatrix *radio;
//- (NSString *)addPrefix;
@property (strong) IBOutlet NSTextField *jsonErrLabel;

@end