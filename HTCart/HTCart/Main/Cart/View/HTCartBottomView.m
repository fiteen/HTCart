//
//  HTCartBottomView.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartBottomView.h"

@implementation HTCartBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"HTCartBottomView" owner:self options:nil];
        _contentView.frame = self.bounds;
        [self addSubview:_contentView];
    }
    return self;
}

@end
