//
//  LrcLabel.m
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LrcLabel.h"

@implementation LrcLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGRect dRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width*self.scale, rect.size.height);
    [[UIColor greenColor] set];
    UIRectFillUsingBlendMode(dRect, kCGBlendModeSourceIn);
}
@end
