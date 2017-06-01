//
//  HTCartViewController.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartViewController.h"
#import "HTCartBottomView.h"
#import "HTCartCell.h"

@interface HTCartViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 底部界面-全选/合计/结算 */
@property (nonatomic, strong) HTCartBottomView *bottomView;

/** 购物车清单 */
@property (nonatomic, strong) NSArray *cartArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTCartViewController

static const CGFloat bottomViewHeight = 50;

static NSString * const HTCartNormalCellId = @"HTCartNormalCell";

- (HTCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HTCartBottomView alloc] init];
        if (self.navigationController.viewControllers.count == 1) {
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT - bottomViewHeight, SCREEN_WIDTH, bottomViewHeight);
        } else {
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - bottomViewHeight, SCREEN_WIDTH, bottomViewHeight);
        }
        [_bottomView.allChooseButton addTarget:self action:@selector(clickAllChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.settleButton addTarget:self action:@selector(clickSettleButton:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.totalLabel.text = @"合计: ¥ 0.00";
        [_bottomView.totalLabel setLabelText:_bottomView.totalLabel.text Color:TEXT_BLACK_COLOR Range:NSMakeRange(0, 3)];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (NSArray *)cartArray {
    if (!_cartArray) {
        
    }
    return _cartArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        if (self.navigationController.viewControllers.count == 1) {
            _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT- bottomViewHeight);
        } else {
            _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - bottomViewHeight);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"HTCartCell" bundle:nil] forCellReuseIdentifier:HTCartNormalCellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editGoods)];
    self.bottomView.hidden = NO;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - TableViewDelegate&TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cartArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCartCell *cell = [tableView dequeueReusableCellWithIdentifier:HTCartNormalCellId];
    [cell.chooseButton addTarget:self action:@selector(clickSingleChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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

- (void)clickSettleButton:(UIButton *)button {
    
}

- (void)clickSingleChooseButton:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
