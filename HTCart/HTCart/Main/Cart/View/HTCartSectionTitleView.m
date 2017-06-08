//
//  HTCartSectionTitleView.m
//  HTCart
//
//  Created by Huiting Mao on 2017/6/5.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartSectionTitleView.h"

@implementation HTCartSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderColor = BACKGROUND_GRAY_COLOR.CGColor;
    self.layer.borderWidth = 1.0f;
    
    _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [_chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_orderpay_normal"] forState:UIControlStateNormal];
    [_chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_orderpay_selected"] forState:UIControlStateSelected];
    [self addSubview:_chooseButton];
    
    _shopButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 25 - 40, 40)];
    [_shopButton setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    _shopButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _shopButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_shopButton];
    
    _editButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 30, 40)];
//    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_editButton];
}

@end
