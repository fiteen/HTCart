//
//  HTCartBottomView.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartBottomView.h"

@implementation HTCartBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    _allChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3 - 30, 50)];
    [_allChooseButton setTitle:@"全选" forState:UIControlStateNormal];
    [_allChooseButton setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
    _allChooseButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_allChooseButton setImage:[UIImage imageNamed:@"icon_orderpay_normal"] forState:UIControlStateNormal];
    [_allChooseButton setImage:[UIImage imageNamed:@"icon_orderpay_selected"] forState:UIControlStateSelected];
    [_allChooseButton layoutButtonWithEdgeInsetsStyle:HTButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self addSubview:_allChooseButton];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 - 29, 0, SCREEN_WIDTH / 3 + 30, 50)];
    _totalLabel.textColor = [UIColor redColor];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_totalLabel];
    
    _settleButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2 / 3, 0, SCREEN_WIDTH / 3, 50)];
    [_settleButton setTitle:@"结算" forState:UIControlStateNormal];
    [_settleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settleButton.backgroundColor = BUTTON_RED_COLOR;
    [self addSubview:_settleButton];
}

@end
