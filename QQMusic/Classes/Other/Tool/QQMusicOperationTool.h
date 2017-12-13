//
//  QQMusicOperationTool.h
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicMessageModel.h"
#import "QQMusicListModel.h"
#import "QQLrcModel.h"
@class QQMusicMessageModel;
@interface QQMusicOperationTool : NSObject

@property (nonatomic,strong) NSArray <QQMusicListModel *> *musicMsgs;
@property (nonatomic,strong) QQMusicMessageModel *musicMsgModel;

+ (instancetype)sharedInstance;

- (void)playMusicWithMusicMsg:(QQMusicListModel *)model;

- (void)playNextMusic;

- (void)playPreMusic;

- (void)pauseMusic;

- (void)stopMusic;

- (void)playCurrentMusic;

- (void)setUpLockMessage;

- (void)trackSliderState:(double)progress;

@end
