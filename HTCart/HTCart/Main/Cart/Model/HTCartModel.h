//
//  HTCartModel.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCartModel : NSObject

/** 店铺名称 */
@property (nonatomic, copy) NSString *shop_name;

/** 商品名称 */
@property (nonatomic, copy) NSString *goods_name;

/** 商品图片 */
@property (nonatomic, copy) NSString *goods_image;

/** 原价 */
@property (nonatomic, assign) NSNumber *original_price;

/** 现价 */
@property (nonatomic, assign) NSNumber *current_price;

@end
