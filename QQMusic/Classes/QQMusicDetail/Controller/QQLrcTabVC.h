//
//  QQLrcTabVC.h
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQLrcModel.h"
@interface QQLrcTabVC : UITableViewController
@property (nonatomic,strong) NSArray<QQLrcModel *> *lrcModelArr;
@property (nonatomic,assign) NSUInteger scrollRow;
@property (nonatomic,assign) CGFloat drawScale;

@end
