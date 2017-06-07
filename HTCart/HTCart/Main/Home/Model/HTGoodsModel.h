//
//  HTGoodsModel.h
//  HTCart
//
//  Created by Huiting Mao on 2017/6/5.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTGoodsModel : NSObject

/** 商品id */
@property (nonatomic, copy) NSString *goods_id;

/** 商品名称 */
@property (nonatomic, copy) NSString *goods_name;

/** 店铺id */
@property (nonatomic, copy) NSString *shop_id;

/** 店铺名称 */
@property (nonatomic, copy) NSString *shop_name;

/** 商品图片 */
@property (nonatomic, copy) NSString *goods_image;

/** 商品属性 */
@property (nonatomic, copy) NSString *goods_property;

/** 商品限购 */
@property (nonatomic, copy) NSString *goods_limit;

/** 原价 */
@property (nonatomic, copy) NSNumber *original_price;

/** 现价 */
@property (nonatomic, copy) NSNumber *current_price;

@end
