//
//  TLBookTextView.h
//  TLBookTextView
//
//  Created by TL on 2019/9/19.
//  Copyright © 2019年 yuanqutech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#pragma mark ---TLBookTextViewConfiguration
@interface TLBookTextViewConfiguration : NSObject

@property (nonatomic ,copy  )NSString       *placeText;//占位字符
@property (nonatomic ,copy  )NSString       *text;//内容Content

@property (nonatomic ,strong)UIColor        *bgColor;//背景色
@property (nonatomic ,strong)UIColor        *caretColor;//光标色
@property (nonatomic ,strong)UIColor        *lineColor;//线条色
@property (nonatomic ,strong)UIColor        *textColor;//字色
@property (nonatomic ,strong)UIColor        *placeTextColor;//占位字色

@property (nonatomic ,assign)CGFloat        leftMarginFloat;//首行缩进
@property (nonatomic ,assign)CGFloat        textFontFloat;//字号
@property (nonatomic ,assign)CGFloat        lineBottomEdgeFloat;//线条底部距字顶部距离
@property (nonatomic ,assign)CGFloat        lineHorEdgeFloat;//线条左右边距
@property (nonatomic ,assign)CGFloat        lineHeightFloat;//线条粗度
@property (nonatomic ,assign)CGFloat        lineSpaceLineFloat;//线条之间的距离

@end

#pragma mark ---TLBookTextView
@interface TLBookTextView : UITextView
- (instancetype)initWithFrame:(CGRect)frame configuration:(TLBookTextViewConfiguration *)configuration textBlock:(void(^)(NSString *text))textBlock;
@end

NS_ASSUME_NONNULL_END
