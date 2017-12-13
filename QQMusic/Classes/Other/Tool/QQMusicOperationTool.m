//
//  QQMusicOperationTool.m
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQMusicOperationTool.h"
#import "QQMusicTool.h"
#import "QQMusicDataTool.h"
#import <MediaPlayer/MediaPlayer.h>
@interface QQMusicOperationTool()

/** 单个音乐播放的工具类 **/
@property (nonatomic,strong) QQMusicTool *audioTool;


@property (nonatomic,strong) NSArray <QQLrcModel *> *lrcArr;


/** 当前播放的索引 */
@property(nonatomic ,assign) NSInteger currentPlayIndex;


/** 当前正在播放的播放器对象*/
@property (nonatomic ,weak) AVAudioPlayer *currentPlayer;


@end

@implementation QQMusicOperationTool

+ (instancetype)sharedInstance
{
    static QQMusicOperationTool * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QQMusicOperationTool alloc]init];
    });
    return instance;
}

- (void)playMusicWithMusicMsg:(QQMusicListModel *)model
{
    self.currentPlayer = [self.audioTool playMusicWithModel:model.filename];
    self.currentPlayIndex = [self.musicMsgs indexOfObject:model];
}

- (void)playPreMusic
{
    self.currentPlayIndex--;
    [self playMusic];
}
- (void)playMusic
{
    QQMusicListModel * model = self.musicMsgs[self.currentPlayIndex];
    [self playMusicWithMusicMsg:model];
}
- (void)playNextMusic
{
    self.currentPlayIndex++;
    [self playMusic];

}
- (void)pauseMusic
{
    [self.audioTool pauseMusic];
}

- (void)stopMusic
{
    [self.audioTool stopMusic];
}

- (void)playCurrentMusic
{
    [self playMusic];
}
- (void)setUpLockMessage
{
    MPNowPlayingInfoCenter *playInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // MPMediaItemPropertyAlbumTitle
    // MPMediaItemPropertyAlbumTrackCount
    // MPMediaItemPropertyAlbumTrackNumber
    // MPMediaItemPropertyArtist
    // MPMediaItemPropertyArtwork
    // MPMediaItemPropertyComposer
    // MPMediaItemPropertyDiscCount
    // MPMediaItemPropertyDiscNumber
    // MPMediaItemPropertyGenre
    // MPMediaItemPropertyPersistentID
    // MPMediaItemPropertyPlaybackDuration
    // MPMediaItemPropertyTitle
    /*
     @property (nonatomic,copy) NSString *name;
     @property (nonatomic,copy) NSString *filename;
     @property (nonatomic,copy) NSString *lrcname;
     @property (nonatomic,copy) NSString *singer;
     @property (nonatomic,copy) NSString *singerIcon;
     @property (nonatomic,copy) NSString *icon;

     */
    QQMusicMessageModel * msg = self.musicMsgModel;
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:msg.musicMsg.icon]];

    NSDictionary * playInfiDict = @{
                                    MPMediaItemPropertyAlbumTitle:msg.musicMsg.name,
                                    MPMediaItemPropertyArtist:msg.musicMsg.singer,
                                    MPMediaItemPropertyArtwork:artwork,
                                    MPMediaItemPropertyPlaybackDuration:@(msg.totalTime),
                                    MPMediaItemPropertyRating:@(1.0),
                                    //进度条
                                    MPNowPlayingInfoPropertyElapsedPlaybackTime:@(msg.costTime),
                                    MPNowPlayingInfoPropertyPlaybackRate:@(1.0)
                                    };
    [playInfoCenter setNowPlayingInfo:playInfiDict];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
}
- (void)trackSliderState:(double)progress
{
    [self.audioTool seekToTimeInterval:self.musicMsgModel.totalTime *progress];
}

/**
 *  重写音乐信息数据模型的get方法, 在这个方法里面保证数据的最新状态(此处利用的"拉模式", 不主动告诉外界最新信息, 让外界通过某些方法, 直接通过访问这个字段获取)
 *
 */
- (QQMusicMessageModel *)musicMsgModel
{
    if (!_musicMsgModel) {
        _musicMsgModel = [[QQMusicMessageModel alloc] init];
    }
    
    // 保证信息的最新状态
    QQMusicListModel *musicModel = self.musicMsgs[self.currentPlayIndex];
    _musicMsgModel.musicMsg = musicModel;
    
    // 已经播放时长
    _musicMsgModel.costTime = self.currentPlayer.currentTime;
    // 总时长
    _musicMsgModel.totalTime = self.currentPlayer.duration;
    // 播放的状态
    _musicMsgModel.isPlaying = self.currentPlayer.isPlaying;
    
    return _musicMsgModel;
}

/**
 *  重写当前播放索引的set方法, 在这个方法中进行过滤(防止错误数值的产生)
 *
 *  @param currentPlayIndex 当前播放索引
 */
-(void)setCurrentPlayIndex:(NSInteger)currentPlayIndex
{
    
    if (currentPlayIndex < 0) {
        currentPlayIndex = self.musicMsgs.count - 1;
    }else {
        currentPlayIndex = currentPlayIndex % self.musicMsgs.count;
    }
    _currentPlayIndex = currentPlayIndex;
}


- (QQMusicTool *)audioTool
{
    if(!_audioTool){
        _audioTool = [[QQMusicTool alloc]init];
    }
    return _audioTool;
}
@end
