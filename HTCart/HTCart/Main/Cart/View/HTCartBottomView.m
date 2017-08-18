//
//  HTCartBottomView.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartBottomView.h"

@implementation HTCartBottomView

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    if (_isEdit) {
        [_settleButton setTitle:@"删除" forState:UIControlStateNormal];
        _totalLabel.hidden = YES;
    } else {
        [_settleButton setTitle:@"结算" forState:UIControlStateNormal];
        _totalLabel.hidden = NO;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"HTCartBottomView" owner:self options:nil];
        _contentView.frame = self.bounds;
        [self addSubview:_contentView];
    }
    return self;
}



@end
