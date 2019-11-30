//
//  HTCartCell.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartCell.h"

@implementation HTCartCell {
    UILabel *_deleteLabel,*_similarLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _countView.resultBlock = ^(NSInteger number, BOOL isAdd) {
        [self.delegate changeGoodsNumberCell:self Number:number];
    };
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
