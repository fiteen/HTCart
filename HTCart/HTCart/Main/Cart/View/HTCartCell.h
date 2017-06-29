//
//  HTCartCell.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNumberButton.h"

@protocol HTCartCellDelegate <NSObject>

/**
 * 修改商品数量
 */
- (void)changeGoodsNumberCell:(UITableViewCell *)cell Number:(NSInteger)num;

@end

@interface HTCartCell : UITableViewCell

/** 选择按钮*/
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
/** 商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/** 商品名称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 商品属性*/
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;
/** 商品限购*/
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
/** 商品现价*/
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
/** 商品原价*/
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
/** 商品数量*/
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
/** 修改商品数量*/
@property (weak, nonatomic) IBOutlet HTNumberButton *countView;
/** 修改按钮标签*/
@property (weak, nonatomic) IBOutlet UILabel *propertyEditLabel;
/** 修改属性按钮*/
@property (weak, nonatomic) IBOutlet UIButton *propertyEditButton;
/** 删除按钮*/
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
/** 代理*/
@property (nonatomic, weak)id<HTCartCellDelegate> delegate;


@end
