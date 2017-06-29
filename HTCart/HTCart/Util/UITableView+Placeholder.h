//
//  UITableView+Placeholder.h
//  HTCart
//
//  Created by Huiting Mao on 2017/6/2.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTablePlaceholderConf;

@interface UITableView (Placeholder)

/** 原始分割线样式*/
@property (assign, nonatomic) UITableViewCellSeparatorStyle originalSeparatorStyle;
/** 原始分割线样式*/
@property (assign, nonatomic) BOOL didSetup;

/** 自定义 placeholder view*/
- (void)placeholderBaseOnNumber:(NSInteger)numberOfRows iconConfig:(void (^) (UIImageView *imageView))iconConfig textConfig:(void (^) (UILabel *label))textConfig;
/** 采用默认 placeholder view*/
- (void)placeholderBaseOnNumber:(NSInteger)numberOfRows withConf:(HTTablePlaceholderConf *)conf;

@end

@interface UITableViewPlaceholderView : UIView

/** 无数据的图片*/
@property (strong, nonatomic) UIImageView *placeholderImageView;
/** 无数据的文本标签*/
@property (strong, nonatomic) UILabel *placeholderLabel;

@end


@interface HTTablePlaceholderConf : NSObject

/** 无数据时的文字提示*/
@property (copy,   nonatomic) NSString *placeholderText;
/** 文字字体，默认15*/
@property (strong, nonatomic) UIFont *placeholderFont;
/** 文字颜色，默认lightGrayColor*/
@property (strong, nonatomic) UIColor *placeholderColor;
/** 无数据时的图片*/
@property (copy, nonatomic) UIImage *placeholderImage;
/** 加载数据时的动画图片*/
@property (copy, nonatomic) NSArray *animImages;
/** 动画时间间隔，默认2s*/
@property (assign, nonatomic) NSTimeInterval animDuration;
/** 是否在加载数据*/
@property (assign, nonatomic) BOOL loadingData;

+ (instancetype)defaultConf;

@end
