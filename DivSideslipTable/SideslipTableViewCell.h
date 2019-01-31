//
//  SideslipTableViewCell.h
//  DivSideslipTable
//
//  Created by LHWen on 2018/12/11.
//  Copyright © 2018 LHWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, StateButtonType) {
    StateButtonTypeTop = 10001, // 置顶
    StateButtonTypeState, // 状态
    StateButtonTypeDelete, // 删除
    StateButtonTypeSuccess, // 合作成功
    StateButtonTypeFaile, // 合作失败
    StateButtonTypeWorking, // 营商中
    StateButtonTypeOther,
};

@interface SideslipTableViewCell : UITableViewCell

/**标记左滑菜单是否打开*/
@property(nonatomic,assign,readonly)BOOL isOpen;
/**测试文字*/
@property(nonatomic,strong)UILabel *testLb;
/**置顶的回调*/
@property(nonatomic,copy)void (^topCallBack)();
/**删除的回调*/
@property(nonatomic,copy)void (^deleteCallBack)();
/***左后滑动的回调*/
@property(nonatomic,copy)void (^swipCallBack)();

/**
 *  关闭左滑菜单
 *  completionHandle 完成后的回调
 */
- (void)closeMenuWithCompletionHandle:(void (^)(void))completionHandle;

@end

NS_ASSUME_NONNULL_END
