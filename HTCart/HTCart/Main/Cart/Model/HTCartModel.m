//
//  HTCartModel.m
//  HTCart
//
//  Created by Huiting Mao on 2017/5/31.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTCartModel.h"

@implementation HTCartModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods" : [HTCartDetailModel class]};
}

@end

@implementation HTCartDetailModel

@end
