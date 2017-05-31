//
//  UILabel+TextAttribute.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TextAttribute)

/* 设置label文字的指定位置的文字颜色 **/
- (void)setLabelText:(NSString *)str Color:(UIColor *)color Range:(NSRange)range;

@end
