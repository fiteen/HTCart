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
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            if (subView.subviews.count < 2) {
                return;
            }
            UIView *deleteView = (UIView *)subView.subviews[0];
            deleteView.backgroundColor = [UIColor redColor];
            if (_deleteLabel) {
                [_deleteLabel removeFromSuperview];
            }
            _deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, deleteView.frame.size.width, deleteView.frame.size.height)];
            _deleteLabel.font = [UIFont systemFontOfSize:12];
            _deleteLabel.textColor = [UIColor whiteColor];
            _deleteLabel.textAlignment = NSTextAlignmentCenter;
            _deleteLabel.text = @"删除";
            [deleteView addSubview:_deleteLabel];
            
            UIView *similarView = (UIView *)subView.subviews[1];
            similarView.backgroundColor = RGB(247, 143, 2);
            if (_similarLabel) {
                [_similarLabel removeFromSuperview];
            }
            _similarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, similarView.frame.size.width, similarView.frame.size.height)];
            _similarLabel.font = [UIFont systemFontOfSize:12];
            _similarLabel.textColor = [UIColor whiteColor];
            _similarLabel.textAlignment = NSTextAlignmentCenter;
            _similarLabel.text = @"找相似";
            [similarView addSubview:_similarLabel];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
