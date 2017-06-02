//
//  HTCartViewController.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartViewController.h"
#import "HTHomeViewController.h"
#import "HTCartBottomView.h"
#import "HTCartCell.h"

@interface HTCartViewController ()<UITableViewDelegate,UITableViewDataSource,HTHomeViewControllerDelegate> {
    /** 购物车清单 */
    NSMutableArray *_cartArray;
}

/** 底部界面-全选/合计/结算 */
@property (nonatomic, strong) HTCartBottomView *bottomView;

/** 购物车清单本地存储地址 */
@property (nonatomic, strong) NSString *path;

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

- (NSString *)path {
    if (!_path) {
        _path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"cart.plist"];
        NSLog(@"文件路径%@",_path);
    }
    return _path;
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
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editGoods)];
    self.bottomView.hidden = NO;
    _cartArray = [HTPlistTool readPlistArrayWithPath:self.path];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView placeholderBaseOnNumber:_cartArray.count iconConfig:^(UIImageView *imageView) {
        imageView.image = [UIImage imageNamed:@"no_goods_placeholder"];
    } textConfig:^(UILabel *label) {
        label.text = @"购物车竟然是空的";
        label.textColor = TEXT_GRAY_COLOR;
        label.font = [UIFont systemFontOfSize:15];
    }];
    UINavigationController *navi = self.tabBarController.viewControllers[0];
    HTHomeViewController *homeVC = navi.viewControllers.firstObject;
    homeVC.delegate = self;
}

#pragma mark - TableViewDelegate&TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cartArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCartCell *cell = [tableView dequeueReusableCellWithIdentifier:HTCartNormalCellId];
    NSDictionary *cartDic = _cartArray[indexPath.row];
    cell.goodsImage.image = [UIImage imageNamed:[cartDic valueForKey:@"goods_image"]];
    cell.nameLabel.text = [cartDic valueForKey:@"goods_name"];
    cell.countLabel.text = [NSString stringWithFormat:@"x%ld",[[cartDic valueForKey:@"goods_count"] longValue]];
    [cell.chooseButton addTarget:self action:@selector(clickSingleChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - HTHomeViewControllerDelegate
- (void)refreshCart {
    [self.tableView reloadData];
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
