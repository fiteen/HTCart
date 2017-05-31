//
//  HTCartViewController.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartViewController.h"
#import "HTCartBottomView.h"

@interface HTCartViewController ()

@property (nonatomic, strong) HTCartBottomView *bottomView;

@end

@implementation HTCartViewController

- (HTCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HTCartBottomView alloc] init];
        if (self.navigationController.viewControllers.count == 1) {
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 49 - 50, SCREEN_WIDTH, 50);
        } else {
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
        }
        [_bottomView.allChooseButton addTarget:self action:@selector(clickAllChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.settleButton addTarget:self action:@selector(clickSettleButton:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.totalLabel.text = @"合计: ¥ 0.00";
        [_bottomView.totalLabel setLabelText:_bottomView.totalLabel.text Color:TEXT_BLACK_COLOR Range:NSMakeRange(0, 3)];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editGoods)];
    self.bottomView.hidden = NO;
}

#pragma mark - SEL

- (void)editGoods {
    
}

- (void)clickAllChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    
//    for (int i = 0; i < self.contentArray.count; i++) {
//        YZLCartContentModel *contentModel = self.contentArray[i];
//        contentModel.selectState = button.selected;
//    }
//    [self.tableView reloadData];
//    [self updateCartBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
