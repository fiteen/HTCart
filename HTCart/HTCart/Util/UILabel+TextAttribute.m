//
//  UILabel+TextAttribute.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "UILabel+TextAttribute.h"

@implementation UILabel (TextAttribute)

- (void)setLabelWithDelLine {
    NSUInteger length = [self.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:TEXT_GRAY_COLOR range:NSMakeRange(0, length)];
    [self setAttributedText:attri];
}

- (void)setLabelText:(NSString *)str Color:(UIColor *)color Range:(NSRange)range {
    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = mutStr;
}

@end
