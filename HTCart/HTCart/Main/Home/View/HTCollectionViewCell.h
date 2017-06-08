//
//  HTCollectionViewCell.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCollectionViewCell : UICollectionViewCell

/** 商品图片 */
@property (nonatomic, strong) UIImageView *imageView;

/** 价格标签 */
@property (nonatomic, strong) UILabel *priceLabel;

/** 加入购物车按钮 */
@property (nonatomic, strong) UIButton *buyButton;

@end
