//
//  UILabel+TextAttribute.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TextAttribute)

/** 设置label带有删除线*/
- (void)setLabelWithDelLine;

/** 
 * 设置label文字的指定位置的文字颜色
 *
 * @param str        标签文本
 * @parma color      指定位置文本的颜色
 * @parma range      标签指定位置
 *
 */
- (void)setLabelText:(NSString *)str Color:(UIColor *)color Range:(NSRange)range;

@end
