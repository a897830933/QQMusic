//
//  QQDetailLrcCell.m
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQDetailLrcCell.h"
#import "LrcLabel.h"
@interface QQDetailLrcCell()
@property (weak, nonatomic) IBOutlet LrcLabel *lrcLabel;
@end
@implementation QQDetailLrcCell

- (void)setModel:(QQLrcModel *)model
{
    _model = model;
    self.lrcLabel.text = model.content;
}
- (void)setDrawScale:(CGFloat)drawScale{
    _drawScale = drawScale;
    self.lrcLabel.scale = drawScale;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
