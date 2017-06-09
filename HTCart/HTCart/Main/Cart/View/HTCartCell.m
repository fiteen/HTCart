//
//  HTCartCell.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartCell.h"

@implementation HTCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _countView.resultBlock = ^(NSInteger number, BOOL isAdd) {
        [self.delegate ChangeGoodsNumberCell:self Number:number];
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
