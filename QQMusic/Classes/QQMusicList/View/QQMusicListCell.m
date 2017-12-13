
//
//  QQMusicListCell.m
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQMusicListCell.h"
@interface QQMusicListCell()
@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@end
@implementation QQMusicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.songImage.layer.cornerRadius = self.songImage.frame.size.width/2;
    self.songImage.layer.masksToBounds = YES;
}
- (void)setDataModel:(QQMusicListModel *)dataModel
{
    _dataModel = dataModel;
    self.songName.text = dataModel.name;
    self.singer.text = dataModel.singer;
    self.songImage.image = [UIImage imageNamed:dataModel.singerIcon];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
