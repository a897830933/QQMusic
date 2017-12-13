//
//  QQMusicMessageModel.h
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicListModel.h"
@interface QQMusicMessageModel : NSObject

@property (nonatomic,strong) QQMusicListModel *musicMsg;

//已经播放的时间
@property (nonatomic,assign) NSTimeInterval costTime;
//总时间
@property (nonatomic,assign) NSTimeInterval totalTime;
//播放状态
@property (nonatomic,assign) BOOL isPlaying;

@end
