//
//  QQLrcModel.h
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface QQLrcModel : NSObject
@property (nonatomic,assign) NSTimeInterval begainTime;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,copy) NSString *content;

@end
