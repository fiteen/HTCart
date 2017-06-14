//
//  HTCartSectionTitleView.m
//  HTCart
//
//  Created by Huiting Mao on 2017/6/5.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartSectionTitleView.h"

@implementation HTCartSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"HTCartSectionTitleView" owner:self options:nil];
        self.layer.borderColor = BACKGROUND_GRAY_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        _contentView.frame = self.bounds;
        [self addSubview:_contentView];
    }
    return self;
}

@end
