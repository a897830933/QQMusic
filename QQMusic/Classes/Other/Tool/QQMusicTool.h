//
//  QQMusicTool.h
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class QQMusicListModel;
@interface QQMusicTool : NSObject
//播放音乐
- (AVAudioPlayer *)playMusicWithModel:(NSString *)fileURL;

//暂停音乐
- (void)pauseMusic;

//停止音乐
-  (void)stopMusic;

// 设置当前播放器的播放进度
- (void)seekToTimeInterval:(NSTimeInterval)currentTime;

// 设置代理, 让外界监听音乐播放完成事件
@property (nonatomic, weak) id<AVAudioPlayerDelegate> delegate;

@end
