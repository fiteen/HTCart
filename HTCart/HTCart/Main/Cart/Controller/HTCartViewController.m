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

#define TAG_CELLBTN 0x1000
#define TAG_HEADERBTN 0x0100

@interface HTCartViewController ()<UITableViewDelegate,UITableViewDataSource,HTHomeViewControllerDelegate,HTCartCellDelegate> {
    /** 购物车清单*/
    NSMutableArray *_cartArray;
    /** 选择总价*/
    CGFloat _totalPrice;
    /** 是否点击页面右上角编辑按钮*/
    BOOL _isPressEditButton;
    /** rightBarButtonItem按钮文字*/
    NSString *_rightBarButtonItemTitle;
}

/** 底部界面-全选/合计/结算*/
@property (nonatomic, strong) HTCartBottomView *bottomView;

/** 购物车清单本地存储地址*/
@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HTCartViewController

static NSString * const HTCartNormalCellId = @"HTCartNormalCell";

- (HTCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HTCartBottomView alloc] init];
        if (self.navigationController.viewControllers.count == 1) {
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT - BOTTOMVIEW_HEIGHT, SCREEN_WIDTH, BOTTOMVIEW_HEIGHT);
        } else {
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOMVIEW_HEIGHT, SCREEN_WIDTH, BOTTOMVIEW_HEIGHT);
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
            _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_HEIGHT- BOTTOMVIEW_HEIGHT);
        } else {
            _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - BOTTOMVIEW_HEIGHT);
        }
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_tableView setSeparatorColor:BACKGROUND_GRAY_COLOR];
        [_tableView registerNib:[UINib nibWithNibName:@"HTCartCell" bundle:nil] forCellReuseIdentifier:HTCartNormalCellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self updateBottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 初始化信息
    [self refreshCart];
    self.bottomView.isEdit = NO;
    self.bottomView.allChooseButton.selected = NO;
    _rightBarButtonItemTitle = @"编辑";
    self.navigationItem.rightBarButtonItem.title = _rightBarButtonItemTitle;
}

- (void)initView {
    self.view.backgroundColor = BACKGROUND_GRAY_COLOR;
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAllGoods:)];
    self.bottomView.hidden = YES;
    
    UINavigationController *navi = self.tabBarController.viewControllers[0];
    HTHomeViewController *homeVC = navi.viewControllers.firstObject;
    homeVC.delegate = self;
}

