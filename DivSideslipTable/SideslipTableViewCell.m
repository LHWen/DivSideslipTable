//
//  SideslipTableViewCell.m
//  DivSideslipTable
//
//  Created by LHWen on 2018/12/11.
//  Copyright © 2018 LHWen. All rights reserved.
//

#import "SideslipTableViewCell.h"

@interface SideslipTableViewCell ()

@property(nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *funcView; // 功能视图
@property (nonatomic, strong) UIView *stateView; // 状态视图

@end

@implementation SideslipTableViewCell

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        for(UIView *sub in self.contentView.subviews) {
            [sub removeFromSuperview];
        }
        [self createUI];
    }
    return self;
}

//创建UI
- (void)createUI {
    
    _funcView = [[UIView alloc] initWithFrame:CGRectMake(kWidth - 150, 0, 150, 50)];
    _funcView.backgroundColor = UIColor.whiteColor;
    
    _stateView = [[UIView alloc] initWithFrame:CGRectMake(kWidth - 150, 0, 150, 50)];
    _stateView.backgroundColor = UIColor.whiteColor;
    _stateView.hidden = YES;
    [self.contentView addSubview:_funcView];
    [self.contentView addSubview:_stateView];
    
    // 置顶按钮
    UIButton *topBtn = [self setButtonX:0 title:@"置顶" bColor:UIColor.grayColor btag:StateButtonTypeTop];
    [_funcView addSubview:topBtn];
    // 状态按钮
    UIButton *stateBtn = [self setButtonX:50 title:@"项目状态" bColor:UIColor.yellowColor btag:StateButtonTypeState];
    [_funcView addSubview:stateBtn];
    // 删除按钮
    UIButton *delBtn = [self setButtonX:100 title:@"删除" bColor:UIColor.redColor btag:StateButtonTypeDelete];
    [_funcView addSubview:delBtn];
    
    // 合作成功
    UIButton *successBtn = [self setButtonX:0 title:@"合作成功" bColor:UIColor.greenColor btag:StateButtonTypeSuccess];
    [_stateView addSubview:successBtn];
    // 合作失败
    UIButton *failerBtn = [self setButtonX:50 title:@"合作失败" bColor:UIColor.yellowColor btag:StateButtonTypeFaile];
    [_stateView addSubview:failerBtn];
    // 营商中
    UIButton *workingBtn = [self setButtonX:100 title:@"营商中" bColor:UIColor.orangeColor btag:StateButtonTypeWorking];
    [_stateView addSubview:workingBtn];
    
    //容器视图
    _containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    _containerView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_containerView];
    if(_isOpen)
        _containerView.center=CGPointMake(kWidth/2-150, _containerView.center.y);
    
    //测试Label
    _testLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWidth-20, 50)];
    [_containerView addSubview:_testLb];
    _testLb.text=@"我是左滑测试文字～";
    _testLb.backgroundColor=[UIColor whiteColor];
    
    //添加左滑手势
    UISwipeGestureRecognizer *swipLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    swipLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [_containerView addGestureRecognizer:swipLeft];
    
    //添加右滑手势
    UISwipeGestureRecognizer *swipRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
    swipRight.direction=UISwipeGestureRecognizerDirectionRight;
    [_containerView addGestureRecognizer:swipRight];
}

- (UIButton *)setButtonX:(CGFloat)bX title:(NSString *)title bColor:(UIColor *)bc btag:(NSInteger)tag {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(bX, 0, 50, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = bc;
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)clickButton:(UIButton *)sender {
    
    switch (sender.tag) {
        case StateButtonTypeTop: { // 置顶
            if(self.topCallBack)
                self.topCallBack();
            break;
        }
        case StateButtonTypeState: { // 合作商
            _stateView.hidden = NO;
            break;
        }
        case StateButtonTypeDelete: { // 删除
            if(self.deleteCallBack)
                self.deleteCallBack();
            break;
        }
        case StateButtonTypeSuccess: {
            NSLog(@"合作成功!");
            _stateView.hidden = YES;
            break;
        }
        case StateButtonTypeFaile: {
            NSLog(@"合作失败！");
            _stateView.hidden = YES;
            break;
        }
        case StateButtonTypeWorking: {
            NSLog(@"营商中!");
            _stateView.hidden = YES;
            break;
        }
            
            
        default:
            break;
    }
}

/**滑动手势*/
- (void)swip:(UISwipeGestureRecognizer *)sender {
    
    //滑动的回调
    if(self.swipCallBack)
        self.swipCallBack();
    
    //左滑
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(_isOpen)
            return;
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.center = CGPointMake(sender.view.center.x - 150, sender.view.center.y);
        }];
        _isOpen=YES;
    } else if(sender.direction == UISwipeGestureRecognizerDirectionRight) { //右滑
        if(!_isOpen)
            return;
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.center = CGPointMake(kWidth/2, sender.view.center.y);
        }];
        _isOpen=NO;
    }
}

/** 关闭左滑菜单 */
- (void)closeMenuWithCompletionHandle:(void (^)(void))completionHandle {
    if(!_isOpen)
        return;
    __weak typeof(self) wkSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        wkSelf.containerView.center = CGPointMake(kWidth/2, wkSelf.containerView.center.y);
    }completion:^(BOOL finished) {
        _stateView.hidden = YES;
        if(completionHandle)
            completionHandle();
    }];
    _isOpen = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
