//
//  GetTimeTool.m
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "GetTimeTool.h"

@implementation GetTimeTool
+ (NSString *)getTimeFomat:(NSTimeInterval)time
{
    int sec = (int)time % 60;
    int minute = (int)time/60;
    return [NSString stringWithFormat:@"%02d:%02d",minute, sec];
    
}
+ (NSTimeInterval)getTimeFromFomat:(NSString *)fomatTime
{
    NSArray * time = [fomatTime componentsSeparatedByString:@":"];
    if(time.count != 2) return 0;
    NSTimeInterval sec = [time[0] doubleValue] ;
    NSTimeInterval minute = [time[1] doubleValue];
    return sec*60 + minute;
}
@end