#pragma mark - TableViewDelegate&TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [self.tableView placeholderBaseOnNumber:_cartArray.count iconConfig:^(UIImageView *imageView) {
        imageView.image = [UIImage imageNamed:@"no_goods_placeholder"];
    } textConfig:^(UILabel *label) {
        label.text = @"购物车竟然是空的";
        label.textColor = TEXT_GRAY_COLOR;
        label.font = [UIFont systemFontOfSize:15];
    }];
    self.bottomView.hidden = _cartArray.count == 0;
    self.navigationItem.rightBarButtonItem.title = _cartArray.count != 0 ? _rightBarButtonItemTitle : @"";
    return _cartArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = _cartArray[section];
    NSArray *goodsArr = [dic valueForKey:@"goods"];
    return goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCartCell *cell = [HTCartCell new];
    // 为商品信息赋值
    HTCartModel *cartModel = _cartArray[indexPath.section];
    if (cartModel.isEdit) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HTCartCell" owner:self options:nil] objectAtIndex:1];
        cell.delegate = self;
        cell.countView.delegate = (id)self;
        cell.countView.maxValue = cartModel.goods[indexPath.row].goods_limit ==  nil ? LONG_MAX : [cartModel.goods[indexPath.row].goods_limit integerValue];
        cell.countView.currentNumber = [cartModel.goods[indexPath.row].goods_count integerValue];
        cell.propertyEditLabel.text = cartModel.goods[indexPath.row].goods_property;
        [cell.propertyEditButton addTarget:self action:@selector(editPropertyButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.section * TAG_CELLBTN + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HTCartCell" owner:self options:nil] firstObject];
        cell.nameLabel.text = cartModel.goods[indexPath.row].goods_name;
        cell.propertyLabel.text = cartModel.goods[indexPath.row].goods_property;
        cell.limitLabel.text = cartModel.goods[indexPath.row].goods_limit == nil? @"" : [NSString stringWithFormat:@"限购%@件",cartModel.goods[indexPath.row].goods_limit];
        cell.currentPriceLabel.text = [NSString stringWithFormat:@"¥%@",cartModel.goods[indexPath.row].current_price];
        cell.originalPriceLabel.text = [NSString stringWithFormat:@"¥%@",cartModel.goods[indexPath.row].original_price];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",cartModel.goods[indexPath.row].goods_count];
        // 为原价加删除线
        [cell.originalPriceLabel setLabelWithDelLine];
    }
    cell.goodsImage.image = [UIImage imageNamed:cartModel.goods[indexPath.row].goods_image];
    // 单选按钮设置
    cell.chooseButton.tag = indexPath.section * TAG_CELLBTN + indexPath.row;
    cell.chooseButton.selected = cartModel.goods[indexPath.row].chooseState;
    [cell.chooseButton addTarget:self action:@selector(clickSingleChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HTCartSectionTitleView *view = [HTCartSectionTitleView new];
    HTCartModel *cartModel = _cartArray[section];
    view.chooseButton.selected = cartModel.chooseState;
    view.chooseButton.tag = TAG_HEADERBTN + section;
    [view.chooseButton addTarget:self action:@selector(clickShopAllChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [view.shopButton setTitle:cartModel.shop_name forState:UIControlStateNormal];
    [view.editButton setTitle:cartModel.isEdit ? @"完成" : @"编辑" forState:UIControlStateNormal];
    view.editButton.tag = TAG_HEADERBTN + section;
    [view.editButton addTarget:self action:@selector(editShopGoods:) forControlEvents:UIControlEventTouchUpInside];
    view.editButton.hidden = _isPressEditButton;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = BACKGROUND_GRAY_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != _cartArray.count - 1) {
        return 10;
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    HTCartModel *cartModel = _cartArray[indexPath.section];
    if (cartModel.isEdit) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认要删除这个宝贝吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancelAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            HTCartModel *cartModel = _cartArray[indexPath.section];
            if (cartModel.goods.count > 1) {
                NSMutableArray *cartMutableArr = [cartModel.goods mutableCopy];
                [cartMutableArr removeObjectAtIndex:indexPath.row];
                cartModel.goods = cartMutableArr;
            } else {
                [_cartArray removeObjectAtIndex:indexPath.section];
            }
            [self writeToFile];
            [_tableView reloadData];
            [self updateBottomView];
        }];
        [alertC addAction:sureAction];
        [self.navigationController presentViewController:alertC animated:YES completion:nil];
    }];
    UITableViewRowAction *similarRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"找相似" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"找相似");
    }];
    return @[deleteRowAction,similarRowAction];
}

#pragma mark - SEL
/**
 * 刷新购物车
 */
- (void)refreshCart {
    NSArray *plistArray = [[HTPlistTool readPlistArrayWithPath:self.path] mj_JSONObject];
    _cartArray = [NSMutableArray array];
    for (int i = 0; i < plistArray.count; i++) {
        HTCartModel *cartModel = [HTCartModel mj_objectWithKeyValues:plistArray[i]];
        [_cartArray addObject:cartModel];
    }
    [self.tableView reloadData];
}

/**
 * 编辑商品属性
 */
- (void)editPropertyButton:(UIButton *)button {
    NSLog(@"编辑属性");
}

/**
 * 编辑所有商品
 */
- (void)editAllGoods:(UIBarButtonItem *)item {
    BOOL isEdit = [item.title isEqualToString:@"编辑"];
    _rightBarButtonItemTitle = isEdit ? @"完成" : @"编辑";
    item.title = _rightBarButtonItemTitle;
    _isPressEditButton = isEdit;
    for (HTCartModel *cartModel in _cartArray) {
        cartModel.isEdit = isEdit;
    }
    _bottomView.isEdit = isEdit;
    [_tableView reloadData];
}

/**
 * 删除商品
 */
- (void)deleteGoods:(UIButton *)button {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认要删除这个宝贝吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger section = button.tag / TAG_CELLBTN;
        NSInteger row = button.tag % TAG_CELLBTN;
        HTCartModel *cartModel = _cartArray[section];
        if (cartModel.goods.count > 1) {
            NSMutableArray *cartMutableArr = [cartModel.goods mutableCopy];
            [cartMutableArr removeObjectAtIndex:row];
            cartModel.goods = cartMutableArr;
        } else {
            [_cartArray removeObjectAtIndex:section];
        }
        [self writeToFile];
        [_tableView reloadData];
        [self updateBottomView];
    }];
    [alertC addAction:sureAction];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

/**
 * 编辑商铺内的商品
 */
- (void)editShopGoods:(UIButton *)button {
    HTCartModel *cartModel = _cartArray[button.tag - TAG_HEADERBTN];
    cartModel.isEdit = !cartModel.isEdit;
    [_tableView reloadData];
}

/**
 * 单选商品
 */
