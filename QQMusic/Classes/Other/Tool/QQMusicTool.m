
//
//  QQMusicTool.m
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQMusicTool.h"
#import "QQMusicListModel.h"
@interface QQMusicTool()<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *player;

/** 当前播放的路径 */
@property(nonatomic ,copy) NSURL *currentPlayURL;

@end
@implementation QQMusicTool
- (instancetype)init
{
    if(self = [super init]){
        //添加后台播放
        [self addAudioSession];
    }
    return self;
}

- (AVAudioPlayer *)playMusicWithModel:(NSString *)fileURL
{
    NSURL * url = [[NSBundle mainBundle]URLForResource:fileURL withExtension:nil];
   
    if(url == nil) {
        return nil;
    }
    
    // 业务逻辑优化, 如果发现, 播放的是当前正在播放的歌曲, 不需要重新创建播放器对象, 直接开始播放就行
    if ([self.currentPlayURL.absoluteString isEqualToString:url.absoluteString]) {
        [self.player play];
        return self.player;
    }
    
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.currentPlayURL = url;
    self.player.delegate = self.delegate;

    [self.player prepareToPlay];
    [self.player play];
   
    return self.player;
}

- (void)pauseMusic
{
    [self.player pause];
}

- (void)stopMusic
{
    [self.player stop];
    self.player = nil;
}

- (void)seekToTimeInterval:(NSTimeInterval)currentTime
{
    self.player.currentTime = currentTime;
}

- (void)setDelegate:(id<AVAudioPlayerDelegate>)delegate
{
    _delegate = delegate;
    self.player.delegate = delegate;
}
//添加后台播放
- (void)addAudioSession
{
    //1.获取音频会话
    AVAudioSession * session = [AVAudioSession sharedInstance];
    //2.设置会话分类
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //3.激活会话
    [session setActive:YES error:nil];
    
}

@end
