//
//  ViewController.m
//  SRBarrageFactoryDemo
//
//  Created by 郭伟林 on 2017/8/2.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRBarrageView.h"
#import "FMBarrageModel.h"
#import "FMBarrageCell.h"
#import "DMHeartFlyView.h"

@interface ViewController () <SRBarrageViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) SRBarrageView *barrageView;

@property (nonatomic, assign) CGFloat currentTime;

@end

@implementation ViewController

- (IBAction)reloadAction:(UIBarButtonItem *)sender {
    
    _currentTime = 0.0;
    [self.datas removeAllObjects];
    [self setupFakeDatas];
    [self.barrageView reloadBarrage];
}

- (IBAction)pauseRollingAction:(id)sender {
    
    [self.barrageView pauseRollingBarrage];
}

- (IBAction)resumeRolling:(id)sender {
    
    [self.barrageView resumeRollingBarrage];
}

- (NSMutableArray *)datas {
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    SRBarrageView *barrageView = [[SRBarrageView alloc] init];
    barrageView.frame = CGRectMake(0, 64, self.view.frame.size.width, 300);
    barrageView.backgroundColor = [UIColor blackColor];
    barrageView.delegate = self;
    [self.view addSubview:barrageView];
    _barrageView = barrageView;
    
    [self setupFakeDatas];
    [self.barrageView reloadBarrage];
}

- (void)setupFakeDatas {
    
    for (int i = 0; i < 10; i++) {
        FMBarrageModel *model1 = [[FMBarrageModel alloc] init];
        model1.launchTime = arc4random_uniform(6);
        model1.duration = arc4random_uniform(6);
        model1.content = [[NSMutableAttributedString alloc] initWithString:@"我是弹幕1"];
        [self.datas addObject:model1];
        
        FMBarrageModel *model2 = [[FMBarrageModel alloc] init];
        model2.launchTime = arc4random_uniform(11);
        model2.duration = arc4random_uniform(11);
        model2.content = [[NSMutableAttributedString alloc] initWithString:@"我是弹幕2我是弹幕2"];
        [self.datas addObject:model2];
        
        FMBarrageModel *model3 = [[FMBarrageModel alloc] init];
        model3.launchTime = arc4random_uniform(16);
        model3.duration = arc4random_uniform(16);
        model3.content = [[NSMutableAttributedString alloc] initWithString:@"我是弹幕3我是弹幕3我是弹幕3"];
        [self.datas addObject:model3];
    }
}

- (NSArray<id<SRBarrageModelDelegate>> *)barrageViewDatasource {
    
    return self.datas;
}

- (NSTimeInterval)barrageViewCurrentTime {
    
    _currentTime += 0.1;
    return _currentTime;
}

- (UIView *)barrageView:(SRBarrageView *)barrageView barrageCellForModel:(id<SRBarrageModelDelegate>)model {
    
    FMBarrageCell *cell = [FMBarrageCell barrageCell];
    cell.barrageModel = model;
    return cell;
}

- (void)barrageView:(SRBarrageView *)barrageView didClickBarrageCell:(UIView *)barrageCell atPoint:(CGPoint)point {
    
    NSLog(@"didClickBarrageCell: %@ atPoint: %@", barrageCell, NSStringFromCGPoint(point));
    DMHeartFlyView *heartFlyView = [[DMHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    heartFlyView.center = point;
    [barrageCell.superview addSubview:heartFlyView];
    [heartFlyView animateInView:barrageCell.superview];
}

@end
