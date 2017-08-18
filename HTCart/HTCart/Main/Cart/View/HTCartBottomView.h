//
//  HTCartBottomView.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCartBottomView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;

/** 是否处于编辑状态*/
@property (nonatomic, assign) BOOL isEdit;
/** 全选按钮*/
@property (weak, nonatomic) IBOutlet UIButton *allChooseButton;
/** 合计金额*/
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/** 结算按钮*/
@property (weak, nonatomic) IBOutlet UIButton *settleButton;

@end
