//
//  CALayer+Animation.m
//  QQMusic
//
//  Created by admin on 2017/11/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CALayer+Animation.h"

@implementation CALayer (Animation)
/*
 beginTime :动画延迟开始的时间
 speed是一个时间的倍数,默认为1.0,当设为2的时候,duration为1的动画或图层会被缩短至0.5
 timeOffset是表示快进到某一点,如设为0.5, duration为1的动画会从0.5的时间开始

 */
- (void)pauseAnimate
{
    CFTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0;
    self.timeOffset = pauseTime;
}
- (void)resumeAnimate
{
    CFTimeInterval pauseTime = self.timeOffset;
    self.speed = 1;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.beginTime = timeSincePause;
}
@end
