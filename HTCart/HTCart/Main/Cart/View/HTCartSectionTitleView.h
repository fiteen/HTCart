//
//  HTCartSectionTitleView.h
//  HTCart
//
//  Created by Huiting Mao on 2017/6/5.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTCartSectionTitleView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
/** 选择按钮*/
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
/** 商铺按钮*/
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
/** 编辑按钮*/
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
