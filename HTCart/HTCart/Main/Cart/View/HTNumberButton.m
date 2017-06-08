//
//  HTNumberButton.m
//  HTCart
//
//  Created by Huiting Mao on 2017/6/8.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTNumberButton.h"

#ifdef DEBUG
#define HTLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define HTLog(...)
#endif

@interface HTNumberButton ()<UITextFieldDelegate>

/** 减按钮 */
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;

/** 加按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;

/** 数字显示/输入框 */
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

/** 快速加减定时器*/
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HTNumberButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"HTNumberButton" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}

#pragma mark - 输入框中的内容设置
- (NSInteger)currentNumber {
    return _numberTextField.text.integerValue;
}

- (void)setCurrentNumber:(NSInteger)currentNumber {
    _numberTextField.text = [NSString stringWithFormat:@"%ld",currentNumber];
//    [self checkNumberWhenUpdate];
}

/**
 *  点击: 单击逐次减少,长按连续快速减少
 */
- (IBAction)subtractTouchDown:(id)sender {
    [_numberTextField resignFirstResponder];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(subtractAction) userInfo:nil repeats:YES];
    [_timer fire];
}

/**
 *  点击: 单击逐次增加,长按连续快速增加
 */
- (IBAction)addTouchDown:(id)sender {
    [_numberTextField resignFirstResponder];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(addAction) userInfo:nil repeats:YES];
    [_timer fire];
}

/**
 *  手指松开
 */
- (IBAction)TouchUp:(id)sender {
    [self invalidateTimer];
}

/**
 *  减运算
 */
- (void)subtractAction {
    [self checkNumberWhenUpdate];
    
    NSInteger number = [_numberTextField.text integerValue] - 1;
    
    if (number >= _minValue) {
        _numberTextField.text = [NSString stringWithFormat:@"%ld", number];
        [self buttonClickCallBackWithAddAction:NO];
    } else {
       if (_shakeAnimation) {
           [self shakeAnimationMethod];
       }
        HTLog(@"数量不能小于%ld",_minValue);
    }
}

/**
 *  加运算
 */
- (void)addAction {
    [self checkNumberWhenUpdate];
    
    NSInteger number = _numberTextField.text.integerValue + 1;
    
    if (number <= _maxValue) {
        _numberTextField.text = [NSString stringWithFormat:@"%ld", number];
        
        [self buttonClickCallBackWithAddAction:YES];
    }
    else {
        if (_shakeAnimation) {
            [self shakeAnimationMethod];
        }
        HTLog(@"已超过最大数量%ld",_maxValue);
    }
}

/**
 *  销毁定时器
 */
- (void)invalidateTimer {
    if (_timer.isValid) {
        [_timer invalidate] ;
        _timer = nil; }
}

/**
 *  响应
 */
- (void)buttonClickCallBackWithAddAction:(BOOL)addStatus {
    _resultBlock ? _resultBlock(_numberTextField.text.integerValue, addStatus) : nil;
    if ([_delegate respondsToSelector:@selector(ht_numberButton: number: isAdd:)]) {
        [_delegate ht_numberButton:self number:_numberTextField.text.integerValue isAdd:addStatus];
    }
}

/**
 *  检查TextField中数字的合法性,并修正
 */
- (void)checkNumberWhenUpdate {
    NSString *minValueString = [NSString stringWithFormat:@"%ld",_minValue];
    NSString *maxValueString = [NSString stringWithFormat:@"%ld",_maxValue];
    
    if ([_numberTextField.text ht_isNotBlank] == NO || _numberTextField.text.integerValue < _minValue) {
        _numberTextField.text = minValueString;
    }
    _numberTextField.text.integerValue > _maxValue ? _numberTextField.text = maxValueString : nil;
}

#pragma mark - 核心动画
/**
 *  抖动动画
 */
- (void)shakeAnimationMethod {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    CGFloat positionX = self.layer.position.x;
    animation.values = @[@(positionX-10),@(positionX),@(positionX+10)];
    animation.repeatCount = 3;
    animation.duration = 0.07;
    animation.autoreverses = YES;
    [self.layer addAnimation:animation forKey:nil];
}

@end

#pragma mark - NSString 分类

@implementation NSString (HTNumberButton)

- (BOOL)ht_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

@end
