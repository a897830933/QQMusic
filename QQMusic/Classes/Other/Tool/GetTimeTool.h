//
//  GetTimeTool.h
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTimeTool : NSObject
+ (NSString *)getTimeFomat:(NSTimeInterval)time;
+ (NSTimeInterval)getTimeFromFomat:(NSString *)fomatTime;
@end
