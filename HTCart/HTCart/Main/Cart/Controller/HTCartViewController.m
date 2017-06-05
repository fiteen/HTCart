//
//  HTCartViewController.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartViewController.h"
#import "HTHomeViewController.h"
#import "HTCartModel.h"
#import "HTCartSectionTitleView.h"
#import "HTCartCell.h"
#import "HTCartBottomView.h"

@interface HTCartViewController ()<UITableViewDelegate,UITableViewDataSource,HTHomeViewControllerDelegate> {
    /** 购物车清单 */
    NSMutableArray *_cartArray;
    /** 选择总价 */
    CGFloat _totalPrice;
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
    self.tableView.tableFooterView = [UIView new];
    
    _cartArray = [HTPlistTool readPlistArrayWithPath:self.path];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cartArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = _cartArray[section];
    NSArray *goodsArr = [dic valueForKey:@"goods"];
    return goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCartCell *cell = [tableView dequeueReusableCellWithIdentifier:HTCartNormalCellId];
    NSDictionary *dic = _cartArray[indexPath.section];
    NSArray *goodsArr = [dic valueForKey:@"goods"];
    HTCartModel *cartModel = [HTCartModel mj_objectWithKeyValues:goodsArr[indexPath.row]];
    cell.goodsImage.image = [UIImage imageNamed:cartModel.goods_image];
    cell.nameLabel.text = cartModel.goods_name;
    cell.countLabel.text = [NSString stringWithFormat:@"x%@",cartModel.goods_count];
    cell.chooseButton.tag = indexPath.row;
    cell.chooseButton.selected = cartModel.chooseState;
    [cell.chooseButton addTarget:self action:@selector(clickSingleChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = _cartArray[section];
    HTCartSectionTitleView *view = [HTCartSectionTitleView new];
    [view.shopButton setTitle:[dic valueForKey:@"shop_name"] forState:UIControlStateNormal];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark - HTHomeViewControllerDelegate
- (void)refreshCart {
    _cartArray = [HTPlistTool readPlistArrayWithPath:self.path];
    [self.tableView reloadData];
}

#pragma mark - SEL

- (void)editGoods {
    
}

// 全选按钮
- (void)clickAllChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    for (HTCartModel *cartModel in _cartArray) {
        cartModel.chooseState = button.selected;
    }
    [self.tableView reloadData];
    [self updateBottomView];
}

// 单选
- (void)clickSingleChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    HTCartModel *cartModel = _cartArray[button.tag];
    cartModel.chooseState = button.selected;
    BOOL allChoosen = YES;
    for (HTCartModel *model in _cartArray) {
        allChoosen = allChoosen && model.chooseState;
    }
    self.bottomView.allChooseButton.selected = allChoosen;
    [self updateBottomView];
}

- (void)clickSettleButton:(UIButton *)button {
    NSLog(@"结算");
}

// 修改底部信息
- (void)updateBottomView {
    _totalPrice = 0;
    for (HTCartModel *cartModel in _cartArray) {
        if (cartModel.chooseState) {
            _totalPrice += [cartModel.goods_count longValue] *[cartModel.current_price floatValue];
        }
    }
    self.bottomView.totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",_totalPrice];
    [self.bottomView.totalLabel setLabelText:self.bottomView.totalLabel.text Color:TEXT_BLACK_COLOR Range:NSMakeRange(0, 3)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
