//
//  HTHomeViewController.h
//  HTCart
//
//  Created by Huiting Mao on 2017/5/27.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTHomeViewControllerDelegate <NSObject>

- (void)refreshCart;

@end

@interface HTHomeViewController : UIViewController

@property (nonatomic, weak) id <HTHomeViewControllerDelegate> delegate;

@end

