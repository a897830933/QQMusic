//
//  QQMusicDataTool.h
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicListModel.h"
@interface QQMusicDataTool : NSObject

+ (NSArray<QQMusicListModel *> *)getMusicModel;

@end
