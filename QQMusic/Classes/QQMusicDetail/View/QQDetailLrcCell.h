//
//  QQDetailLrcCell.h
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQLrcModel.h"
@interface QQDetailLrcCell : UITableViewCell
@property (nonatomic,strong) QQLrcModel *model;
@property (nonatomic,assign) CGFloat drawScale;

@end
