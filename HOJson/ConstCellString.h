//
//  ConstCellString.h
//  HOJson
//
//  Created by Chris on 15/8/22.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#ifndef HOJson_ConstCellString_h
#define HOJson_ConstCellString_h

#define ImagePrefix @"http"
#define CELLPROPERTY @"@property (strong, nonatomic) IBOutlet %@ *%@;\n"
#define UIKIT @"#import <UIKit/UIKit.h>\n#import \"UIImageView+AFNetworking.h\"\n"

#define CELLHFILE @"\n                        \
\n                                              \
\n@interface %@ : UITableViewCell           \
\n                                                  \
\n%@                                                            \
\n                                                              \
\n- (void)setCell:(%@ *)%@;                                    \
\n                                                              \
\n@end                                                          \
\n"                                                              \


#define CELLMFILE @"\n        \
\n                              \
\n#import \"%@.h\"                \
\n                                      \
\n@implementation %@            \
\n                                      \
\n- (void)awakeFromNib {                    \
\n    // Initialization code            \
\n}                                     \
\n                                          \
\n- (void)setSelected:(BOOL)selected animated:(BOOL)animated {  \
\n    [super setSelected:selected animated:animated];           \
\n}                                                              \
\n                                                              \
\n- (void)setCell:(%@ *)%@                                  \
\n{                                                             \
\n     %@                                                            \
\n}                                                              \
\n@end                                                            \
\n"                                                                   \

#define CELLXIB @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>       \
\n<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.XIB\" version=\"3.0\" toolsVersion=\"7706\" systemVersion=\"14F27\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">       \
\n    <dependencies>       \
\n        <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"7703\"/>       \
\n    </dependencies>       \
\n    <objects>       \
\n        <placeholder placeholderIdentifier=\"IBFilesOwner\" id=\"-1\" userLabel=\"File's Owner\"/>       \
\n        <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"-2\" customClass=\"UIResponder\"/>       \
\n        <tableViewCell contentMode=\"scaleToFill\" selectionStyle=\"default\" indentationWidth=\"10\" rowHeight=\"100\" id=\"KGk-i7-Jjw\" customClass=\"%@\">       \
\n            <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"320\" height=\"100\"/>       \
\n            <autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>       \
\n            <tableViewCellContentView key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" tableViewCell=\"KGk-i7-Jjw\" id=\"H2p-sc-9uM\">       \
\n                <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"320\" height=\"43\"/>       \
\n                <autoresizingMask key=\"autoresizingMask\"/>       \
\n                <subviews>       \
\n                    <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"sjF-z3-DW2\">       \
\n                        <rect key=\"frame\" x=\"147\" y=\"8\" width=\"165\" height=\"21\"/>       \
\n                        <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>       \
\n                        <color key=\"textColor\" cocoaTouchSystemColor=\"darkTextColor\"/>       \
\n                        <nil key=\"highlightedColor\"/>       \
\n                    </label>       \
\n                    <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"tcz-C3-wvx\">       \
\n                        <rect key=\"frame\" x=\"8\" y=\"4\" width=\"131\" height=\"90.5\"/>       \
\n                    </imageView>       \
\n                </subviews>       \
\n            </tableViewCellContentView>       \
\n            <point key=\"canvasLocation\" x=\"543\" y=\"403\"/>       \
\n        </tableViewCell>       \
\n    </objects>       \
\n</document>       \
\n"


#define AFNIMAGE @"     [_%@ setImageWithURL:[NSURL URLWithString:%@.%@]];\n"
#define SETVALUE @"     _%@.text = %@.%@;\n"
#define SETVALUENUMBER @"     _%@.text = [NSString stringWithFormat:@\"%@\", %@.%@];\n"
#endif




