//
//  ViewController.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ViewController.h"
#import "VideoCell.h"
#import "VideoViewModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) VideoViewModel *videoVM;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation ViewController
- (VideoViewModel *)videoVM{
    if (!_videoVM) {
        _videoVM=[VideoViewModel new];
    }
    return _videoVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self.videoVM refreshDataCompletionHandle:^(NSError *error) {
           [_tableView.header endRefreshing];
           [_tableView reloadData];
       }];
    }];
    [_tableView.header beginRefreshing];
    
    _tableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.videoVM getMoreDataCompletionHandle:^(NSError *error) {
            [_tableView.footer endRefreshing];
            [_tableView reloadData];
        }];
    }];
}
#pragma mark - UITableView 注意是Group形式,以section区分
//设置section头部高度1像素， 高度最小是1
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
//设置secion脚部高度9像素
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 9;
}
//row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
// 720 *540
    CGFloat heigth= kWindowW * 540.0 / 720;
    return heigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLb.text = [self.videoVM titleForRow:indexPath.section];
    cell.descLb.text = [self.videoVM descForRow:indexPath.section];
    [cell.iconBtn setBackgroundImageForState:0 withURL:[self.videoVM iconURLForRow:indexPath.section]];
    cell.videoURL=[self.videoVM videoURLForRow:indexPath.section];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.videoVM.rowNumber;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
