//
//  QQMusicListModel.h
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQMusicListModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *filename;
@property (nonatomic,copy) NSString *lrcname;
@property (nonatomic,copy) NSString *singer;
@property (nonatomic,copy) NSString *singerIcon;
@property (nonatomic,copy) NSString *icon;
@end