- (void)clickSingleChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    HTCartModel *cartModel = _cartArray[button.tag / TAG_CELLBTN];
    cartModel.goods[button.tag % TAG_CELLBTN].chooseState = button.selected;
    BOOL shopAllChoosen = YES;
    for (HTCartDetailModel *detailModel in cartModel.goods) {
        shopAllChoosen &= detailModel.chooseState;
    }
    cartModel.chooseState = shopAllChoosen;
    
    BOOL allChoosen = YES;
    for (HTCartModel *cartModel in _cartArray) {
        allChoosen &= cartModel.chooseState;
    }
    self.bottomView.allChooseButton.selected = allChoosen;
    [_tableView reloadData];
    [self updateBottomView];
}

/**
 * 全选某商铺所有商品
 */
- (void)clickShopAllChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    HTCartModel *cartModel = _cartArray[button.tag - TAG_HEADERBTN];
    cartModel.chooseState = button.selected;
    for (HTCartDetailModel *detailModel in cartModel.goods) {
        detailModel.chooseState = button.selected;
    }
    BOOL allChoosen = YES;
    for (HTCartModel *cartModel in _cartArray) {
        allChoosen &= cartModel.chooseState;
    }
    self.bottomView.allChooseButton.selected = allChoosen;
    [_tableView reloadData];
    [self updateBottomView];
}

/**
 * 全选商品
 */
- (void)clickAllChooseButton:(UIButton *)button {
    button.selected = !button.selected;
    for (HTCartModel *cartModel in _cartArray) {
        cartModel.chooseState = button.selected;
        for (HTCartDetailModel *detailModel in cartModel.goods) {
            detailModel.chooseState = button.selected;
        }
    }
    [_tableView reloadData];
    [self updateBottomView];
}

/**
 * 结算/删除按钮
 */
- (void)clickSettleButton:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"删除"]) {
        NSMutableArray *copyCartArray = [_cartArray mutableCopy];
        for (int i = 0;i < _cartArray.count; i++) {
            HTCartModel *cartModel = _cartArray[i];
            if (cartModel.chooseState) {
                [copyCartArray removeObject:cartModel];
            } else {
                NSMutableArray *copyGoodsArray = [cartModel.goods mutableCopy];
                for (int j = 0; j < cartModel.goods.count; j++) {
                    HTCartDetailModel *goodsModel = cartModel.goods[j];
                    if (goodsModel.chooseState) {
                        [copyGoodsArray removeObject:goodsModel];
                    }
                }
                cartModel.goods = copyGoodsArray;
            }
        }
        _cartArray = copyCartArray;
        [self writeToFile];
        [_tableView reloadData];
        [self updateBottomView];
    } else {
        NSLog(@"结算");
    }
}

/**
 * 修改底部信息
 */
- (void)updateBottomView {
    _totalPrice = 0;
    for (HTCartModel *cartModel in _cartArray) {
        for (HTCartDetailModel *detailModel in cartModel.goods) {
            if (detailModel.chooseState) {
                _totalPrice += [detailModel.goods_count longValue] *[detailModel.current_price floatValue];
            }
        }
    }
    self.bottomView.totalLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",_totalPrice];
    [self.bottomView.totalLabel setLabelText:self.bottomView.totalLabel.text Color:TEXT_BLACK_COLOR Range:NSMakeRange(0, 3)];
}

/**
 * 将购物车信息本地化存储
 **/
- (void)writeToFile {
    NSMutableArray *newCartArr = [NSMutableArray array];
    for (HTCartModel *cartModel in _cartArray) {
        NSMutableDictionary *cartDic = [cartModel mj_JSONObject];
        [cartDic removeObjectForKey:@"isEdit"];
        [cartDic removeObjectForKey:@"chooseState"];
        NSMutableArray *goods = [cartDic valueForKey:@"goods"];
        for (NSMutableDictionary *detailDic in goods) {
            [detailDic removeObjectForKey:@"chooseState"];
        }
        [newCartArr addObject:cartDic];
    }
    [newCartArr writeToFile:_path atomically:YES];
}

#pragma mark - HTHomeViewControllerDelegate
- (void)changeGoodsNumberCell:(UITableViewCell *)cell Number:(NSInteger)num {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    HTCartModel *cartModel = _cartArray[indexPath.section];
    cartModel.goods[indexPath.row].goods_count = [NSNumber numberWithInteger:num];
    [self writeToFile];
}

#pragma mark - HTNumberButtonDelegate
- (void)ht_numberButton:(__kindof UIView *)numberButton
                 number:(NSInteger)number
                  isAdd:(BOOL)isAdd {
    [self updateBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
