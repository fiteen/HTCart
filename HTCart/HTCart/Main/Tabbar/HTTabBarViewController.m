//
//  HTTabBarViewController.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTTabBarViewController.h"
#import "HTHomeViewController.h"
#import "HTCartViewController.h"
#define TAG_BTN 0x0100

@interface HTTabBarViewController () {
    NSMutableArray *_buttonArray;
}

@end

@implementation HTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化子视图
    [self setUpSubviews];
    // 定义标签栏
    [self setUpTabBarItems];
}

- (void)viewWillLayoutSubviews {
    [self removeSystemTabbarButton];
}

- (void)setUpSubviews {
    HTHomeViewController *homeVC = [HTHomeViewController new];
    HTCartViewController *cartVC = [HTCartViewController new];
    NSArray *viewControllers = @[homeVC,cartVC];
    NSMutableArray *navigationControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        UINavigationController *baseNC = [[UINavigationController alloc]initWithRootViewController:vc];
        [navigationControllers addObject:baseNC];
    }
    self.viewControllers = navigationControllers;
}

- (void)setUpTabBarItems {
    NSArray *imageNameArr = @[@"tabbar_home_normal",@"tabbar_cart_normal"];
    NSArray *imageSelectedNameArr = @[@"tabbar_home_selected",@"tabbar_cart_selected"];
    NSArray *titleNameArr = @[@"商城",@"购物车"];

    // 定义宽度
    float tabbarWidth = SCREEN_WIDTH / titleNameArr.count;
    // 创建按钮
    _buttonArray = [NSMutableArray new];
    for (NSInteger i = 0; i < titleNameArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tabbarWidth * i, 0, tabbarWidth, 49)];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageSelectedNameArr[i]] forState:UIControlStateSelected];
        [button setTitle:titleNameArr[i] forState:UIControlStateNormal];
        [button setTitleColor:TABBAR_TEXT_NORMAL_COLOR forState:UIControlStateNormal];
        [button setTitleColor:TABBAR_TEXT_SELECTED_COLOR forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [button layoutButtonWithEdgeInsetsStyle:HTButtonEdgeInsetsStyleTop imageTitleSpace:2.0];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + TAG_BTN;
        [_buttonArray addObject:button];
        [self.tabBar addSubview:button];
        if (i == 0) {
            button.selected = YES;
            self.selectedIndex = i;
        }
    }
}

#pragma mark - SEL

// 标签按钮点击事件
- (void)buttonAction:(UIButton *)item {
    self.selectedIndex = item.tag - TAG_BTN;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    for (int i = 0; i < _buttonArray.count; i++) {
        UIButton *button = (UIButton *)_buttonArray[i];
        button.selected = NO;
    }
    UIButton *selectButton = (UIButton *)_buttonArray[selectedIndex];
    selectButton.selected = YES;
}

// 移除系统tabbar按钮 UITabBarButton
- (void)removeSystemTabbarButton {
    // 遍历tabbar上面的所有子视图，移除上面的按钮
    for (UIView *view in self.tabBar.subviews) {
        Class c = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:[c class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
