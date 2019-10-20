//
//  TLBookTextView.m
//  TLBookTextView
//
//  Created by libin on 2019/9/19.
//  Copyright © 2019年 yuanqutech. All rights reserved.
//
#define TLColor_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "TLBookTextView.h"

#pragma mark ---TLBookTextViewConfiguration
@interface TLBookTextViewConfiguration ()
@end
@implementation TLBookTextViewConfiguration
- (instancetype)init{
    if (self = [super init]) {
        
        self.placeText      = @"请输入您的内容";
        self.text           = @"吴亦凡是我表哥吴亦凡是我表哥吴亦凡是我表哥吴亦凡是我表哥吴亦凡是我表哥";
        self.bgColor        = TLColor_RGB(255,255,224);
        self.caretColor     = TLColor_RGB(220,20,60);
        self.lineColor      = TLColor_RGB(255,69,0);
        self.textColor      = TLColor_RGB(105,105,105);
        self.placeTextColor = TLColor_RGB(169,169,169);
        
        self.leftMarginFloat        = 18 *2;//18 *2;
        self.textFontFloat          = 18;
        self.lineBottomEdgeFloat    = (60 -15)/2.0;
        self.lineHorEdgeFloat       = 15;
        self.lineHeightFloat        = 1;
        self.lineSpaceLineFloat     = 60;
        
    }
    return self;
}

@end


#pragma mark ---TLBookTextView
@interface TLBookTextView ()<UITextViewDelegate ,UITextInput>

@property (nonatomic,strong)TLBookTextViewConfiguration     *configuration;
@property (nonatomic ,copy)void (^textBlock)(NSString *text);
@property (nonatomic,strong)UILabel                         *placeLab;
@property (nonatomic,assign)CGRect                           layerRect;
@property (nonatomic,strong)NSMutableArray                  *layerMutArr;
@end

@implementation TLBookTextView

- (instancetype)initWithFrame:(CGRect)frame configuration:(TLBookTextViewConfiguration *)configuration textBlock:(void(^)(NSString *text))textBlock{
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.configuration = configuration;
        self.textBlock = textBlock;

        self.layerRect = self.bounds;
        self.layerMutArr = [NSMutableArray new];
        
        self.placeLab = [UILabel new];
        self.placeLab.text = self.configuration.placeText;
        self.placeLab.textColor = self.configuration.placeTextColor;
        self.placeLab.frame = CGRectMake(self.configuration.lineHorEdgeFloat +5 +self.configuration.leftMarginFloat, self.configuration.lineBottomEdgeFloat, frame.size.width -self.configuration.lineHorEdgeFloat *2, self.configuration.textFontFloat);
        [self addSubview:self.placeLab];
        self.placeLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
        [self.placeLab addGestureRecognizer:tap];
        
        
        self.backgroundColor = self.configuration.bgColor;
        self.tintColor = self.configuration.caretColor;
        self.textColor = self.configuration.textColor;
        self.textContainerInset = UIEdgeInsetsMake(self.configuration.lineBottomEdgeFloat,self.configuration.lineHorEdgeFloat, self.configuration.lineBottomEdgeFloat, self.configuration.lineHorEdgeFloat);
        
        self.font = [UIFont systemFontOfSize:self.configuration.textFontFloat];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        //(字间距) -（文本所占区域点高度 -文本点高度）
        paragraphStyle.lineSpacing = (self.configuration.lineSpaceLineFloat -self.configuration.textFontFloat) -(self.font.lineHeight -self.configuration.textFontFloat);
        paragraphStyle.firstLineHeadIndent = self.configuration.leftMarginFloat;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.configuration.textFontFloat],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:self.configuration.textColor
                                     };
        
        self.typingAttributes = attributes;
        
        if (self.configuration.text.length >0) {
            self.attributedText = [[NSAttributedString alloc]initWithString:self.configuration.text attributes:attributes];
            self.placeLab.hidden = YES;
        }
        
        
        UIView *containerView = self.subviews[0];
        [containerView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self tl_layoutContent];
    }
    return self;
}
// 光标的大小
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.origin = CGPointMake(originalRect.origin.x, originalRect.origin.y +1);
    originalRect.size.height = self.configuration.textFontFloat;
    originalRect.size.width = 1;
    
    return originalRect;
}
- (void)btnClick{
    [self becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView{

    if (!textView.text.length) {
        self.placeLab.hidden = NO;
        self.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:self.typingAttributes];
    } else {
        self.placeLab.hidden = YES;
    }
    if (self.textBlock) {
        self.textBlock(textView.text);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)contex{

    if ([@"frame" isEqualToString:keyPath] && [object valueForKeyPath:keyPath] != [NSNull null]) {
        CGRect rect = [[change valueForKey:@"new"] CGRectValue];
        if (rect.size.height > self.frame.size.height) {
            self.layerRect = rect;
        }else{
            self.layerRect = self.bounds;
        }
        [self tl_layoutContent];
    }
}
- (void)dealloc{
    UIView *containerView = self.subviews[0];
    [containerView removeObserver:self forKeyPath:@"frame"];
}

- (void)tl_layoutContent{
    UIView *containerView = self.subviews[0];
    [self.layerMutArr makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSInteger count = self.layerRect.size.height/self.configuration.lineSpaceLineFloat;
    for (int i = 1; i <= count; i ++) {
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(self.configuration.lineHorEdgeFloat, self.configuration.lineSpaceLineFloat *i)];
        [linePath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) -self.configuration.lineHorEdgeFloat, self.configuration.lineSpaceLineFloat *i)];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = self.configuration.lineHeightFloat;
        lineLayer.strokeColor = self.configuration.lineColor.CGColor;
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = nil; // 默认为blackColor
        
        [containerView.layer addSublayer:lineLayer];
        [self.layerMutArr addObject:lineLayer];
    }
}

@end
