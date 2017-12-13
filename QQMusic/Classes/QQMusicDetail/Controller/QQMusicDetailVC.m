//
//  QQMusicDetailVC.m
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQMusicDetailVC.h"
#import "QQMusicOperationTool.h"
#import "QQMusicDataTool.h"
#import "QQLrcTabVC.h"
#import "QQMusicMessageModel.h"
#import "GetTimeTool.h"
#import "QQMusicDataTool.h"
#import "LrcLabel.h"
#import <YYKit.h>
#import "CALayer+Animation.h"
#import "QQLrcDataTool.h"
@interface QQMusicDetailVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *playingTime;
@property (weak, nonatomic) IBOutlet UILabel *timeCost;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet LrcLabel *lrcMsg;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *lrcScrollView;
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;

/** 歌词视图 **/
@property (nonatomic,strong) QQLrcTabVC *lrcVC;
/** 负责一直更新的timer**/
@property (nonatomic,strong) NSTimer *timer;
/** 负责更新歌词的定时器**/
@property (nonatomic,strong) CADisplayLink * link;

@end

@implementation QQMusicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInit];
    
}
- (void)setUpInit
{
    [self.lrcScrollView addSubview:self.lrcVC.tableView];
    self.lrcScrollView.pagingEnabled = YES;
    self.lrcScrollView.showsHorizontalScrollIndicator = NO;
    self.lrcScrollView.delegate = self;
    //设置图片圆形
    self.backImage.layer.masksToBounds = YES;
    self.backImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.backImage.layer.borderWidth = 6;
    
    //设置UISlider图片
    UIImage * thumbImage = [UIImage imageNamed:@"player_slider_playback_thumb"];;
    [self.sliderProgress setThumbImage:thumbImage forState:(UIControlStateNormal)];
    
    //设置代理
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupOnce];
    [self addTimer];
    [self addLink];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
    [self removeLink];
}

//歌曲切换时,需要更新的一次操作
- (void)setupOnce
{
    QQMusicMessageModel * msg = [QQMusicOperationTool sharedInstance].musicMsgModel;
    
    self.playingTime.text = [GetTimeTool getTimeFomat:msg.costTime];
    
    self.timeCost.text = [GetTimeTool getTimeFomat:msg.totalTime];
    
    self.songName.text = msg.musicMsg.name;
    
    self.singer.text = msg.musicMsg.singer;
    
    self.backImage.image = [UIImage imageNamed:msg.musicMsg.icon];
    
    self.sliderProgress.value = (1.0 * msg.costTime) / msg.totalTime;;
    
    // 开始旋转图片
    [self addRotationAnimation];
    if (msg.isPlaying) {
        NSLog(@"继续旋转");
        [self resumeRotationAnimation];
    }else
    {
        NSLog(@"暂停旋转");
        [self pauseRotationAnimation];
    }
    
    //lrcVC数据源
    self.lrcVC.lrcModelArr = [QQLrcDataTool getLrc:msg.musicMsg.lrcname];

}

//添加timer
- (void)addTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateMusicMessage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
   
    [self.timer fire];
}
//移除timer
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

//添加更新歌词的link
- (void)addLink
{
    CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}


- (void)removeLink
{
    [self.link invalidate];
    self.link = nil;
}

//当歌曲进行时,频繁的更新
- (void)updateMusicMessage
{
    QQMusicMessageModel * msg = [QQMusicOperationTool sharedInstance].musicMsgModel;
    
    self.playingTime.text = [GetTimeTool getTimeFomat:msg.costTime];
    
    self.playBtn.selected = msg.isPlaying;
    
    self.sliderProgress.value = (1.0 * msg.costTime) / msg.totalTime;;
}

- (void)updateLrc
{
    QQMusicMessageModel * messageModel = [QQMusicOperationTool sharedInstance].musicMsgModel;
    
    // 计算当前播放时间, 对应的歌词行号
    NSInteger row = [QQLrcDataTool getRowWithCurrentTime:messageModel.costTime andLrcMs:self.lrcVC.lrcModelArr];
    
    // 把需要滚动的行号, 交给歌词控制器统一管理, 让歌词控制器负责滚动
    self.lrcVC.scrollRow = row;
    
    
    // 显示歌词label
    // 取出当前正在播放的歌词数据模型
    QQLrcModel *lrcM = self.lrcVC.lrcModelArr[row];
    self.lrcMsg.text = lrcM.content;
    
    // 计算一行歌词的播放进度
    self.lrcMsg.scale = (messageModel.costTime - lrcM.begainTime) / (lrcM.endTime - lrcM.begainTime);
    
    // 传值给歌词控制器, 让歌词控制器的歌词负责进度展示
    self.lrcVC.drawScale = self.lrcMsg.scale;
    
    /** 更新锁屏界面的信息 */
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        [[QQMusicOperationTool sharedInstance] setUpLockMessage];
    }
}

