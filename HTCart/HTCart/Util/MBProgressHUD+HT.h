//
//  MBProgressHUD+HT.h
//  HTCart
//
//  Created by Huiting Mao on 2017/6/12.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (HT)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showHint:(NSString *)tip toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;

+ (void)showError:(NSString *)error;

+ (void)showHint:(NSString *)tip;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;

+ (void)hideHUD;

@end
