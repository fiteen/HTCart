//
//  UILabel+TextAttribute.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "UILabel+TextAttribute.h"

@implementation UILabel (TextAttribute)

/* 设置label指定位置的文字颜色 **/
- (void)setLabelText:(NSString *)str Color:(UIColor *)color Range:(NSRange)range {
    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = mutStr;
}

@end
