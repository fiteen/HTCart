//
//  UIButton+ImageTitleSpacing.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTButtonEdgeInsetsStyle) {
    HTButtonEdgeInsetsStyleTop, // image在上，label在下
    HTButtonEdgeInsetsStyleLeft, // image在左，label在右
    HTButtonEdgeInsetsStyleBottom, // image在下，label在上
    HTButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(HTButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
