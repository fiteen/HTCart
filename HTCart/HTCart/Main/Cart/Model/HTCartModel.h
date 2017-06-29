//
//  HTCartModel.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTCartDetailModel;

@interface HTCartModel : NSObject

/** 店铺id*/
@property (nonatomic, copy) NSString *shop_id;
/** 店铺名称*/
@property (nonatomic, copy) NSString *shop_name;
/** 商品清单*/
@property (nonatomic, copy) NSArray <HTCartDetailModel *> *goods;
/** 是否选择*/
@property (nonatomic, assign) BOOL chooseState;
/** 是否编辑状态*/
@property (nonatomic, assign) BOOL isEdit;

@end

@interface HTCartDetailModel : NSObject

/** 商品id*/
@property (nonatomic, copy) NSString *goods_id;
/** 商品名称*/
@property (nonatomic, copy) NSString *goods_name;
/** 商品图片*/
@property (nonatomic, copy) NSString *goods_image;
/** 商品属性*/
@property (nonatomic, copy) NSString *goods_property;
/** 商品限购*/
@property (nonatomic, copy) NSString *goods_limit;
/** 原价*/
@property (nonatomic, copy) NSNumber *original_price;
/** 现价*/
@property (nonatomic, copy) NSNumber *current_price;
/** 商品数量*/
@property (nonatomic, copy) NSNumber *goods_count;
/** 是否选择*/
@property (nonatomic, assign) BOOL chooseState;

@end
