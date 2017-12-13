//
//  QQLrcDataTool.m
//  QQMusic
//
//  Created by admin on 2017/11/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQLrcDataTool.h"
#import "GetTimeTool.h"
@implementation QQLrcDataTool

+(NSArray<QQLrcModel *> *)getLrc:(NSString *)fileName
{
    NSString * path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    NSString * lrcS = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",lrcS);
    NSArray * lrcArr = [lrcS componentsSeparatedByString:@"\n"];
    /*
     [ti:月半小夜曲]
     [ar:李克勤]
     [al:Purple dream]
     [00:00.00]月半小夜曲 李克勤
     [00:19.00]曲：河合奈保子 词：向雪怀
     [00:23.00]仍然倚在失眠夜望天边星宿
     [00:29.00]仍然听见小提琴如泣似诉再挑逗
     [00:35.00]为何只剩一弯月留在我的天空
     [00:42.00]这晚以后音讯隔绝
     [00:47.00]人如天上的明月是不可拥有
     [00:53.00]情如曲过只遗留无可挽救再分别
     [00:58.00]为何只是失望填密我的空虚
     */
    NSMutableArray * resArr = [NSMutableArray array];
    for(NSString * lrc in lrcArr)
    {
        if([lrc containsString:@"[ti"] || [lrc containsString:@"[ar"] || [lrc containsString:@"[al"])
        {
            continue;
        }
        NSString * newLrc = [lrc stringByReplacingOccurrencesOfString:@"[" withString:@""];
        NSArray * resultLrcArr = [newLrc componentsSeparatedByString:@"]"];
        if(resultLrcArr.count != 2) continue;
        NSString * time = resultLrcArr[0];
        NSString * content = resultLrcArr[1];
        QQLrcModel * lrcModel = [[QQLrcModel alloc]init];
        lrcModel.begainTime = [GetTimeTool getTimeFromFomat:time];
        lrcModel.content = content;
        [resArr addObject:lrcModel];
    }
    // 给数据模型的结束时间赋值
    for (int i = 0; i < resArr.count; i++) {
        if (i == resArr.count - 1) {
            break;
        }
        QQLrcModel *lrcM = resArr[i];
        QQLrcModel *nextlrcM = resArr[i + 1];
        lrcM.endTime = nextlrcM.begainTime;
    }
    return resArr;
}

/**
 *  根据当前时间何歌词数据模型组成的数据, 获取对应的应该播放的歌词数据模型
 *
 *  @param currentTime 当前时间
 *  @param lrcMs       歌词数据模型数组
 *
 *  @return 索引
 */
+ (NSInteger)getRowWithCurrentTime:(NSTimeInterval)currentTime andLrcMs:(NSArray <QQLrcModel *>*)lrcMs;
{
    // 遍历每一个歌词数据模型, 如果发现当歌曲播放时间 大于歌词的开始时间, 并且小于歌词的结束时间, 就返回
    int i = 0;
    for (i = 0; i < lrcMs.count; i ++) {
        QQLrcModel *model = lrcMs[i];
        if (currentTime >= model.begainTime && currentTime < model.endTime)
        {
            return i;
        }
    }
    // 如果都没查找到, 并且是存在时间, 是当做最后一行处理, 防止跳回到第一行
    if (i > 0 && currentTime > 0)
    {
        return lrcMs.count - 1;
    }
    return 0;
}
@end
