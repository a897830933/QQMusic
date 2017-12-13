//
//  QQLrcTabVC.m
//  QQMusic
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QQLrcTabVC.h"
#import "QQDetailLrcCell.h"
static NSString * cellID = @"QQDetailLrcCell";

@interface QQLrcTabVC ()

@end

@implementation QQLrcTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabView];
}


- (void)setupTabView
{
   // [self.tableView registerNib:[UINib nibWithNibName:@"QQDetailLrcCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setLrcModelArr:(NSArray<QQLrcModel *> *)lrcModelArr
{
    _lrcModelArr = lrcModelArr;
    [self.tableView reloadData];
}
- (void)setScrollRow:(NSUInteger)scrollRow
{
    if(_scrollRow == scrollRow) return;
    _scrollRow = scrollRow;
    
    // 获取需要滚动的indexpath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_scrollRow inSection:0];
    
    // 刷新表格
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    
    // 滚动到对应行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    });
}
- (void)setDrawScale:(CGFloat)drawScale
{
    _drawScale = drawScale;
    // 1. 获取当前的行号
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.scrollRow inSection:0];
    // 2. 取出对应的cell
    QQDetailLrcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // 3. 设置进度
    cell.drawScale = _drawScale;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // 设置tableview内边距, 可以让第一行和最后一行歌词显示到中间位置
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
    
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 同样不要忘记设置xib中的循环利用标识
    static NSString *cellID = @"QQDetailLrcCell";
    
    // 从缓存池获取
    QQDetailLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // 如果缓存池获取为空, 则从xib中加载
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QQDetailLrcCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    QQDetailLrcCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    QQLrcModel *lrcModel = self.lrcModelArr[indexPath.row];
    cell.model = lrcModel;
    if(self.scrollRow == indexPath.row)
    {
        cell.drawScale = self.drawScale;
    }else{
        cell.drawScale = 0;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
