//
//  HTCartCell.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCartCell : UITableViewCell

/* 选择按钮 **/
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/* 商品名称 **/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/* 商品数量 **/
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
