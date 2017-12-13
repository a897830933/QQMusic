//
//  QQMusicListVC.m
//  QQMusic
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQMusicListVC.h"
#import "QQMusicDataTool.h"
#import "QQMusicListCell.h"
#import "QQMusicOperationTool.h"
#import <AVFoundation/AVFoundation.h>
@interface QQMusicListVC ()<UITableViewDelegate>
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation QQMusicListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [QQMusicDataTool getMusicModel];
    [QQMusicOperationTool sharedInstance].musicMsgs = self.dataArr;
    [self setupInit];
  
}
- (void)setupInit
{
    [self setupTabView];
}
- (void)setupTabView
{
    self.tableView.delegate = self;
    [self.tableView registerNib: [UINib nibWithNibName:@"QQMusicListCell" bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QQListBack"]];
    self.tableView.backgroundView = imageView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QQMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.dataModel = self.dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation.z";
    anim.values = @[@(-M_PI/6),@0,@(M_PI/6),@0];
    anim.duration = 2;
    anim.repeatCount = 2;
    [cell.layer addAnimation:anim forKey:nil];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [QQMusicOperationTool sharedInstance].musicMsgs = self.dataArr;
    [[QQMusicOperationTool sharedInstance] playMusicWithMusicMsg:self.dataArr[indexPath.row]];
    [self performSegueWithIdentifier:@"listToDetailVC" sender:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
