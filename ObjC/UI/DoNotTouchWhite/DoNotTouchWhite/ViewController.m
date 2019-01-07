//
//  ViewController.m
//  DoNotTouchWhite
//
//  Created by 郭伟林 on 17/1/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

static int randomBlack;
static int highestScore;
static int count = 0;
static int score = 0;
static float timeInterval = 0.01;

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ViewController

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(action) userInfo:nil repeats:YES];
}

- (void)action {
    [self createBtns];
    
    [self moveBtns];
}

- (void)createBtns {
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width * 0.25;
    CGFloat btnH = 150;
    if (count % 72 == 0) {
        randomBlack = arc4random() % 4;
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(i * btnW, -btnH, btnW, btnH);
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            if (i == randomBlack) {
                [btn setBackgroundColor:[UIColor blackColor]];
                [btn addTarget:self action:@selector(blackBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn addTarget:self action:@selector(whiteBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
            [self.buttons addObject:btn];
        }
    }
    [self.view bringSubviewToFront:self.scoreLabel];
    count++;
}

- (void)moveBtns {
    static int speedY = 2;
    static int newY = 0;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = (UIButton *)[self.buttons objectAtIndex:i];
        newY = btn.frame.origin.y + speedY;
        CGRect frame = btn.frame; frame.origin.y = newY; btn.frame = frame;
        if (btn.frame.origin.y > [UIScreen mainScreen].bounds.size.height && btn.backgroundColor == [UIColor blackColor]) {
            [self whiteBtnPress:btn];
        }
    }
}

- (void)removeBtns {
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
}

#pragma mark - Actions

- (void)blackBtnPress:(UIButton *)btn {
    score += 1;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    if (score != 0 && score % 20 == 0) {
        [self speedUp];
    }
    btn.backgroundColor = [UIColor grayColor];
    btn.userInteractionEnabled = NO;
}

- (void)whiteBtnPress:(UIButton *)btn {
    [self.timer invalidate];
    if (score > highestScore) {
        highestScore = score;
    }
    NSString *str = [NSString stringWithFormat:@"您的得分:%d分", score];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"踩到白块啦." message:str delegate:self cancelButtonTitle:@"不玩啦" otherButtonTitles:@"重新开始", nil];
    [alert show];
}

- (void)speedUp {
    [self.timer invalidate];
    timeInterval *= 0.75;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(action) userInfo:nil repeats:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self removeBtns];
        self.scoreLabel.text = @"0";
        score = 0;
        timeInterval = 0.01;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    
    if (buttonIndex == 0) {
        exit(0);
    }
}

@end
