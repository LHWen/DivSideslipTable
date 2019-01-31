//
//  ViewController.m
//  DivSideslipTable
//
//  Created by LHWen on 2018/12/11.
//  Copyright © 2018 LHWen. All rights reserved.
//

#import "ViewController.h"
#import "SideslipTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = UIColor.orangeColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13.0f, 0, 0);
        [_tableView registerClass:[SideslipTableViewCell class] forCellReuseIdentifier:@"kCell"];
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray new];
    [_dataArr addObjectsFromArray:@[@"Abxndk", @"Bsdfsdfs", @"CDsfewe", @"Dsewrewre", @"Efsdk", @"Fsdssapi"]];
    
    [self.view addSubview:self.tableView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    for(SideslipTableViewCell *tmpCell in _tableView.visibleCells) {
        [tmpCell closeMenuWithCompletionHandle:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideslipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.testLb.text=_dataArr[indexPath.row];
    __weak typeof(self) wkSelf=self;
    __weak typeof(cell) wkCell=cell;
    
    // 置顶
    cell.topCallBack=^{
        //关闭菜单
        [wkCell closeMenuWithCompletionHandle:^{
            NSString *topString = wkSelf.dataArr[indexPath.row];
            [wkSelf.dataArr removeObjectAtIndex:indexPath.row];
            [wkSelf.dataArr insertObject:topString atIndex:0];
            [wkSelf.tableView reloadData];
            
        }];
    };
    //删除的回调
    cell.deleteCallBack=^{
        //关闭菜单
        [wkCell closeMenuWithCompletionHandle:^{
            //发送删除请求
            //若请求成功，则从数据源中删除以及从界面删除
            [wkSelf.dataArr removeObjectAtIndex:indexPath.row];
            [wkSelf.tableView reloadData];
        }];
    };
    
    // 左右滑动的回调
    cell.swipCallBack=^{
        for(SideslipTableViewCell *tmpCell in tableView.visibleCells)
            [tmpCell closeMenuWithCompletionHandle:nil];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}


@end
