//
//  QQMusicDataTool.m
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQMusicDataTool.h"
#import "GetTimeTool.h"
@implementation QQMusicDataTool

+ (NSArray<QQMusicListModel *> *)getMusicModel
{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Musics.plist" ofType:nil];
    NSArray * arr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray * dataArr = [NSMutableArray array];
    for (NSDictionary * dict in arr) {
        QQMusicListModel * model = [[QQMusicListModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [dataArr addObject:model];
    }
    return dataArr;
}

@end
