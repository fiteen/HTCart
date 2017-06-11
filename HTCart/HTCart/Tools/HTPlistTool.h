//
//  HTPlistTool.h
//  HTCart
//
//  Created by Huiting Mao on 2017/6/2.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPlistTool : NSObject

/* 读取数组类型的plist **/
+ (NSMutableArray *)readPlistArrayWithPath:(NSString *)path;

/* 将字典从数组中删除，然后更新plist **/
+ (void)deletePlistDicInArrWithPath:(NSString *)path withMutDic:(NSMutableDictionary *)mutDic;

/* 读取字典类型的plist **/
+ (NSMutableDictionary *)readPlistDicWithPath:(NSString *)path;

@end
