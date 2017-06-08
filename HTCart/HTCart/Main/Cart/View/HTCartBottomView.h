//
//  HTCartBottomView.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCartBottomView : UIView

/** 全选按钮 */
@property (nonatomic, strong) UIButton *allChooseButton;

/** 合计金额 */
@property (nonatomic, strong) UILabel *totalLabel;

/** 结算按钮 */
@property (nonatomic, strong) UIButton *settleButton;

@end
