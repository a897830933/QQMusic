//
//  QQLrcDataTool.h
//  QQMusic
//
//  Created by admin on 2017/11/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQLrcModel.h"
#import "QQMusicMessageModel.h"

@interface QQLrcDataTool : NSObject

+ (NSArray <QQLrcModel *> *)getLrc:(NSString *)fileName;


+ (NSInteger)getRowWithCurrentTime:(NSTimeInterval)currentTime andLrcMs:(NSArray <QQLrcModel *>*)lrcMs;

@end