- (IBAction)prePlayMusic:(id)sender {
    
    [[QQMusicOperationTool sharedInstance] playPreMusic];
    
    [self setupOnce];
}

- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(!sender.selected)
    {
        [[QQMusicOperationTool sharedInstance] pauseMusic];
        [self pauseRotationAnimation];

    }else{
        [[QQMusicOperationTool sharedInstance] playCurrentMusic];
        [self resumeRotationAnimation];
    }
}
- (IBAction)popVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)playNextMusic:(id)sender {
    [[QQMusicOperationTool sharedInstance] playNextMusic];
    [self setupOnce];
}
- (IBAction)SlidertouchUp:(id)sender {
    [self resumeRotationAnimation];
    self.playBtn.selected = YES;
    [[QQMusicOperationTool sharedInstance] playCurrentMusic];
    
}

- (IBAction)touchDown:(id)sender {
    [self pauseRotationAnimation];
    self.playBtn.selected = NO;
    [[QQMusicOperationTool sharedInstance] pauseMusic];

}
- (IBAction)dragInside:(id)sender {

}
- (IBAction)valueChange:(UISlider *)sender {
    
    [[QQMusicOperationTool sharedInstance] trackSliderState:sender.value];
}


//锁屏事件接收
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    /*
    typedef NS_ENUM(NSInteger, UIEventSubtype) {
        // available in iPhone OS 3.0
        UIEventSubtypeNone                              = 0,
        
        // for UIEventTypeMotion, available in iPhone OS 3.0
        UIEventSubtypeMotionShake                       = 1,
        
        // for UIEventTypeRemoteControl, available in iOS 4.0
        UIEventSubtypeRemoteControlPlay                 = 100,
        UIEventSubtypeRemoteControlPause                = 101,
        UIEventSubtypeRemoteControlStop                 = 102,
        UIEventSubtypeRemoteControlTogglePlayPause      = 103,
        UIEventSubtypeRemoteControlNextTrack            = 104,
        UIEventSubtypeRemoteControlPreviousTrack        = 105,
        UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
        UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
        UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
        UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    };*/
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [[QQMusicOperationTool sharedInstance]playCurrentMusic];
            break;
        case UIEventSubtypeRemoteControlPause:
             [[QQMusicOperationTool sharedInstance]pauseMusic];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self prePlayMusic:nil];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self playNextMusic:nil];
            break;
        default:
            break;
    }
}

//摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self playNextMusic:nil];
}
- (void)addRotationAnimation
{
    [self.backImage.layer removeAnimationForKey:@"rotation"];
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"rotation"];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@0,@(M_PI *2)];
    anim.duration = 10;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    [self.backImage.layer addAnimation:anim forKey:@"rotation"];
}
- (void)pauseRotationAnimation
{
    [self.backImage.layer pauseAnimate];
}
- (void)resumeRotationAnimation
{
    [self.backImage.layer resumeAnimate];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.lrcVC.tableView.frame = self.lrcScrollView.bounds;
    self.lrcVC.tableView.left = self.lrcScrollView.width;
    
    self.lrcScrollView.contentSize = CGSizeMake(self.lrcScrollView.width * 2, 0);
    self.backImage.layer.cornerRadius = self.backImage.width * 0.5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat alpha = 1 - offset / self.lrcScrollView.frame.size.width;
    self.backImage.alpha = alpha;
    self.lrcMsg.alpha = alpha;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleLightContent;
}

- (QQLrcTabVC *)lrcVC
{
    if(!_lrcVC){
        _lrcVC = [[QQLrcTabVC alloc]init];
        [self addChildViewController:_lrcVC];
    }
    return _lrcVC;
}

#pragma mark - Navigation

@end
