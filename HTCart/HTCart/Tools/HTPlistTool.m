//
//  HTPlistTool.m
//  HTCart
//
//  Created by Huiting Mao on 2017/6/2.
//  Copyright © 2017年 Martell. All rights reserved.
//

#import "HTPlistTool.h"

@implementation HTPlistTool

/* 向plist中写入数组数据 **/
+ (void)writeDataToPlist:(NSString *)path withArr:(NSMutableArray *)array {
    [array writeToFile:path atomically:YES];
}

/* 读取数组类型的plist **/
+ (NSMutableArray *)readPlistArrayWithPath:(NSString *)path {
    NSMutableArray *mutArr = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {//文件不存在时初始化地址数组
        mutArr = [NSMutableArray new];
    }else {
        mutArr = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return mutArr;
}

/* 将字典从数组中删除，然后更新plist **/

+ (void)deletePlistDicInArrWithPath:(NSString *)path withMutDic:(NSMutableDictionary *)mutDic {
    NSMutableArray *arr = [self readPlistArrayWithPath:path];
    [arr removeObject:mutDic];
    [arr writeToFile:path atomically:YES];
}

/* 读取字典类型的plist **/
+ (NSMutableDictionary *)readPlistDicWithPath:(NSString *)path {
    NSMutableDictionary *mutDic = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {//文件不存在时初始化地址数组
        mutDic = [NSMutableDictionary new];
    }else {
        mutDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return mutDic;
}

@end
