//
//  HTNumberButton.h
//  HTCart
//
//  Created by Huiting Mao on 2017/6/8.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTNumberButtonDelegate <NSObject>

@optional

/**
 * 数量加减代理回调
 *
 * @param numberButton  数量按钮
 * @param number        数值
 * @param isAdd         是否为加状态
 *
 */

- (void)ht_numberButton:(__kindof UIView *)numberButton
                 number:(NSInteger)number
                  isAdd:(BOOL)isAdd;

@end

IB_DESIGNABLE
@interface HTNumberButton : UIView

//+ (instancetype)numberButtonWithFrame:(CGRect)frame;

/** 代理方法 */
@property (nonatomic, weak) id<HTNumberButtonDelegate>delegate;

/** 点击加减按钮的block回调 */
@property (nonatomic, copy) void(^resultBlock)(NSInteger number, BOOL isAdd);

#pragma mark - 自定义样式属性

/** 是否可以使用键盘输入,默认YES*/
@property (nonatomic, assign, getter=isSupportKeyboard) IBInspectable BOOL supportKeyboard;

/** 是否开启抖动动画,默认NO*/
@property (nonatomic, assign) IBInspectable BOOL shakeAnimation;

/** 输入框中的内容 */
@property (nonatomic, assign) NSInteger currentNumber;

/** 最小值, 默认为1 */
@property (nonatomic, assign) IBInspectable NSInteger minValue;

/** 最大值 */
@property (nonatomic, assign) NSInteger maxValue;

@property (weak, nonatomic) IBOutlet UIView *view;

@end

#pragma mark - NSString分类
@interface NSString (HTNumberButton)

/**
 *
 *  字符串 nil, @"", @"  ", @"\n" returns NO;
 *  其他 returns YES;
 *
 */
- (BOOL)ht_isNotBlank;

@end
